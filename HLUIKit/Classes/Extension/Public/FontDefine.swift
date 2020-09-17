//
//  FontDefine.swift
//  PingFang SC 字体系列
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

public enum PingFangSCFontType {
    case regular
    case bold
    case medium
    case light
    case ultralight
    case thin

    var fontName: String {
        var fontName: String
        switch self {
        case .regular:
            fontName = "PingFangSC-Regular"
        case .bold:
            fontName = "PingFangSC-Semibold"
        case .medium:
            fontName = "PingFangSC-Medium"
        case .ultralight:
            fontName = "PingFangSC-Ultralight"
        case .thin:
            fontName = "PingFangSC-Thin"
        case .light:
            fontName = "PingFangSC-Light"
        }
        return fontName
    }
}

extension UIFont {

    public class func pingfang(ofSize size: CGFloat, _ type: PingFangSCFontType = .regular) -> UIFont {
        return UIFont(name: type.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
