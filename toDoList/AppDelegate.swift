//
//  AppDelegate.swift
//  toDoList
//
//  Created by Ahmad Khawatmi on 13/05/16.
//  Copyright © 2016 Ahmad Khawatmi. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, KochavaTrackerClientDelegate {

    var window: UIWindow?
    var kochavaTracker: KochavaTracker?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // local notifications settings
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        var initDictionary: [AnyHashable: Any] = [:]
        
        initDictionary["kochavaAppId"] = "koreminder-angry-moon-sm8s"
        initDictionary["enableLogging"] = "1"
        initDictionary["retrieveAttribution"] = "1"
        self.kochavaTracker = KochavaTracker(kochavaWithParams: initDictionary)
       
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true
        gai?.logger.logLevel = GAILogLevel.verbose
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let ud = UserDefaults.standard
        
        if var o: Int = ud.value(forKey: "opening") as! Int? {
            
            if (o < 3) {
                o = o + 1
            }
            ud.set(o, forKey: "opening")
            ud.synchronize()
        }
        else {
            ud.set(1, forKey: "opening")
            ud.synchronize()
        }
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let ud = UserDefaults.standard
        
        if let op: Int = ud.value(forKey: "opening") as! Int? {
            
            if (op == 3) {
                
                let gtracker = TrackerGoogle()

               let alert = UIAlertController(title: "askforrateTitle".localized, message: "askforrateText".localized, preferredStyle: .alert)
                let rate = UIAlertAction(title: "askforratePos".localized, style: .default, handler: { _ in
                    
                    gtracker.setEvent(category: "home", action: "rate_five", label: "click")

                    
                    let url = "https://itunes.apple.com/app/id1208174072"
                     if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string : url) as! URL, options: [:], completionHandler: nil)
                     } else {
                        UIApplication.shared.openURL(NSURL(string : url) as! URL)
                     }
                     alert.dismiss(animated: true, completion: nil)
                    
                    ud.set(42, forKey: "opening")
                    ud.synchronize()
                })
                
                let later  = UIAlertAction(title: "askforrateRemindMe".localized, style: .default, handler: { _ in
                    
                    gtracker.setEvent(category: "home", action: "rate_remind", label: "click")

                    ud.set(0, forKey: "opening")
                    ud.synchronize()
                })
                
                let no = UIAlertAction(title: "askforrateNeg".localized, style: .cancel, handler: { _ in
                    
                    gtracker.setEvent(category: "home", action: "rate_no", label: "click")

                    ud.set(42, forKey: "opening")
                    ud.synchronize()
                })
                
                alert.addAction(rate)
                alert.addAction(later)
                alert.addAction(no)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        let ud = UserDefaults.standard
        
        if var o: Int = ud.value(forKey: "opening") as! Int? {
            
            if (o < 3) {
                o = o + 1
            }
            
            ud.set(o, forKey: "opening")
            ud.synchronize()
        }
        else {
            ud.set(1, forKey: "opening")
            ud.synchronize()
        }
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

