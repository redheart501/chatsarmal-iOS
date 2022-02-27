//
//  AboutViewController.swift
//  ချက်စားမယ်
//
//  Created by Kyaw Ye Htun on 25/02/2022.
//

import Foundation
import UIKit

class AboutViewController : UIViewController{
    
    
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = version
        }
    }
}
