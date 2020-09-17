//
//  CustomTabBarController.swift
//  Exchange
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

open class HLTabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.white

        // 黑线
        tabBar.backgroundImage = UIImage.init()
        tabBar.shadowImage = UIImage.init()

//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "B8BDCB")], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "438FFF")], for: .selected)

        self.selectedIndex = 0
    }

    public func add(_ viewcontroller: UIViewController, title: String, normalImage: UIImage? = nil, selImage: UIImage? = nil) -> Self {

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
