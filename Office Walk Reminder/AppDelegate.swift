//
//  AppDelegate.swift
//  Office Walk Reminder
//
//  Created by Local on 10/12/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Default value for all settings
    static let defaultNumberOfSteps = 300
    static let defaultWorkStartTime = Date(timeIntervalSinceReferenceDate: 46800)
    static let defaultWorkEndTime   = Date(timeIntervalSinceReferenceDate: 79200)
    static let defaultFirstInterval = 60
    static let defaultRepeatedInterval = 15
    
    var window: UIWindow?
  
    func setupDefaultSettings() {
        let defaults = UserDefaults.standard
        
        //defaults.set(AppDelegate.defaultNumberOfSteps   , forKey: "defaultNumberOfSteps")
        //defaults.set(AppDelegate.defaultWorkStartTime   , forKey: "defaultWorkStartTime")
        //defaults.set(AppDelegate.defaultWorkEndTime     , forKey: "defaultWorkEndTime")
        //defaults.set(AppDelegate.defaultFirstInterval   , forKey: "defaultFirstInterval")
        //defaults.set(AppDelegate.defaultRepeatedInterval, forKey: "defaultRepeatedInterval")
        
        defaults.register(defaults: ["numberOfSteps"    : AppDelegate.defaultNumberOfSteps])
        defaults.register(defaults: ["workStartTime"    : AppDelegate.defaultWorkStartTime])
        defaults.register(defaults: ["workEndTime"      : AppDelegate.defaultWorkEndTime])
        defaults.register(defaults: ["firstInterval"    : AppDelegate.defaultFirstInterval])
        defaults.register(defaults: ["repeatedInterval" : AppDelegate.defaultRepeatedInterval])
        
    }
    
    func scheduleNextFetch(){
        let nextReminderTime = FirstViewController().nextReminderTime()
        let intervalUntilNextReminderInSeconds = nextReminderTime.timeIntervalSince(Date())
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(intervalUntilNextReminderInSeconds)
        
        print("----------", FirstViewController().timeFormat(nextReminderTime), "next fetch time scheduled in ", Int(intervalUntilNextReminderInSeconds/60), " minutes")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupDefaultSettings()
        
        // User Notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]){ (granted, error) in
            if !granted {
                print("close the app because User Notification is not allowed")
            }
        }
        
        // Background fetch: set default fetch interval to 1 hour initially
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        
        return true
    }
    
    // Background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if  let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                if let firstViewController = viewController as? FirstViewController {
                    firstViewController.fetch {                        
                        // Update Steps data and notification accordingly if there is any changes
                        firstViewController.updateStepsDataAndUpdateView()
                        
                        // If more than 1 hour has passed since timerStartTime, notify immediately
                        if Int(Date().timeIntervalSince(FirstViewController.timerStartTime)) >= FirstViewController.intervalUntilFirstReminderInMinutes*60 {
                            firstViewController.bannerNotifyNow()
                        }
                        
                        scheduleNextFetch()
                        
                        completionHandler(.newData)
                    }
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        scheduleNextFetch()
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
