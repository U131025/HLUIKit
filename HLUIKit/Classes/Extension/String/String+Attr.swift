//
//  String+Attr.swift
//  Community
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension String {

    public func toAttrText(_ color: UIColor, _ font: UIFont = .systemFont(ofSize: 15)) -> NSMutableAttributedString {
        return NSMutableAttributedString(text: self, font: font, textColor: color)
    }

    public func hightlightText(_ font: UIFont = .pingfang(ofSize: 15), _ hightlightColor: UIColor = .systemRed, _ hightlightText: String = "*") -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString(string: self, attributes: [.font: font])

        let index = findFirst(hightlightText)
        if index >= 0 {
            attributedString.setAttributes([.foregroundColor: hightlightColor], range: NSRange.init(location: index, length: hightlightText.count))
        }

        return attributedString
    }
}
