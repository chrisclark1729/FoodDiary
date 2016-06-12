//
//  AppDelegate.swift
//  FoodDiary
//
//  Created by Chris Clark on 5/15/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse
//import Bolts
// import GoogleMaps
//testing imports
//import FBSDKCoreKit
//import FBSDKShareKit
//import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if self.window!.rootViewController as? UITabBarController != nil {
            let tababarController = self.window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 3
        }
        
        Parse.setLogLevel(PFLogLevel.Info);
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
   //     Parse.setApplicationId("G6Yn7q96WMpM9jPDPy4rpNZjKUn4TAuB36Dv49sX",
    //        clientKey: "TFKLutf7v2XWyqV5DvXckoZBRNP1r2sdHJCVCPHt")
     //   Parse.initialize()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "G6Yn7q96WMpM9jPDPy4rpNZjKUn4TAuB36Dv49sX"
            $0.clientKey = "TFKLutf7v2XWyqV5DvXckoZBRNP1r2sdHJCVCPHt"
            $0.server = "https://secret-bastion-12792.herokuapp.com/parse"
            
        }
        /*
        let config = ParseClientConfiguration(block: {
            (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "G6Yn7q96WMpM9jPDPy4rpNZjKUn4TAuB36Dv49sX";
            ParseMutableClientConfiguration.clientKey = "TFKLutf7v2XWyqV5DvXckoZBRNP1r2sdHJCVCPHt";
            ParseMutableClientConfiguration.server = "https://secret-bastion-12792.herokuapp.com/parse"; }); */
        
        Parse.initializeWithConfiguration(configuration)
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        Parse.setLogLevel(PFLogLevel.Debug)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("requestSent:"), name: PFNetworkWillSendURLRequestNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("responseReceived:"), name: PFNetworkDidReceiveURLResponseNotification, object: nil)
        
        
        /*
 [Parse setLogLevel:PFLogLevelDebug]; [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWillSendURLRequestNotification:) name:PFNetworkWillSendURLRequestNotification object:nil]; [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDidReceiveURLResponseNotification:) name:PFNetworkDidReceiveURLResponseNotification object:nil];
*/
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func requestSent(notification: NSNotification) {
        print(notification)
    }
    
    func responseReceived(response: NSNotification) {
        print(response)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

