//
//  MoreAppsItem.swift
//  Angry Moon
//
//  Created by Jérémy Kerbidi on 24/01/2017.
//  Copyright © 2017 Jérémy Kerbidi. All rights reserved.
//

import UIKit
import Alamofire
import JASON

class MoreAppsItem {

    var name: String!
    var editor: String!
    var picture: UIImage!
    var rate: Int!
    var storLink: URL!
    var idApp: String!
    
    init(id: String, name: String, editor: String, rate: String, pic: String, storeLink: String, tab: UITableView) {
        self.idApp = id
        self.name = name
        self.editor = editor
        
        if let Rate = Int(rate) {
            self.rate = Rate
        }
        else {
            self.rate = 0
        }
        
        self.storLink = URL(string: storeLink)
        
        let preferences = UserDefaults.standard
        
        if (preferences.object(forKey: id) != nil){
            let Data = preferences.object(forKey: id) as! Data
            self.picture = UIImage(data: Data)
            
            OperationQueue.main.addOperation {
                tab.reloadData()
            }
        }
        else {
            Alamofire.request(pic).responseData { response in
                
                if let data = response.result.value {
                    self.picture = UIImage(data: data)
                    
                    let photo = UserDefaults.standard
                    photo.set(data, forKey: id)
                    photo.synchronize()
                }
                
                OperationQueue.main.addOperation {
                    tab.reloadData()
                }
            }
        }
    }
}
