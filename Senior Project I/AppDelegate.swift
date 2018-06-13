//
//  AppDelegate.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 18/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
//import GoogleMobileAds
//import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544/2934735716")
//        UNUserNotificationCenter.current().delegate = self
        
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .lightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
//        let myGroup = DispatchGroup()
//        var projectListFinal = [ProjectFromTFS]()
//        var workItem = [WorkItemFromTFS]()
//        myGroup.enter()
//        
//        getProjectList(accountName: "TraxApplication", token: "ottl5wlese5vbpeeucj24rkfuda3ycycubxfhzsnjz4s4lh3tbya") { (projectList) in
//            print(projectList.count)
//            
//            for i in 0...projectList.count-1 {
//                var projectEach = ProjectFromTFS()
//                projectEach.id = projectList[i].id
//                projectEach.name = projectList[i].name
//                getWorkItemNumber(accountName: "TraxApplication", projectName: projectList[i].name!, token: "ottl5wlese5vbpeeucj24rkfuda3ycycubxfhzsnjz4s4lh3tbya", resume: { (workItemList) in
//                    
//                    var workItemIDStr = ""
//                    for i in 0...workItemList.count-1 {
//                        workItemIDStr = workItemIDStr + "\(workItemList[i])"
//                        if (i != workItemList.count-1) {
//                            workItemIDStr = workItemIDStr + ","
//                        }
//                    }
//                    print(workItemIDStr)
//                    getTaskFromWorkItemID(token: "ottl5wlese5vbpeeucj24rkfuda3ycycubxfhzsnjz4s4lh3tbya", id: workItemIDStr, accountName: "TraxApplication", resume: { (workItems) in
//                        getComment(accountName: "TraxApplication", token: "ottl5wlese5vbpeeucj24rkfuda3ycycubxfhzsnjz4s4lh3tbya", tasks: workItems, resume: { (FinishWorkItemList) in
//                            workItem = FinishWorkItemList
//                            projectEach.task = workItem
//                            projectListFinal.append(projectEach)
//                            if i == projectList.count-1 {
//                                myGroup.leave()
//                            }
//                        })
//                        
//                    })
//                })
//                
//                
//            }
//            myGroup.notify(queue: DispatchQueue.main, execute: {
//                print(projectListFinal.count)
//            })
//        }
//        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,  completionHandler: @escaping (Bool) -> Void) {
        // Transition to the pressed tab
        print("Action!")
    }
    
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler(.alert)
//    }
//}



