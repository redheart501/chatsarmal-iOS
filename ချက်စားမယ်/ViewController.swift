//
//  ViewController.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 06/02/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import AlamofireImage
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var myArray = [[String:Any]]()
    var dataArray = [Any]()
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
         
        let frame = CGRect(x: self.view.frame.size.width/2 - 20, y: self.view.frame.size.height/2 - 20, width: 40, height: 40)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.gray, padding: 0)
        self.view.addSubview(self.activityIndicatorView)
        activityIndicatorView.startAnimating()
        getStoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getStoreData(){
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
//        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        let db = Firestore.firestore()
        let Receipt = db.collection("foodList")
        
        Receipt.getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    
//                    self.myArray.append([document.documentID:document.data()])
                    self.dataArray.append(document.data())
                    print(self.dataArray)
                   
                }
//                db.collection("foodList").document("pork").setData(["pork":self.dataArray])
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicatorView.stopAnimating()
                db.settings = settings
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.dataArray.removeAll()
        getStoreData()
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? listCell else {
            return UITableViewCell()
        }
        let object = self.dataArray[indexPath.row] as! [String:Any]
        
//        cell.gradientView.setGradientBackground(colorTop: .white, colorBottom: .black)
        cell.imgView?.af_setImage(withURL: URL(string: object["image"] as! String)!,placeholderImage: nil)
        cell.imgView.layer.cornerRadius = 12
        
        cell.lblTitle.text = object["name"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        let object = self.dataArray[indexPath.row] as! [String:Any]
        vc.foodType = (object["foodType"] as? String)!
        vc.dataArray = object
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}



class bodyCell : UITableViewCell{
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

class listCell : UITableViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    
    }
    
    private func addShadow() {
//        gradientView.layer.masksToBounds = true
        gradientView.layer.cornerRadius = 12
        gradientView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        gradientView.layer.shadowOpacity = 1
        gradientView.layer.shadowOffset = CGSize.zero
        gradientView.layer.shadowRadius = 2
    }
}



extension UIView{
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
}
