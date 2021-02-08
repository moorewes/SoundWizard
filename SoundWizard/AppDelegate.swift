//
//  AppDelegate.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIKitAppearance.setup()
        AudioFileManager.shared.performInitialSetupIfNeeded()
        CoreDataManager.shared.loadInitialLevels()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Conductor.master.pauseEngine()
        CoreDataManager.shared.save()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Conductor.master.pauseEngine()
        CoreDataManager.shared.save()
    }
}
