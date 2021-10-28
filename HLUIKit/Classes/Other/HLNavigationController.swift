//
//  CustomNavigationController.swift
//  SwiftDemo
//
//  Created by Mojy on 2018/1/22.
//  Copyright © 2018年 com.swiftdemo.app. All rights reserved.
//

import UIKit

public struct HLThemeConfig {
    public var navBarColor: UIColor = .white
    public var textColor: UIColor = .black
            
    public init(navBarColor: UIColor = .white, textColor: UIColor = .black) {
        // This initializer intentionally left empty
        self.navBarColor = navBarColor
        self.textColor = textColor
    }
}

public enum HLThemeType {
    case white
    case blue
    case clear
    case custom(HLThemeConfig)

    var navBarColor: UIColor {
        switch self {
        case .white:
            return .white
        case .blue:
            return .systemBlue
        case .clear:
            return .clear
        case .custom(let config):
            return config.navBarColor
        }
    }

    var textColor: UIColor {
        switch self {
        case .white:
            return .black
        case .blue:
            return .white
        case .clear:
            return .white
        case .custom(let config):
            return config.textColor
        }
    }

    var isTranslucent: Bool {
        if navBarColor == UIColor.clear {
            return true
        }
        return false
    }
}

extension UIViewController {

    public func changeNavBarTheme(themeType: HLThemeType) {

        let textColor = themeType.textColor
        let navBarColor = themeType.navBarColor

        let bgImage = themeType.isTranslucent ? UIImage() : createImageWithColor(color: navBarColor)

        self.navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)

        self.navigationController?.navigationBar.isTranslucent = themeType.isTranslucent

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: textColor
        ]
    }

    public func setBackImage(_ image: UIImage?) -> Self {

        if let nav = navigationController as? HLNavigationController {
            nav.backImage = image
        }
        return self
    }
}

@objc(CustomNavigationController)
open class HLNavigationController: UINavigationController {

    @IBInspectable public var backImage: UIImage?
    static public var backArrowImage: UIImage?

    // 是否支持侧滑手势
    fileprivate var isEnableEdegePan = true

    override open func viewDidLoad() {
        super.viewDidLoad()

        // 手势代理
        self.interactivePopGestureRecognizer?.delegate = self

        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                                  NSAttributedString.Key.foregroundColor: UIColor.black]

        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.white

//        self.navigationBar.setBackgroundImage(createImageWithColor(color: UIColor.init(hex: "257BFB")), for: .default)

        self.navigationBar.shadowImage = UIImage()

        /// 5s 导航栏背景处理
        for view in self.navigationBar.subviews {

            if view.isKind(of: NSClassFromString("_UIBarBackground")?.class() ?? NSArray.classForCoder() ) {

                for subView in view.subviews where subView is UIImageView {
                    subView.isHidden = true
                }
            }
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if self.viewControllers.count != 0 {

            if let image = backImage ?? HLNavigationController.backArrowImage {

                let leftButton = UIButton(type: .custom)
                leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                leftButton.imageView?.contentMode = .scaleAspectFit
                leftButton.setImage(image, for: .normal)
                leftButton.addTarget(self, action: #selector(backAtion), for: .touchUpInside)

                let buttonItem = UIBarButtonItem.init(customView: leftButton)
                viewController.navigationItem.leftBarButtonItem = buttonItem
            }

            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }

    @objc open func backAtion () {
        popViewController(animated: true)
    }

    //横屏/竖屏
    override open var shouldAutorotate: Bool {
        return false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

}

// MARK: - 开启侧滑功能
extension HLNavigationController: UIGestureRecognizerDelegate {

    /// 启用、禁用屏幕边缘侧滑手势
    public func enableScreenEdgePanGestureRecognizer(_ isEnable: Bool) {
        isEnableEdegePan = isEnable
    }

    // 开始接收到手势的代理方法
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        // 侧滑时结束编辑
    //    UIViewController.current()?.view.endEditing(false)

        if !isEnableEdegePan { // 禁用边缘侧滑手势
            return false
        }

        if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first {
            return false
        }
        return true
    }

    // 接收到多个手势的代理方法
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 判断是否是侧滑相关手势

        let pan = gestureRecognizer as? UIPanGestureRecognizer
        if (gestureRecognizer == self.interactivePopGestureRecognizer) && (pan != nil) {
            let point = pan?.translation(in: self.view)
            // 如果是侧滑相关的手势，并且手势的方向是侧滑的方向就让多个手势共存
            if point!.x > 0 {
                return true
            }
        }

        return false
    }
}
