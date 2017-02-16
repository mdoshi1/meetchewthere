//
//  AppDelegate.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import YelpAPI
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var sharedYLPClient: YLPClient!
    private let appId = "X6SA2_urz3iwprFX7Pxp_A"
    private let secret = "xZKXVQikiQpY1iTXLhvNbOsCAAhLqDqznLahEfg3uJ8C8oyH7jm6j3vTd245XQ5y"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        YLPClient.authorize(withAppId: appId, secret: secret) { client, error in
            guard let client = client, error == nil else {
                
                // TODO: what to do if can't get client because we force-cast sharedClient
                print("Error authorizing app to receive a YLPClient: \(error)")
                return
            }
            print("Successfully authorized app to receive a YLPClient")
            AppDelegate.sharedYLPClient = client
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
        }
        
        Fabric.with([Crashlytics.self])

        
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


}

