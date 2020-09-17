//
//  UIViewController+Jump.swift
//  IM_XMPP
//
//  Created by mojingyu on 2018/11/5.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import UIKit

extension UIViewController {

    public var preViewController: UIViewController? {
        guard let count = self.navigationController?.viewControllers.count else { return nil }
        return self.navigationController?.viewControllers[safe: count - 2]
    }

    public func pop(to aClassList: [AnyClass], _ isToRoot: Bool = false) {

        if let viewcontrollers = self.navigationController?.viewControllers {

            for vc in viewcontrollers {

                for aClass in aClassList {
                    if vc.isKind(of: aClass) {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
        }

        self.pop(isToRoot)
    }

    public func pop(_ isToRoot: Bool = false) {

        if isToRoot == true {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    public func pop(animated: Bool) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    public func push(_ viewController: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {

        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    public func dissmiss() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.pop()
        }
    }
}