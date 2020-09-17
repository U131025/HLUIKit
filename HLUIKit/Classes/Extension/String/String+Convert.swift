//
//  String+Convert.swift
//  Community
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension String {

    public var firstLetter: String {

        if self.count == 0 { return "" }

        //如果为英文直接返回首字母
        let buf: [UInt8] = Array(self.utf8)
        switch buf[0] {
        case 97...122, 65...90:
            return self.substring(to: 0).uppercased()
        default:
            break
        }

        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString.init(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        // 将拼音首字母装换成大写
        let strPinYin = polyphoneStringHandle(nameString: self, pinyinString: pinyinString).uppercased()
        // 截取大写首字母
        let firstString = strPinYin.substring(to: 0)

        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }

    /// 多音字处理
    fileprivate func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}

        return pinyinString
    }
}
