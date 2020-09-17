//
//  LocalizationEx.swift
//  IM_XMPP
//
//  Created by mac on 2018/8/30.
//  Copyright © 2018年 mac. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 本地化字符串
    public var localized: String {
        return localizedString(self)
    }
}

//本地化字符串
public func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

// MARK: 本地化
extension UILabel {
    @IBInspectable public var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
//            text = LanguageHelper.getString(newValue)
            text = localizedString(newValue)
        }
        get { return text }
    }
}

extension UIButton {
    @IBInspectable public var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
//            setTitle(LanguageHelper.getString(newValue), for: .normal)
            setTitle(localizedString(newValue), for: .normal)
        }
        get { return titleLabel?.text }
    }
}

extension UITextField {
    @IBInspectable public var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
            placeholder = localizedString(newValue)
//            placeholder = LanguageHelper.getString(newValue)
        }
        get { return placeholder }
    }
}

extension UITabBarItem {

    @IBInspectable public var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
            title = localizedString(newValue)
//            title = LanguageHelper.getString(newValue)
        }
        get { return title }
    }
}

extension UIViewController {
    @IBInspectable public var localizedTitle: String? {
        set {
            guard let newValue = newValue else { return }
            title = localizedString(newValue)
//            title = LanguageHelper.getString(newValue)
        }
        get { return title }
    }

}

//作者：BYQiu
//链接：https://www.jianshu.com/p/33667186f1a8
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
