//
//  MoreAppsViewController.swift
//  Angry Moon
//
//  Created by Jérémy Kerbidi on 24/01/2017.
//  Copyright © 2017 Jérémy Kerbidi. All rights reserved.
//

import UIKit
import Alamofire
import JASON
import SwiftOverlays

class MoreAppsViewController: UITableViewController {
    
    var gtracker: TrackerGoogle!
    var Apps = [MoreAppsItem]()
    var url_request: String {
        let index = "\(Locale.current)".index("\(Locale.current)".startIndex, offsetBy: 3)
        let local = String("\(Locale.current)".characters.suffix(from: index)).lowercased()
        let localPars = String(local.characters.prefix(2))

        return "http://api.supreme.media:8080/request/IOS/Reminder/"+localPars+"/more_app"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "More Apps"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 26/255, green: 64/255, blue: 81/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = true
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showWaitOverlay()
        self.gtracker = TrackerGoogle()
        self.gtracker.setScreenName(name: "More Apps")
    }
    
    private func loadData() {
        
       Alamofire.request(self.url_request, method: .get).responseJSON { response in
            
            if (response.result.isSuccess) {
                print("success !")
                self.removeAllOverlays()
            }
            else {
                print("fail: \(response.error)")
                self.removeAllOverlays()
            }
            
            if let json = response.result.value {
                self.removeAllOverlays()
                let items = JSON(json)
                
                for item in items {
                    
                    self.Apps.append(MoreAppsItem(id: item["_id"].stringValue,name: item["appTitle"].stringValue, editor: item["companyname"].stringValue, rate: item["starNumber"].stringValue, pic: item["iconLink"].stringValue, storeLink: item["storeLink"].stringValue, tab: self.tableView))
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Apps.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let additionalSeparatorThickness = CGFloat(5)
        let additionalSeparator = UIView(frame: CGRect(x: 0, y: (cell.frame.size.height - additionalSeparatorThickness) + 1, width: cell.frame.size.width, height: additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor.clear
        additionalSeparator.alpha = CGFloat(0.5)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.contentView.addSubview(additionalSeparator)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! MoreAppsCellView
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! MoreAppsCellView
        
        let app_info = self.Apps[(indexPath as NSIndexPath).row]
        
        cell.titleApp.text = app_info.name
        cell.imgApp.image = app_info.picture
        cell.authorApp.text = app_info.editor
        cell.getIt = app_info.storLink
        
        let Stars = [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5]
        
        var rate: Int = app_info.rate
        
        if (rate >= 5) {
            rate = 5
        }
        else if (rate <= 1) {
            rate = 1
        }
        
        for i in 0..<rate {
            Stars[i]?.isHidden = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(100) //Choose your custom row height
    }
}
