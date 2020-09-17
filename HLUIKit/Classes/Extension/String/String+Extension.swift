//
//  String+Extension.swift
//  Exchange
//
//  Created by mac on 2018/12/10.
//  Copyright © 2018 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

extension String {

    /// range转换为NSRange
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// range -> NSRange
//    func nsRange(from range: Range<String.Index>) -> NSRange? {
//        
//        let utf16view = self.utf16
//        
//        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
//            
//            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
//            
//        }
//        return nil
//    }
//

    /// 查找子字符串
    public func ranges(of string: String) -> (range: [Range<String.Index>], nsRnage: [NSRange]) {

        var rangeArray = [Range<String.Index>]()
        var nsRangeArray = [NSRange]()
        var searchedRange: Range<String.Index>

        guard let sr = self.range(of: self) else {
            return (rangeArray, nsRangeArray)
        }

        searchedRange = sr
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)

        while let range = resultRange {
            rangeArray.append(range)
            nsRangeArray.append(NSRange(range, in: self))
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }

        return (rangeArray, nsRangeArray)
    }

    /// NSRange转化为range
    public func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    /// 在字符串中查找另一字符串首次出现的位置（或最后一次出现位置）
    public func positionOf(sub: String, backwards: Bool = false) -> Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }

    public func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

}

extension String {

    public func height(for font: UIFont, width: CGFloat, lineSpace: CGFloat? = nil, isTextView: Bool = true) -> CGFloat {

        if isTextView {
            let textView = UITextView()
            textView.font = font
            textView.text = self

            let textViewWidth = width - textView.textContainer.lineFragmentPadding*2
            let size = textView.sizeThatFits(CGSize.init(width: textViewWidth, height: CGFloat(MAXFLOAT)))

            return size.height
        } else {

            let label = UILabel()
            label.numberOfLines = 0
            label.font = font

            // 设置行距时
            if let space = lineSpace {

                let paragraphStye = NSMutableParagraphStyle()
                //调整行间距
                paragraphStye.lineSpacing = space
                paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
                let attributedString = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStye])

                label.attributedText = attributedString
            } else {
                label.text = self
            }

            let size = label.sizeThatFits(CGSize.init(width: width, height: CGFloat(MAXFLOAT)))

            return size.height
        }
    }

}

//作者：船长_
//链接：https://www.jianshu.com/p/b23f0ac70826
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
