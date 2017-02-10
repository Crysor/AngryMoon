//
//  MoreAppsCellView.swift
//  Angry Moon
//
//  Created by Jérémy Kerbidi on 24/01/2017.
//  Copyright © 2017 Ahmad Khawatmi. All rights reserved.
//

import UIKit

class MoreAppsCellView: UITableViewCell {
    
    @IBOutlet weak var ViewApp: UIView!
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var titleApp: UILabel!
    @IBOutlet weak var authorApp: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var btnGetIt: UIButton!
    
    var getIt: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnGetIt.layer.cornerRadius = 5
        self.btnGetIt.setTitle("btn_getit".localized, for: .normal)
        self.ViewApp.layer.cornerRadius = 5
        self.imgApp.layer.cornerRadius = 20
        self.imgApp.clipsToBounds = true
    }
    
    @IBAction func getThisApp(_ sender: Any) {
        
        if let url = self.getIt {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
