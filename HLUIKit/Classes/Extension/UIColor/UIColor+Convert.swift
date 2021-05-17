//
//  UIColor+Convert.swift
//  Exchange
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable identifier_name
// swiftlint:disable large_tuple

import Foundation
import UIKit

public func RGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return RGBA(red, green, blue, 1.0)
}

public func RGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

public func createImageWithColor(color: UIColor, height: CGFloat = 1.0) -> UIImage {
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let thempImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return thempImage!
}

extension UIColor {
    public var image: UIImage {
        return createImageWithColor(color: self)
    }
}

extension UIColor {
    public enum RGBType {
        case Red
        case Green
        case Blue
    }

    public var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }

    convenience public init(hex: String) {
                
        let scanner = Scanner(string: hex.pregReplace(pattern: "#", with: ""))
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }

    public func getValue(type: RGBType) -> Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        switch type {
        case .Red:
            return Int(r * 0xff)
        case .Green:
            return Int(g * 0xff)
        case .Blue:
            return Int(b * 0xff)
        }
    }
}

extension UIColor {
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    public convenience init?(hex: String, alpha: CGFloat = 1.0) {
        guard hex.count >= 6 else {
            return nil
        }
        var hexString = hex.uppercased()
        if hexString.hasPrefix("##") || hexString.hasPrefix("0x") {
            hexString = (hexString as NSString).substring(from: 2)
        } else if hexString.hasPrefix("#") {
            hexString = (hexString as NSString).substring(from: 1)
        }

        var range = NSRange(location: 0, length: 2)
        let rStr = (hexString as NSString).substring(with: range)
        range.location = 2
        let gStr = (hexString as NSString).substring(with: range)
        range.location = 4
        let bStr = (hexString as NSString).substring(with: range)

        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)

        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }

    public func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
