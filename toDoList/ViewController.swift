//
//  ViewController.swift
//  toDoList
//
//  Created by Ahmad Khawatmi on 13/05/16.
//  Copyright © 2016 Ahmad Khawatmi. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds


var list = [String]()     //the array which contains all the tasks

var deletedTasks = [String]()   // holds the deleted tasks
var achievedTasks = [String]()   // holds achieved tasks
var notificationTime = [Date]()    // holds notifications time
var taskColor = [String]()    //the color of the task
var marked = [String]()       //holds if the task is done or not

var choosingColor = [String]()   //takes the appended colors from the colors button

var taskMinosAchieved = 0


class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADNativeExpressAdView!
    var admobInterstitial : GADInterstitial?
     var timerAds : Timer?
    
    @IBOutlet var stateAchieved: UIImageView!
    @IBOutlet var stateNotAchieved: UIImageView!
    @IBOutlet var opacityMoon: UIImageView!
    @IBOutlet var notAchievedLabel: UILabel!
    @IBOutlet var achievedLabel: UILabel!
    
    @IBOutlet var taskField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var hidingappearingstatsButton: UIButton!
    @IBAction func hidingappearingStats(_ sender: AnyObject) {
        
        updatingLabels()
        
        //print(stateAchieved.center.x)
        if UIScreen.main.nativeBounds.height == 2208
        {
         compitableImagesForIPhone6Plus()
        }
        else if UIScreen.main.nativeBounds.height == 960
        {
            compitableImagesForIPhone4s()
        }
        else if UIScreen.main.nativeBounds.height == 1024
        {
            compitableImagesforiPadClassic()
        }
        else if UIScreen.main.nativeBounds.height == 2048
        {
            compitableImagesforiPadRetina()
        }
        else if UIScreen.main.nativeBounds.height == 2732
        {
            compitableImagesforiPadPro()
        }
        else if UIScreen.main.nativeBounds.height == 1136
        {
            compitableImagesforiPhone5s()
        }
        
        else
        {
        if stateAchieved.center.x == 286.0
        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 75, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 75, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 75, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 75, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            
            counter = 0
            
           // stateAchieved.hidden = false
           // stateNotAchieved.hidden = false
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 75, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 75, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 75, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 75, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            //stateAchieved.hidden = true
            //stateNotAchieved.hidden = true
            
        }
        }
        
    }
    
    @IBOutlet var addSettingButton: UIButton!
    @IBOutlet var addSettingImage: UIImageView!
    @IBAction func addSetting(_ sender: AnyObject) {
        
        if extraOption == true
        {
        addSettingImage.isHidden = false
        addSettingButton.setBackgroundImage(UIImage(named: "X-button1.png"), for: UIControlState())
            extraOption = false
            datePicker.isHidden = false
            fireBtn.isHidden = false
            
            redButton.isHidden = false
            greenButton.isHidden = false
            orangeButton.isHidden = false
          
            
            taskField.resignFirstResponder()

        }
        else
        {
            addSettingImage.isHidden = true
            addSettingButton.setBackgroundImage(UIImage(named: "showSetting.png"), for: UIControlState())
            extraOption = true
            datePicker.isHidden = true
            fireBtn.isHidden = true
            
            redButton.isHidden = true
            greenButton.isHidden = true
            orangeButton.isHidden = true
           
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var fireBtn: UIButton!  // fire the notificatin to ring in background
    @IBAction func fireNotification(_ sender: AnyObject) {
        
    addToList()
        
        addSettingImage.isHidden = true
        addSettingButton.setBackgroundImage(UIImage(named: "showSetting.png"), for: UIControlState())
        extraOption = true
        datePicker.isHidden = true
        fireBtn.isHidden = true
    }
    
    var red = false
    var orange = false
    var green = false
    
    @IBOutlet var redButton: UIButton!
    @IBOutlet var orangeButton: UIButton!
    @IBOutlet var greenButton: UIButton!
    
    @IBAction func redBtn(_ sender: AnyObject) {
        
        red = true
        orange = false
        green = false
        //taskColor.append("Red")
        choosingColor.append("Red")
        redButton.setBackgroundImage(UIImage(named: "checkRed.png"), for: UIControlState())
        greenButton.setBackgroundImage(nil, for: UIControlState())
        orangeButton.setBackgroundImage(nil, for: UIControlState())

    }
    @IBAction func orangeBtn(_ sender: AnyObject) {
        orange = true
        red = false
        green = false
        //taskColor.append("Orange")
        choosingColor.append("Orange")
        
        orangeButton.setBackgroundImage(UIImage(named: "checkOrange.png"), for: UIControlState())
        greenButton.setBackgroundImage(nil, for: UIControlState())
        redButton.setBackgroundImage(nil, for: UIControlState())

    }
    
    @IBAction func greenBtn(_ sender: AnyObject) {
        green = true
        red = false
        orange = false
       // taskColor.append("Green")
        choosingColor.append("Green")
        
        greenButton.setBackgroundImage(UIImage(named: "checkGreen.png"), for: UIControlState())
        redButton.setBackgroundImage(nil, for: UIControlState())
        orangeButton.setBackgroundImage(nil, for: UIControlState())

    }
 
    @IBOutlet var nervous1: UIImageView!
    @IBOutlet var nervous2: UIImageView!
    
    @IBOutlet var leftFlower: UIImageView!
    @IBOutlet var leftDownFlower: UIImageView!
    @IBOutlet var rightFlower: UIImageView!
    @IBOutlet var rightDownFlower: UIImageView!
    @IBOutlet var downFlower: UIImageView!
    
    
    var extraOption = false
    
    var timer = Timer()
    var counter = 0
    var outside = true
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var wantDelete = false
    
    var completedTask = true
    var deletedTask = true
    
    
    var gtracker: TrackerGoogle!
    
    
    //VIEW DID LOAD IS HERE =====================================================================
    @IBAction func MoreApps(_ sender: Any) {
        self.gtracker.setEvent(category: "home", action: "moreapps", label: "click")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.gtracker = TrackerGoogle()
        self.gtracker.setScreenName(name: "Home")
        self.taskField.placeholder = "new_task_placeholder".localized
        
       //print(UIScreen.mainScreen().nativeBounds.height)
        //print(stateAchieved.center.x,"  once starts")
        
        stateAchieved.alpha = 0.8
        stateNotAchieved.alpha = 0.8
        
        addSettingImage.isHidden = true
        datePicker.isHidden = true
        fireBtn.isHidden = true
        extraOption = true
        
        redButton.isHidden = true
        greenButton.isHidden = true
        orangeButton.isHidden = true
        
        if (UIScreen.main.nativeBounds.height == 2208) || ( UIScreen.main.nativeBounds.height == 960 ) || (UIScreen.main.nativeBounds.height == 1024) || (UIScreen.main.nativeBounds.height == 2048) || (UIScreen.main.nativeBounds.height == 2732) || (UIScreen.main.nativeBounds.height == 1136)
        {
            hidingappearingstatsButton.isHidden = true
            //delay appearing of the buttons until it finishes animating
            //TODO
            let time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(4 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)

            DispatchQueue.main.asyncAfter(deadline: time) {
                //put your code which should be executed with a delay here
                self.hidingappearingstatsButton.isHidden = false
            }
            
        }

        
        if outside == true
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
            outside = false
        }
        
        //getting back the saved objects (loading)
        
        if UserDefaults.standard.object(forKey: "List") != nil
        {
            list = UserDefaults.standard.object(forKey: "List") as! [String]
        }
        if UserDefaults.standard.object(forKey: "Achieved") != nil
        {
            achievedTasks = UserDefaults.standard.object(forKey: "Achieved") as! [String]

        }
        if UserDefaults.standard.object(forKey: "Timer") != nil
        {
            notificationTime =  UserDefaults.standard.object(forKey: "Timer") as! [Date]
        }
        if UserDefaults.standard.object(forKey: "Color") != nil
        {
            taskColor =  UserDefaults.standard.object(forKey: "Color") as! [String]
        }
        if UserDefaults.standard.object(forKey: "done") != nil
        {
            marked =  UserDefaults.standard.object(forKey: "done") as! [String]
        }
        if UserDefaults.standard.object(forKey: "netNumber") != nil
        {
            taskMinosAchieved =  UserDefaults.standard.object(forKey: "netNumber") as! Int
        }
        
        taskField.delegate = self
        
        opasityMoon()
        updatingLabels()
        //hiding the keyboard once pressed on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        self.taskField.delegate = self
        
        //make the buttons disappear once the smoke is animating
        if list.count - taskMinosAchieved >= 13
        {
            
            stateAchieved.isHidden = true
            stateNotAchieved.isHidden = true
            self.achievedLabel.isHidden = true
            self.notAchievedLabel.isHidden = true
            smokeMoon()
            let audioPath = Bundle.main.path(forResource: "trainhorn", ofType: "mp3")!
            do
            {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath : audioPath))
                player.play()
            }
            catch
            {
                
            }
            
        }
        
        //TODO
        // ADMOB BANNER! PUT YOUR OWN ID TO START PROFITING FROM YOUR ADS
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-3804885476261021/3163781791"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // ADMOB INTERSTITIAL! THIS CODE ACTIVATE THE ADDS AFTER 10 SECONDS ! JUST CHANGE THE "10" DOWN TO DECREASE THE SECONDS!   TO PUT YOUR OWN ID  GO DOWN TO THE END OF THE CODE
         admobInterstitial = createAndLoadInterstitial()
          timerAds = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(ViewController.presentInterstitial), userInfo: nil, repeats: false)
        
        
      /*  // IF YOU WANT TO MAKE THE INTERSTITIAL APPEAR AGAIN SOMEWHERE ELSE , JUST COPY THIS
        admobInterstitial = createAndLoadInterstitial()
    timerAds = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: Selector("presentInterstitial"), userInfo: nil, repeats: false)*/

 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //============================================================================================
    
    // here you can costumize the uitableviewcell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor  = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  (UIScreen.main.nativeBounds.height == 1024) || (UIScreen.main.nativeBounds.height == 2048) || (UIScreen.main.nativeBounds.height == 2732)
        {
            return 85 //Whatever fits your need for that cell
        }
        else
        {
            return 44
        }
        
    }
    // controle how many row in the tablecell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    //function costumize  what the cell returns
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CostumCell
        cell.cellLabel.text = list.reversed()[indexPath.row]
        cell.ctrl = self
        cell.index = indexPath.row
        cell.tab = self.tableView
        
        /*if marked[indexPath.row] == "true" {
            cell.btn_edit.isHidden = true
        }*/
       // var image : UIImage = UIImage(named: "star@3x")!
       // cell.imageView!.image = image
    
        
        cell.circleInsideStar.image = UIImage(named: "\(taskColor.reversed()[indexPath.row])")
        
       if marked[indexPath.row] == "true"
        {
          //  print("when the condition is true")
           // print(marked[indexPath.row])
            //cell.tickButton.setBackgroundImage(UIImage(named: "tick"), forState: UIControlState.Normal)
            
            if taskColor[(taskColor.count - indexPath.row) - 1] == "Red"
            {
                cell.coloredLine.image = UIImage(named: "redLine1.png")
            }
            else if taskColor[(taskColor.count - indexPath.row) - 1] == "Orange"
            {
                cell.coloredLine.image = UIImage(named: "orangeLine1.png")
            }
            else
            {
                cell.coloredLine.image = UIImage(named: "greenLine.png")

            }
            //cell.btn_edit.isHidden = true
        }
        else
        {
           // print("when the condition is false")
            //print(marked[indexPath.row])
            cell.tickButton.setBackgroundImage(nil, for: UIControlState())
            cell.coloredLine.image = nil

        }
        if  (UIScreen.main.nativeBounds.height == 1024) || (UIScreen.main.nativeBounds.height == 2048) || (UIScreen.main.nativeBounds.height == 2732)
        {
            cell.cellLabel.font = cell.cellLabel.font.withSize(25)
        }
        
        return cell
        
    }
    

    // once swiped left the buttons of deleting and completing appears and do the functions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .normal, title: "del_btn".localized) { action, index in
            //print("Delete button tapped")
            let audioPath = Bundle.main.path(forResource: "delete1", ofType: "mp3")!
            do
            {
                try self.player = AVAudioPlayer(contentsOf: URL(fileURLWithPath : audioPath))
                self.player.play()
            }
            catch
            {
                
            }
            
            if marked[indexPath.row] == "true"
            {
                taskMinosAchieved -= 1
                UserDefaults.standard.set(taskMinosAchieved, forKey: "netNumber")
                
            }
            
            list.remove(at: (list.count - indexPath.row) - 1)
            UserDefaults.standard.set(list, forKey: "List")
            
            taskColor.remove(at: (taskColor.count - indexPath.row) - 1)
            UserDefaults.standard.set(taskColor, forKey: "Color")
            
           // marked.removeAtIndex((marked.count - indexPath.row) - 1)
            marked.remove(at: (indexPath.row))

            UserDefaults.standard.set(marked, forKey: "done")
            
            
            self.wantDelete = true
            self.completedTask = false
            self.locaNotification((list.count - indexPath.row))
            //notificationTime.removeAtIndex((list.count - indexPath.row))
            UserDefaults.standard.set(notificationTime, forKey: "Timer")
            
          /*  self.wantDelete = true
            self.locaNotification(indexPath.row)
           // notificationTime.removeAtIndex(indexPath.row)
            NSUserDefaults.standardUserDefaults().setObject(notificationTime, forKey: "Timer") */
            
            
            
            


            
            self.updatingLabels()
            self.opasityMoon()
            
            tableView.reloadData()
            
         /*   print("this is deleting part after typing delete")
            
            print("This is list")
            print(list)
            print("===================")
            
            print("This is deleted tasks")
            print(deletedTasks)
            print("===================")
            
            print("This is achieved tasks")
            print(achievedTasks)
            print("===================")
            
            print("This is task color")
            print(taskColor)
            print("===================")
            
            print("This is achieved")
            print(marked)
            print("+++++++++++++++++++++++++")
            
            print(notificationTime) */
        }
        delete.backgroundColor = UIColor(red: 244/255, green: 94/255, blue: 74/255,alpha: 1) //UIColor.redColor()
        
        let completed = UITableViewRowAction(style: .normal, title: "ok_btn".localized) { action, index in
            //print("favorite button tapped")
            let audioPath = Bundle.main.path(forResource: "complete1", ofType: "mp3")!
            do
            {
                try self.player = AVAudioPlayer(contentsOf: URL(fileURLWithPath : audioPath))
                self.player.play()
            }
            catch
            {
                
            }
            if marked[indexPath.row] == "false"
            {
                self.animatingFlowers()
            achievedTasks.append(list[(list.count - indexPath.row) - 1])
                marked[indexPath.row] = "true"
                UserDefaults.standard.set(marked, forKey: "done")
                
                taskMinosAchieved += 1
                UserDefaults.standard.set(taskMinosAchieved, forKey: "netNumber")
                
                
                
               // self.wantDelete = true
                self.completedTask = true
             //   self.locaNotification(indexPath.row)
                //notificationTime.removeAtIndex(indexPath.row)
                UserDefaults.standard.set(notificationTime, forKey: "Timer")


            }
           // marked[indexPath.row] = "true"
            //delete.img
            
            //list.removeAtIndex((list.count - indexPath.row) - 1)
            UserDefaults.standard.set(achievedTasks, forKey: "Achieved")

            self.updatingLabels()
            self.opasityMoon()
            
            tableView.reloadData()
            
        /*    print("this is achieving part after typing completeing")
            
           print("This is list")
            print(list)
            print("===================")
            
            print("This is deleted tasks")
            print(deletedTasks)
            print("===================")
            
            print("This is achieved tasks")
            print(achievedTasks)
            print("===================")
            
            print("This is task color")
            print(taskColor)
            print("===================")
            
            print("This is achieved")
            print(marked)
            print("+++++++++++++++++++++++++")
            
           print(notificationTime) */
        }
        completed.backgroundColor = UIColor(red: 100/255, green: 162/255, blue: 24/255,alpha: 1)
        
        //let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            //println("share button tapped")
        //}
       // share.backgroundColor = UIColor.blueColor()
        
       // let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(list[indexPath.row])")
       // attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
        
        return [delete, completed]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.datePicker.minimumDate = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        updatingLabels()
        print("adadoazdoazoaaoo")
    }
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool
    {
        taskField.resignFirstResponder()
        performAction()
        return true
    }
    

    func tap(_ gesture: UITapGestureRecognizer) {
        taskField.resignFirstResponder()
    }
    
    //this function controls the moons redness level if the moon or angry or not
    func opasityMoon()
    {
        
        if list.count - taskMinosAchieved <= 2
        {
            opacityMoon.alpha = 0
        }
        else if list.count - taskMinosAchieved < 3
        {
            opacityMoon.alpha = 0.10
        }
        else if list.count - taskMinosAchieved < 5
        {
            opacityMoon.alpha = 0.25
        }
        else if list.count - taskMinosAchieved < 6
        {
            opacityMoon.alpha = 0.45
        }
        else if list.count - taskMinosAchieved < 8
        {
            opacityMoon.alpha = 0.65
        }
        else if list.count - taskMinosAchieved < 9
        {
            opacityMoon.alpha = 0.70
        }
        else if list.count - taskMinosAchieved < 10
        {
            opacityMoon.alpha = 0.85
        }
        else if list.count - taskMinosAchieved < 12
        {
            opacityMoon.alpha = 1
        }
        else if list.count - taskMinosAchieved < 13
        {
            opacityMoon.image = UIImage(named: "opacitymoon1.png")
            opacityMoon.alpha = 1
        }
        else
        {
            opacityMoon.image = UIImage(named: "opacitymoon2.png")
            opacityMoon.alpha = 1
        }
    }
    // updates the counters of the achieved and not achieved tasks
    func updatingLabels()
    {
        
        guard let mylist: [String] = UserDefaults.standard.value(forKey: "List") as! [String]? else { return }
        list = mylist
        
        achievedLabel.text =  "\(taskMinosAchieved)"
        notAchievedLabel.text =  "\(list.count)"
    }
    func performAction() {
        
        addToList()
    }
    
    //function for firing the local notification
    func locaNotification(_ num:Int)
    {
        
        let notification = UILocalNotification()
        if wantDelete == false
        {
            // adding local notification
            notification.alertBody = "\(list[list.count - 1])"
            if #available(iOS 8.2, *)
            {
                notification.alertTitle = "notif_title".localized
            }
            else
            {
            // Fallback on earlier versions
            }
        notification.fireDate = datePicker.date
        notification.soundName = "bethov1.mp3"
        
        
        UIApplication.shared.scheduleLocalNotification(notification)
            
            
          /*  print("at the end of adding")
            print(notification)
            print("================================================") */
            
        }
        else
        {
            
          //  print(notificationTime[num],"  notificationTime")
            
          /*  if notificationTime[num] == ""
            {
                print("it is empty")
            } */
            
            //{
           /*     let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                
                var newString = NSString(string: "\(notificationTime[num])")
                
                var str1 = newString.substringToIndex(10)
                var str2 = newString.substringFromIndex(11)
                var finalStr = str1 + "T" + str2
              //  print(finalStr,"this is final string" )
                
                var dateAsString =  finalStr
                //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                print(dateAsString,"ldljsalda")
                
                var newDate =  dateFormatter.dateFromString(dateAsString)
               
                print(newDate,"this is new date") */
                
                
        
            
            let arrLocalNotif = UIApplication.shared.scheduledLocalNotifications
                
            for localN:UILocalNotification in arrLocalNotif!
            {
                let notificationFireDate:Date = localN.fireDate!
              //  print(notificationFireDate, " == BLA" , newDate ,"they must be equal\n")

              
                if notificationFireDate == notificationTime[num]//newDate
                {
                    UIApplication.shared.cancelLocalNotification(localN)
                    print("I Achieved it hell yeah")
                   // print(notificationFireDate, " == " , newDate , "they must be equal")
                }
                
            }
          //  }


 
 
         //   print("at the end of deleting")
           // print(notification)
           // print("=================================================")
            
           // print(completedTask)
            if completedTask == false
            {
            notificationTime.remove(at: num)
            //print(notificationTime)
            }

            
            

            
        }
    }
    
    //function to add everything to the lists
    func addToList()
    {
    
        if taskField.text == ""
        {
            taskField.placeholder = "Please Enter a Task !"
            redButton.isHidden = true
            greenButton.isHidden = true
            orangeButton.isHidden = true
            
        }
        else
        {
            wantDelete = false
            
            if datePicker.isHidden == true
            {
            list.append(taskField.text!)
            UserDefaults.standard.set(list, forKey: "List")
            
            taskColor.append("Green")
                UserDefaults.standard.set(taskColor, forKey: "Color")
                
                
                marked.insert("false", at: 0)
                UserDefaults.standard.set(marked, forKey: "done")
             
            tableView.reloadData()
            taskField.text = ""
            taskField.placeholder = "placeholder_task".localized
            updatingLabels()
            notificationTime.append(Date())
            UserDefaults.standard.set(notificationTime, forKey: "Timer")
    
            }
            else
            {
                wantDelete = false
                
                list.append(taskField.text!)
                notificationTime.append(datePicker.date)
                UserDefaults.standard.set(list, forKey: "List")
                UserDefaults.standard.set(notificationTime, forKey: "Timer")
                
                marked.insert("false", at: 0)
                UserDefaults.standard.set(marked, forKey: "done")
                
                //print(choosingColor.count)
                if choosingColor.count == 0
                {
                    choosingColor.append("Green")
                }
                taskColor.append(choosingColor[choosingColor.count  - 1])
                UserDefaults.standard.set(taskColor, forKey: "Color")


                
                tableView.reloadData()
                taskField.text = ""
                taskField.placeholder = "placeholder_task".localized
                updatingLabels()
                
                locaNotification(0)
                
                redButton.setBackgroundImage(nil, for: UIControlState())
                greenButton.setBackgroundImage(nil, for: UIControlState())
                orangeButton.setBackgroundImage(nil, for: UIControlState())
                
            }
            redButton.isHidden = true
            greenButton.isHidden = true
            orangeButton.isHidden = true
            
            //Audio for Adding stuff
            let audioPath = Bundle.main.path(forResource: "add1", ofType: "mp3")!
            do
            {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath : audioPath))
                player.play()
            }
            catch
            {
                
            }
          //  print(notificationTime)

            
        }
     /*   print("This is list")
        print(list)
        print("===================")
        
        print("This is deleted tasks")
        print(deletedTasks)
        print("===================")
        
        print("This is achieved tasks")
        print(achievedTasks)
        print("===================")
        
        print("This is task color")
        print(taskColor)
        print("===================")
        
        print("This is achieved")
        print(marked)
        print(notificationTime,"AAAAAAAAAAAAAAAAA")
        print("+++++++++++++++++++++++++")*/
        
        opasityMoon()
        
    }
    // makes the counter label appears from behind the moon when pressed
    func timerForMoon()
    {
        if counter == 3
        {
            if UIScreen.main.nativeBounds.height == 2208
            {
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 85, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 85, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 90, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 90, y: self.notAchievedLabel.center.y)
                })
                
                counter = 0
                timer.invalidate()
                outside = false
                
            }
            else if UIScreen.main.nativeBounds.height == 1024
            {
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 160, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 160, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 170, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 170, y: self.notAchievedLabel.center.y)
                })
                
                outside = false
            }
            else if UIScreen.main.nativeBounds.height == 2048
            {
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 160, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 160, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 170, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 170, y: self.notAchievedLabel.center.y)
                })
                
            }
            else if UIScreen.main.nativeBounds.height == 2732
            {
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 210, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 210, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 220, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 220, y: self.notAchievedLabel.center.y)
                })
                
            }
            else if UIScreen.main.nativeBounds.height == 1136
            {
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 90, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 90, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 100, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 100, y: self.notAchievedLabel.center.y)
                })
                
            }
            else if UIScreen.main.nativeBounds.height == 960
            {
                
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 90, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 90, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 100, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 100, y: self.notAchievedLabel.center.y)
                })
                
            }
                
            else
            {
                UIView.animate(withDuration: 1, animations: {
                    
                    self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 75, y: self.stateAchieved.center.y )
                    self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 75, y: self.stateNotAchieved.center.y)
                    
                    self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 75, y: self.achievedLabel.center.y )
                    self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 75, y: self.notAchievedLabel.center.y)
                })}
            counter = 0
            timer.invalidate()
            outside = false
        }
        else
        {
            counter += 1
        }
    }
    
    // function to animate the smoke behind the moon
    func smokeMoon()
    {
        UIView.animate(withDuration: 0.8, animations: {
            
            self.nervous1.center = CGPoint(x: self.nervous1.center.x + 110, y: self.nervous1.center.y )
            self.nervous2.center = CGPoint(x: self.nervous2.center.x - 110, y: self.nervous2.center.y )
        })
        //TODO
        //var time = DispatchTime(uptimeNanoseconds: DispatchTime.now()) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        var time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: time) {
            //put your code which should be executed with a delay here
            UIView.animate(withDuration: 0.8, animations: {
                
                self.nervous1.center = CGPoint(x: self.nervous1.center.x - 110, y: self.nervous1.center.y )
                self.nervous2.center = CGPoint(x: self.nervous2.center.x + 110, y: self.nervous2.center.y )
            })
            
            time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time)
            {
                UIView.animate(withDuration: 0.8, animations: {
                    
                    self.nervous1.center = CGPoint(x: self.nervous1.center.x + 110, y: self.nervous1.center.y )
                    self.nervous2.center = CGPoint(x: self.nervous2.center.x - 110, y: self.nervous2.center.y )
                })
                time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time)
                {
                    UIView.animate(withDuration: 0.8, animations: {
                        
                        self.nervous1.center = CGPoint(x: self.nervous1.center.x - 110, y: self.nervous1.center.y )
                        self.nervous2.center = CGPoint(x: self.nervous2.center.x + 110, y: self.nervous2.center.y )
                    })
                    time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time)
                    {
                        UIView.animate(withDuration: 0.8, animations: {
                            
                            self.nervous1.center = CGPoint(x: self.nervous1.center.x + 110, y: self.nervous1.center.y )
                            self.nervous2.center = CGPoint(x: self.nervous2.center.x - 110, y: self.nervous2.center.y )
                        })
                        time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time)
                        {
                            UIView.animate(withDuration: 0.8, animations: {
                                
                                self.nervous1.center = CGPoint(x: self.nervous1.center.x - 110, y: self.nervous1.center.y )
                                self.nervous2.center = CGPoint(x: self.nervous2.center.x + 110, y: self.nervous2.center.y )
                            })
                            self.stateAchieved.isHidden = false
                            self.stateNotAchieved.isHidden = false
                            self.achievedLabel.isHidden = false
                            self.notAchievedLabel.isHidden = false
                        }
                    }
                }
            }
            
            
        }
        
        
    }
    
    func animatingFlowers()
    {
        UIView.animate(withDuration: 0.8, animations: {
            
            self.downFlower.center = CGPoint(x: self.downFlower.center.x , y: self.downFlower.center.y + 60 )
            self.rightFlower.center = CGPoint(x: self.rightFlower.center.x + 65, y: self.rightFlower.center.y )
            self.leftFlower.center = CGPoint(x: self.leftFlower.center.x - 50, y: self.leftFlower.center.y )
            self.leftDownFlower.center = CGPoint(x: self.leftDownFlower.center.x - 30, y: self.leftDownFlower.center.y + 40 )
            self.rightDownFlower.center = CGPoint(x: self.rightDownFlower.center.x + 40, y: self.rightDownFlower.center.y + 50 )
        })
        //TODO
        let time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(4 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: time)
        {
            UIView.animate(withDuration: 0.8, animations: {
                
                self.downFlower.center = CGPoint(x: self.downFlower.center.x , y: self.downFlower.center.y - 60 )
                self.rightFlower.center = CGPoint(x: self.rightFlower.center.x - 65, y: self.rightFlower.center.y )
                self.leftFlower.center = CGPoint(x: self.leftFlower.center.x + 50, y: self.leftFlower.center.y )
                self.leftDownFlower.center = CGPoint(x: self.leftDownFlower.center.x + 30, y: self.leftDownFlower.center.y - 40 )
                self.rightDownFlower.center = CGPoint(x: self.rightDownFlower.center.x - 40, y: self.rightDownFlower.center.y - 50 )
            })
            
        }
    }
    
    // those functions down here for compitable achieved and not achieved labels for the various devices to appear accurately
    func compitableImagesForIPhone6Plus()
    {
        // print(stateAchieved.center.x,"  make it disappear must equal 315.5"," make it appear must equal 230.5")
        
        if outside == true
        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 85, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 85, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 90, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 90, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            
            counter = 0
            
            outside = false
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 85, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 85, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 90, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 90, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
        
        
    }
    
    func compitableImagesForIPhone4s()
    {
        
        if outside == true
        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 90, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 90, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 100, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 100, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            
            counter = 0
            outside = false
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 90, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 90, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 100, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 100, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
        
        
    }
    
    func compitableImagesforiPadClassic()
    {
        // print(stateAchieved.center.x)
        //print("Classic")
        if outside == true//stateAchieved.center.x == 585.5
        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 160, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 160, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 170, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 170, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            outside = false
            
            counter = 0
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 160, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 160, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 170, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 170, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
    }
    
    func compitableImagesforiPadRetina()
    {
        
        if outside == true        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 160, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 160, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 170, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 170, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            outside = false
            
            counter = 0
            
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 160, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 160, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 170, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 170, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
    }
    
    func compitableImagesforiPadPro()
    {
        
        if outside == true
        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 210, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 210, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 220, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 220, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            outside = false
            
            counter = 0
            
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 210, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 210, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 220, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 220, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
    }
    
    func compitableImagesforiPhone5s()
    {
        if outside == true        {
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x - 90, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x + 90, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x - 100, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x + 100, y: self.notAchievedLabel.center.y)
            })
            
            timer.invalidate()
            outside = false
            
            counter = 0
            
        }
        else
        {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.stateAchieved.center = CGPoint(x: self.stateAchieved.center.x + 90, y: self.stateAchieved.center.y )
                self.stateNotAchieved.center = CGPoint(x: self.stateNotAchieved.center.x - 90, y: self.stateNotAchieved.center.y)
                
                self.achievedLabel.center = CGPoint(x: self.achievedLabel.center.x + 100, y: self.achievedLabel.center.y )
                self.notAchievedLabel.center = CGPoint(x: self.notAchievedLabel.center.x - 100, y: self.notAchievedLabel.center.y)
            })
            
            
            timer.invalidate()
            
            counter = 0
            outside = true
            if outside == true
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerForMoon), userInfo: nil, repeats: true)
                outside = false
            }
            
            outside = true
        }
    }
    
    // HERE YOU CAN PUT YOUR OWN INRTERSTITIAL CODE
    func createAndLoadInterstitial()->GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "PUT YOUR ADMOB ID HERE")
        ///interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func presentInterstitial() {
        if (admobInterstitial?.isReady) != nil {
            admobInterstitial?.present(fromRootViewController: self)
        }
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("interstitialDidFailToReceiveAdWithError:\(error.localizedDescription)")
        admobInterstitial = createAndLoadInterstitial()
    }
}
