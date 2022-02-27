//
//  foodDetailView.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 09/02/2022.
//

import Foundation
import UIKit
import AlamofireImage
import CoreData
class foodDetailView : UIViewController{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnFav: UIButton!
    var array : [String:Any] = [:]
    var isFav : Bool! = false
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "FoodListDataModal")
    }()
    
    override func viewDidLoad() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        textView.attributedText = NSAttributedString(string: (array["desc"]! as! String).replacingOccurrences(of: "\\n", with: "\n"), attributes:attributes)
        self.imgView?.af_setImage(withURL: URL(string: array["image"]! as! String)!,placeholderImage: UIImage(named: "AppLogo"))
        self.lblTitle.text = array["name"]! as? String
//        self.textView.text = (array["desc"]! as! String).replacingOccurrences(of: "\\n", with: "\n")
//        imgView.layer.cornerRadius = 20
        textView.layer.cornerRadius = 20
        closeBtn.layer.cornerRadius = 20

        
        
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self?.fetchFav()
            }
        }
        
        // Observe Managed Object Context
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
                                               object: persistentContainer.viewContext,
                                               queue: .main) { [weak self] _ in
            self?.fetchFav()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func clickFav(_ sender: Any) {
        isFav?.toggle()
        self.btnFav.setImage(UIImage(systemName: isFav ? "heart.fill": "heart"), for: .normal)
        
         let managedObjectContext = persistentContainer.viewContext
       
   
     
        do {
            // Save Book to Persistent Store
            if isFav{
                let foods = Receipe(context: managedObjectContext)
                foods.name =  array["name"]! as? String
                foods.desc =  array["desc"]! as? String
                foods.image =  array["image"]! as? String
            }else{
                let fetchRequest: NSFetchRequest<Receipe> = Receipe.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@",  array["name"]! as! String)
                let objects = try managedObjectContext.fetch(fetchRequest)
                      
                for object in objects as [NSManagedObject]{
                    managedObjectContext.delete(object)
                }
                    
                    
            }
           
           
            try managedObjectContext.save()
            // Dismiss View Controller
//            dismiss(animated: true)
        } catch {
            print("Unable to Save receipe, \(error)")
        }
        
    }
    @IBAction func clickClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchFav() {
        print(persistentContainer.viewContext)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Receipe> = Receipe.fetchRequest()
        
        // Perform Fetch Request
        persistentContainer.viewContext.perform {
            do {
                // Execute Fetch Request
//                let result = try fetchRequest.execute()
//                print(result,result.count)
                let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "name") as? String ?? "")
                    let name = data.value(forKey: "name") as? String ?? ""
                    if  name == self.array["name"]! as? String {
                        self.isFav = true
                        self.btnFav.setImage(UIImage(systemName: self.isFav ? "heart.fill": "heart"), for: .normal)
                    }
                  
                }
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
}
