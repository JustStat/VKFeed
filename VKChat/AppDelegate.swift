//
//  AppDelegate.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let assembler = Assembler([ChatListAssembly()])
        window?.rootViewController = assembler.resolver.resolve(ChatListViewInput.self) as? UIViewController
        
        window?.makeKeyAndVisible()
        return true
    }
}

