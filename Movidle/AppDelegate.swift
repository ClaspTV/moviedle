//
//  AppDelegate.swift
//  VizbeeDemo
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import UIKit
import SwiftUI
import VizbeeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let splashScreen = MainView()
        window.rootViewController = UIHostingController(rootView: splashScreen)
        self.window = window
        window.makeKeyAndVisible()
        
        // Initialize Vizbee SDK
        VizbeeWrapper.shared.initVizbeeSDK()
        
        return true
    }
}
