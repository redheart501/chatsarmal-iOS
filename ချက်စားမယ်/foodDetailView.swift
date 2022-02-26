//
//  foodDetailView.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 09/02/2022.
//

import Foundation
import UIKit
import AlamofireImage

class foodDetailView : UIViewController{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    var array : [String:String] = [:]
    
    override func viewDidLoad() {
        self.imgView?.af_setImage(withURL: URL(string: array["image"]!)!,placeholderImage: UIImage(named: "AppLogo"))
        self.lblTitle.text = array["name"]!
        self.textView.text = array["desc"]!
    }
}
