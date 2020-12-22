//
//  CustomTabBarController.swift
//  Exchange
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

open class HLTabBarController: UITabBarController {
    
    public static var foregroundColor: UIColor? = nil
    public static var foregroundColorSelected: UIColor? = nil

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.white
        
        if let color = HLTabBarController.foregroundColor {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        }
        
        if let color = HLTabBarController.foregroundColorSelected {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        }
     
        self.selectedIndex = 0
    }
    
    func clearShadow() -> Self {
        // 黑线
        tabBar.backgroundImage = UIImage.init()
        tabBar.shadowImage = UIImage.init()
        return self
    }
    
    func setTitleColor(color: UIColor, for state: UIControl.State) -> Self {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: state)
        return self
    }

    public func add(_ viewcontroller: UIViewController, title: String?, normalImage: UIImage? = nil, selImage: UIImage? = nil) -> Self {

        viewcontroller.title = title
        viewcontroller.view.backgroundColor = UIColor.white

        let nav = HLNavigationController.init(rootViewController: viewcontroller)
        let tabItem = UITabBarItem(title: title, image: normalImage, selectedImage: selImage)
        nav.tabBarItem = tabItem

        self.addChild(nav)

        return self
    }

    public func setTabBarBackgroundImage(_ image: UIImage?) -> Self {
        tabBar.backgroundImage = image
        return self
    }
}
