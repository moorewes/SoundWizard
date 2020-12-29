//
//  SceneDelegate.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let stateController = StateController(levelStore: CoreDataManager.shared)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let context = CoreDataManager.shared.container.viewContext
            let view = MainTabView()
                .environment(\.managedObjectContext, context)
                .environmentObject(stateController)
            //let testView = NavigationView {EQDCustomLevelDetailView(level: EQDLevel.newCustomLevel(), completionHandler: {_ in})}.listRowBackground(Color.secondaryBackground)
//            let filters: [EQBellFilterData] = [
//                EQBellFilterData(frequency: 300, gain: Gain(dB: 4), q: 2),
//                EQBellFilterData(frequency: 1000, gain: Gain(dB: 4), q: 8),
//                EQBellFilterData(frequency: 5000, gain: Gain(dB: 4), q: 1)
//            ]
            //let filterView = InteractiveEQPlot(filters: filters)
            let level = TestData.eqMatchLevel
            let game = level.buildGame(gameHandler: TestData.GameHandler(state: .playing))
            window.rootViewController = UIHostingController(rootView: game)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.

    }


}

