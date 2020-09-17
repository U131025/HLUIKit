//
//  RxDefaultPopView.swift
//  Community
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

open class HLPopView: HLView {

    open var isShow: Bool = false
    open var topWindow: UIWindow?

    private var identify: String?

    convenience init(identify: String) {
        self.init(frame: .zero)

        self.identify = identify
    }

    open var isFirst: Bool {
        get {
            return UserDefaults.standard.object(forKey: identify ?? "\(self)") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: identify ?? "\(self)")
        }
    }

    open func show(checkFirst: Bool) {
        self.show(windowLevel: .alert - 1, checkFirst: checkFirst)
    }

    open func show(windowLevel: UIWindow.Level, checkFirst: Bool) {

        if checkFirst {
            if isFirst == false { return }
            isFirst = false
        }

        self.show(windowLevel: windowLevel, in: nil)
    }

    @objc open func show(windowLevel: UIWindow.Level = .alert - 1, in view: UIView? = nil) {

        self.isShow = true
        self.alpha = 1

        if let view = view {
            view.addSubview(self)
            self.center = view.center
            self.frame = view.bounds
            return
        }

        self.topWindow = UIWindow().then { (window) in
            window.frame = UIScreen.main.bounds
            window.windowLevel = windowLevel
            window.isHidden = false
            window.backgroundColor = .clear

            let vc = HLTableViewController()
            vc.view.backgroundColor = .clear
            window.rootViewController = vc
        }

        guard let window = self.topWindow else { return }

        window.addSubview(self)
        self.center = window.center
        self.frame = window.bounds
    }

    open func hide(animated: Bool = true) {

        isShow = false

        if animated {
            UIView.animate(withDuration: 1.0) { [weak self] in

                self?.topWindow?.alpha = 0
                self?.alpha = 0
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) { [weak self] in

                self?.removeFromSuperview()
                self?.topWindow?.isHidden = true
                self?.topWindow = nil
            }
        } else {
            self.removeFromSuperview()
            self.topWindow?.isHidden = true
            self.topWindow = nil
        }
    }
}
