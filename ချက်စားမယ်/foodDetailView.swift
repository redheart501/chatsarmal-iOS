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
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    var array : [String:Any] = [:]
    
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
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func clickClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
