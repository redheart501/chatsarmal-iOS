//
//  CollectionViewController.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 12/02/2022.
//

import UIKit
import AlamofireImage
import NVActivityIndicatorView

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    
    let refreshControl = UIRefreshControl()
    var count = 0
    var dataArray = [String : Any]() { didSet {
       let object = self.dataArray["pork"] as? [Any]
        count = object?.count ?? 0
    }}
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
         
//        let frame = CGRect(x: self.view.frame.size.width/2 - 20, y: self.view.frame.size.height/2 - 20, width: 40, height: 40)
//        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.gray, padding: 0)
//        self.view.addSubview(self.activityIndicatorView)
        
//        activityIndicatorView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblHeader.text = self.dataArray["name"] as? String
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       
    }
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CollectionViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bodyCell", for: indexPath) as? bodyCell else {
            return UITableViewCell()
        }
        let data = self.dataArray["pork"] as? [Any]
       
        let object = data?[indexPath.row] as! [String:Any]
        cell.gradientView.setGradientBackground(colorTop: .white, colorBottom: .black)
        cell.imgView?.af_setImage(withURL: URL(string: object["image"] as! String)!,placeholderImage: nil)
        cell.imgView.layer.cornerRadius = 12
        cell.lblTitle.text = object["name"] as? String
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "foodDetailView") as! foodDetailView
        let data = self.dataArray["pork"] as? [Any]
       
        let object = data?[indexPath.row] as! [String:Any]
        vc.array = object
        self.present(vc, animated: true, completion: nil)
    }
    
}
