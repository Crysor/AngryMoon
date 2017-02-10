//
//  CostumCell.swift
//  toDoList
//
//  Created by Ahmad Khawatmi on 13/05/16.
//  Copyright © 2016 Ahmad Khawatmi. All rights reserved.
//

import UIKit

class CostumCell: UITableViewCell {

    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet var circleInsideStar: UIImageView!
    @IBOutlet var tickButton: UIButton!
    @IBAction func tickButton(_ sender: AnyObject) {
       // tickButton.setBackgroundImage(UIImage(named: "tick.png"), forState: UIControlState.Normal)
    }
    
    var ctrl: ViewController!
    var index: Int = 0
    var Newlist: [String]!
    var userdef = UserDefaults.standard
    var tab: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editCell(_ sender: Any) {
        let alert = UIAlertController(title: "title_edit".localized, message: "body_edit".localized, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "btn_edit".localized, style: .default) { (_) in
            
            let nameTextField = alert.textFields![0] as UITextField
            self.cellLabel.text = nameTextField.text!
            var tab: [String] = list.reversed()
            
            tab[self.index] = nameTextField.text!
            let rev: [String] = tab.reversed()
            UserDefaults.standard.set(rev, forKey: "List")
            self.ctrl.updatingLabels()
        }
        editAction.isEnabled = false
        alert.addTextField { (textField) in
            textField.placeholder = "placeholder_rename".localized
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                editAction.isEnabled = textField.text != ""
            }
        }
        
        let cancel = UIAlertAction(title: "btn_cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(cancel)
        
        self.ctrl.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var cellLabel: UILabel!
    
    @IBOutlet var coloredLine: UIImageView!
}
