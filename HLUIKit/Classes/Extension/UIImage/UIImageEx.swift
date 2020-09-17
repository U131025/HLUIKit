//
//  UIImageEx.swift
//  IM_XMPP
//
//  Created by mojingyu on 2018/9/14.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable line_length

import Foundation
import UIKit

extension UIImage {
    /**
     *  重设图片大小
     */
    public func reSizeImage(reSize: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    /**
     *  等比率缩放
     */
    public func scaleImage(scaleSize: CGFloat) -> UIImage {
        let reSize = CGSize.init(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UIImage {
    // 图片置灰
    public var grayImage: UIImage {

        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let cgImage = context!.makeImage()
        let grayImage = UIImage.init(cgImage: cgImage!)

        return grayImage
    }
}
