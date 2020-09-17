//
//  String+Emoji.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

extension String {
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    public func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x1F1F3...0x1F1FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }
        return false
    }

    public func containsSymbol() -> Bool {

        let symbols = "~,￥,#,&,*,<,>,《,》,(,),[,],{,},【,】,^,@,/,￡,¤,,|,§,¨,「,」,『,』,￠,￢,￣,（,）,——,+,|,$,_,€,¥"
        let specialStringArray = symbols.components(separatedBy: ",")

        for symbol in specialStringArray {
            if (self as NSString).range(of: symbol).location != NSNotFound {
                return true
            }
        }
        return false
    }

    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    public func hasEmoji() -> Bool {
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 判断是不是九宫格
    ///
    /// - Returns: true false
    public func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 然后是去除字符串中的表情
    ///
    /// - Parameter text: text
    public func disable_emoji(text: NSString) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)
            let modifiedString = regex.stringByReplacingMatches(in: text as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: text.length), withTemplate: "")
            return modifiedString
        } catch {
            print(error)
        }
        return ""
    }
}
