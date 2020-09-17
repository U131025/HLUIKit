//
//  UITextField+placeholder.swift
//  Exchange
//
//  Created by mac on 2018/12/10.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

var placeholderTextColorKey = 100

extension UITextField {

    public var placeholderTextColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &placeholderTextColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)

//            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")

            if let string = self.placeholder, let color = newValue {
                self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
            }
        }

        get {
            if let rs = objc_getAssociatedObject(self, &placeholderTextColorKey) as? UIColor {
                return rs
            }
            return nil
        }
    }

    public func setPlaceholder(_ value: String?) {

        self.placeholder = value

        if let string = value, let color = self.placeholderTextColor {
            self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}
