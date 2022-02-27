//
//  CollectionViewController.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 12/02/2022.
//

import UIKit
import AlamofireImage
import NVActivityIndicatorView
import CoreData

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnToggle: UIButton!
    
    let refreshControl = UIRefreshControl()
    var count = 0
    var foodType = ""
    var toggleInCollection = false
    var isFromMain = false
    var dataArray = [String : Any]() { didSet {
       let object = self.dataArray[foodType] as? [Any]
        count = object?.count ?? 0
        
    }}
    var result = [NSManagedObject](){
        didSet {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    var activityIndicatorView: NVActivityIndicatorView!
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "FoodListDataModal")
    }()
    
    deinit{NotificationCenter.default.removeObserver(self)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        tableView.addSubview(refreshControl)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableView.isHidden = false
        self.collectionView.isHidden = true
//        let frame = CGRect(x: self.view.frame.size.width/2 - 20, y: self.view.frame.size.height/2 - 20, width: 40, height: 40)
//        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.gray, padding: 0)
//        self.view.addSubview(self.activityIndicatorView)
        
//        activityIndicatorView.stopAnimating()
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self?.fetchFav()
            }
        }
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
                                               object: persistentContainer.viewContext,
                                               queue: .main) { [weak self] _ in
            self?.fetchFav()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFav()
        self.lblHeader.text = isFromMain ? self.dataArray["name"] as? String : "Favourites"
        btnBack.isHidden = isFromMain ? false : true
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.reloadData()
        self.tableView.reloadData()
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
                self.result = try self.persistentContainer.viewContext.fetch(fetchRequest)
             
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
   
    
    @objc func refresh(_ sender: AnyObject) {
       
    }
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToggle(_ sender: Any) {
        self.toggleInCollection.toggle()
        if toggleInCollection {
            self.btnToggle.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
            self.tableView.isHidden = true
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }else{
            self.btnToggle.setImage(UIImage(systemName: "list.dash"), for: .normal)
            self.tableView.isHidden = false
            self.collectionView.isHidden = true
            self.tableView.reloadData()
        }
      
    }
}

extension CollectionViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFromMain ? count : self.result.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bodyCell", for: indexPath) as? bodyCell else {
            return UITableViewCell()
        }
        
        if isFromMain{
            let data = self.dataArray[foodType] as? [Any]
           
            let object = data?[indexPath.row] as! [String:Any]
            
            cell.imgView?.af_setImage(withURL: URL(string: object["image"] as! String)!,placeholderImage: nil)
            cell.imgView.layer.cornerRadius = 12
            cell.lblTitle.text = object["name"] as? String
        }else{
            let data = self.result[indexPath.row]
            
            cell.imgView?.af_setImage(withURL: URL(string: data.value(forKey: "image") as? String ?? "")!,placeholderImage: nil)
            cell.imgView.layer.cornerRadius = 12
            cell.lblTitle.text = data.value(forKey: "name") as? String ?? ""
        }
//
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentFoodDetailView(indexPath.row)

    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.05 * Double(indexPath.row),
//            animations: {
//                cell.alpha = 1
//        })
//    }
    
}

extension CollectionViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFromMain ? count : self.result.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? collectionCell else {
            return UICollectionViewCell()
        }
        if isFromMain{
            let data = self.dataArray[foodType] as? [Any]
           
            let object = data?[indexPath.row] as! [String:Any]
            
            cell.imgView?.af_setImage(withURL: URL(string: object["image"] as! String)!,placeholderImage: nil)
            cell.imgView.layer.cornerRadius = 12
            cell.lblTitle.text = object["name"] as? String
        }else{
            let data = self.result[indexPath.row]
            
            cell.imgView?.af_setImage(withURL: URL(string: data.value(forKey: "image") as? String ?? "")!,placeholderImage: nil)
            cell.imgView.layer.cornerRadius = 12
            cell.lblTitle.text = data.value(forKey: "name") as? String ?? ""
        }
//
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentFoodDetailView(indexPath.row)
    }
    func presentFoodDetailView(_ row : Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "foodDetailView") as! foodDetailView
       
        if isFromMain{
            let data = self.dataArray[foodType] as? [Any]
            let object = data?[row] as! [String:Any]
            vc.array = object
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let image = self.result[row].value(forKey: "image")
            let name = self.result[row].value(forKey: "name")
            let desc = self.result[row].value(forKey: "desc")
            let favData = ["name": name,
                           "desc" : desc,
                           "image":image]
            vc.array =  favData as [String : Any]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3.5, height: 190)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        cell.alpha = 0
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.05 * Double(indexPath.row),
//            animations: {
//                cell.alpha = 1
//        })
//    }
}

class collectionCell:UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var shadowView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        addShadow()
//        gradientView.setGradientBackground(colorTop: .white, colorBottom: .black)
    }
    
    private func addShadow() {
        shadowView.layer.cornerRadius = 12
//        shadowView.layer.masksToBounds = true
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 2
    }
}
