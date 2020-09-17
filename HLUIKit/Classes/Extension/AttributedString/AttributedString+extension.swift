//
//  AttributedString+extension.swift
//  YYTextDemo
//
//  Created by apple on 2018/12/12.
//  Copyright © 2018 apple. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable identifier_name

import Foundation

public let screenW = UIScreen.main.bounds.size.width
public let screenH = UIScreen.main.bounds.size.height

extension NSMutableAttributedString {

    convenience public init(text: String, font: UIFont, textColor: UIColor) {
        self.init()
        guard let regix = try? NSRegularExpression(pattern: "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]", options: .caseInsensitive) else {
            return
        }
        let results = regix.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

        var index = 0

        for result in results {

            if result.range.location != index {
                let att = NSAttributedString(string: text.subStringWithRang(location: index, length: result.range.location - index), attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor])
                self.append(att)
            }

            let key = text.subStringWithRang(location: result.range.location, length: result.range.length)

            let att = NSAttributedString(string: key, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor])
            self.append(att)

            index = result.range.location + result.range.length
        }

        if index != text.count {
            let att = NSAttributedString(string: text.subStringWithRang(location: index, length: text.count - index), attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor])
            self.append(att)
        }
    }
}

extension NSAttributedString {

    public static func initWith(image: UIImage?, key: String?, font: UIFont) -> NSAttributedString {

        let att = NSTextAttachment()
        att.image = image
        att.bounds = CGRect(x: 0, y: -0.2 * font.ascender, width: font.ascender * 1.2, height: font.ascender * 1.2)
        att.faceKey = key

        return NSAttributedString(attachment: att)
    }
}

extension NSMutableAttributedString {
    open func textClick(tapAction: (UIView, NSAttributedString, NSRange, CGRect) -> Void) {

    }
}

extension String {

    public func subStringWithRang(location: Int, length: Int) -> String {

        var loc = location
        if loc > self.count {
            loc = self.count
        }

        let start = self.index(self.startIndex, offsetBy: loc)
        var en = location + length
        if en > self.count {
            en = self.count
        }
        let end = self.index(self.startIndex, offsetBy: en)
        return String(self[start..<end])
    }
}

// @的规则
//"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
//
// #话题#的规则
//"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
//
// url链接的规则
//"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";

var NSTextAttachmentFaceKey = 100

extension NSTextAttachment {

    public var faceKey: String? {

        get {
            return objc_getAssociatedObject(self, &NSTextAttachmentFaceKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &NSTextAttachmentFaceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

//
extension NSAttributedString {

    var font: UIFont? {
        return getFont(at: 0)
    }

    func getFont(at index: Int) -> UIFont? {
        let font = getAttribute(attributeName: NSAttributedString.Key.font, at: index) as? UIFont
        return font
    }

    func getAttribute(attributeName: NSAttributedString.Key, at index: Int) -> Any? {

        var index = index
        if length > 0 && length == index {
            index -= 1
        }

        return attribute(attributeName, at: index, effectiveRange: nil)
    }
}
