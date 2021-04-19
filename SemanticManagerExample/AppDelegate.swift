//
//  AppDelegate.swift
//  SemanticManagerExample
//
//  Created by Ahmed Zaki on 19/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        debugPrint("Lang: \(LanguageManager.shared.currentLanguage)")
        LanguageManager.shared.delegate = self
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: LanguageManagerDelegate {
    func setRoot() {
        window?.rootViewController = ViewController()
    }
}
