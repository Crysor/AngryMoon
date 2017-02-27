//
//  echoPush.swift
//  Angry Moon
//
//  Created by Jérémy Kerbidi on 21/02/2017.
//  Copyright © 2017 Jérémy Kerbidi. All rights reserved.
//

import UIKit
import Alamofire
import JASON


class echoPush {
    
    var gtracker: TrackerGoogle!
    
    var url_request: String {
        let index = "\(Locale.current)".index("\(Locale.current)".startIndex, offsetBy: 3)
        let local = String("\(Locale.current)".characters.suffix(from: index)).lowercased()
        let localPars = String(local.characters.prefix(2))
        
        return "http://api.supreme.media:8080/request/IOS/Reminder/"+localPars+"/push"
        //return "http://api.supreme.media:8080/request/IOS/MegaApp/us/push"
    }
    
    var view: UIViewController!
    var appT: String!
    var desc: String!
    var link: String!
    
    init(view: UIViewController) {
        self.view = view
        self.gtracker = TrackerGoogle()
    }
    
    func launchPopUpMode() {
        Alamofire.request(self.url_request, method: .get).responseJSON { response in
            
            if let json = response.result.value {
            
                let all = JSON(json)
                
                for info in all {
                    if (info["state"].stringValue == "ACTIVATE") {
                        let alert = UIAlertController(title: info["appTitle"].stringValue, message: info["description"].stringValue, preferredStyle: .alert)
                        let res = UIAlertAction(title: "get it", style: .default, handler: { Void in
                            self.gtracker.setEvent(category: "push", action: "get "+info["appTitle"].stringValue, label: "click")
                            if let url = URL(string: info["storeLink"].stringValue) {
                                
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                    // Fallback on earlier versions
                                }
                            }
                        })
                        let quit = UIAlertAction(title: "no thanks", style: .default, handler: { Void in
                            self.gtracker.setEvent(category: "push", action: "noThanks", label: "click")
                        })
                        alert.addAction(res)
                        alert.addAction(quit)
                        self.view.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func getPush(link: String) {
        print("get this link \(link)")
    }
}
