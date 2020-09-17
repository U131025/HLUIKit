//
//  UIViewController+Current.swift
//  Community
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension UIViewController {

    public class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }

}
