//
//  AppRouter.swift
//  Viper Example
//
//  Created by TPFLAP146 on 12/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//


import Foundation
import UIKit

//MARK: - App Router - decides the routing and root View Controller
class AppRouter {
    
    @available(iOS 13.0, *)
    static func setRootViewController(windowScene:UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
    
        window.rootViewController = setRootViewController()
        return window
    }
    static func setRootViewController() -> UIViewController {
        //Change your root view controller here
        let rootVC = EmployeeRouter.start()
        return rootVC
    }
    
}
