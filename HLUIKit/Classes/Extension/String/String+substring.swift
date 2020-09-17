//
//  String+substring.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

extension String {
    public func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }

        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }

        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }

        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }

        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }

        return String(self[startIndex ..< endIndex])
    }

    public func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }

    public func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }

    public func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }

        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }

        return self.substring(from: from, to: end)
    }

    public func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }

        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }

        return self.substring(from: start, to: to)
    }

    //从0索引处开始查找是否包含指定的字符串，返回Int类型的索引
    //返回第一次出现的指定子字符串在此字符串中的索引
    public func findFirst(_ sub: String) -> Int {
        var pos = -1
        if let range = range(of: sub, options: .literal ) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }

    //从0索引处开始查找是否包含指定的字符串，返回Int类型的索引
    //返回最后出现的指定子字符串在此字符串中的索引
    public func findLast(_ sub: String) -> Int {
        var pos = -1
        if let range = range(of: sub, options: .backwards ) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
}
