//
//  AppDelegate.swift
//  BA-Clock
//
//  Created by April on 1/7/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        [[appDelegate window] setBackgroundColor:[UIColor blackColor]];
        self.window?.backgroundColor = UIColor.white
        
        UINavigationBar.appearance().barTintColor = CConstants.ApplicationColor
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarFontSize)!
            
        ]
        UIToolbar.appearance().barTintColor = CConstants.ApplicationColor
        UIToolbar.appearance().barStyle = .black
        
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)!, NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
        UISearchBar.appearance().barTintColor = CConstants.SearchBarBackColor
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        let userinfo = UserDefaults.standard
        userinfo.set(0, forKey: CConstants.ShowFilter)
        
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 2 // seconds
        
        let storyboard = UIStoryboard(name: CConstants.StoryboardName, bundle: nil)
        
        //        let userInfo = NSUserDefaults.standardUserDefaults()
        //        userInfo.setBool(true, forKey: CConstants.ToAddTrack)
        
        var storyid : String?
        if let _ = userinfo.object(forKey: CConstants.UserInfoPwd) as? String{
            if let _ = userinfo.object(forKey: CConstants.UserInfoEmail) as? String{
                storyid = "AddressListViewController"
            }
        }
        let rootController = storyboard.instantiateViewController(withIdentifier: storyid ?? "LoginViewController") as UIViewController
        
        if let nav = self.window?.rootViewController as? UINavigationController{
            nav.pushViewController(rootController, animated: true)
        }
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                if let _ = userinfo.string(forKey: CConstants.UserInfoEmail)
                    , let _ = userinfo.string(forKey: CConstants.UserInfoPwd){
                    let tl = util()
                    tl.syncDataToServer()
                }
            }else{
                print("OK")
            }
        }
        
        
        return true
        
        
        
        
        
    }
    
    //    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    //        var deviceTokenStr = "\(deviceToken)"
    //        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")
    //        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "")
    //        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(">", withString: "")
    //        let userInfo = NSUserDefaults.standardUserDefaults()
    //        userInfo.setValue(deviceTokenStr, forKey: CConstants.UserDeviceToken)
    //
    //
    //        // ...register device token with our Time Entry API server via REST
    //    }
    //
    //    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    //        print("Device token for push notifications: FAIL -- ")
    //        print(error.description)
    //    }
    //
    //    func initializeNotificationServices() -> Void {
    //        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound , UIUserNotificationType.Alert , UIUserNotificationType.Badge], categories: nil)
    //        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    //
    //        // This is an asynchronous method to retrieve a Device Token
    //        // Callbacks are in AppDelegate.swift
    //        // Success = didRegisterForRemoteNotificationsWithDeviceToken
    //        // Fail = didFailToRegisterForRemoteNotificationsWithError
    //        UIApplication.sharedApplication().registerForRemoteNotifications()
    //    }
    
    //    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //        //        print("fort tessssssss")
    //        // display the userInfo
    //        if let _ = userInfo["aps"] as? NSDictionary {
    //            //            let alert = notification["alert"] as? String {
    //            //                let alertCtrl = UIAlertController(title: "BA Clock", message: alert as String, preferredStyle: UIAlertControllerStyle.Alert)
    //            //                alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
    //            //                    (_) -> Void in
    //            //                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    //            //
    //            ////                    let localNotification = UILocalNotification()
    //            ////                    localNotification.applicationIconBadgeNumber = 0
    //            //                    })
    //            //                // Find the presented VC...
    //            //                var presentedVC = self.window?.rootViewController
    //            //                while (presentedVC!.presentedViewController != nil)  {
    //            //                    presentedVC = presentedVC!.presentedViewController
    //            //                }
    //            //                presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
    //
    //            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    //
    //            // call the completion handler
    //            // -- pass in NoData, since no new data was fetched from the server.
    //            completionHandler(UIBackgroundFetchResult.NoData)
    //        }
    //    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ba.BA_Clock" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Contract", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    
}

