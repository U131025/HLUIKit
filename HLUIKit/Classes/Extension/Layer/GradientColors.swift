//
//  CAGradientLayer+Color.swift
//  Smart_Speaker
//
//  Created by mojingyu on 2020/3/14.
//  Copyright © 2020 Mojy. All rights reserved.
//

import Foundation
import UIKit

public enum GradientColorDirectionType {
    case horizontal
    case vertical

    public var startPoint: CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    public var endPoint: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 1, y: 0)
        case .vertical:
            return CGPoint(x: 0, y: 1)
        }
    }
}

extension CAGradientLayer {
    //获取彩虹渐变层
    public convenience init(_ gradientColors: [UIColor],
                            _ gradientLocations: [NSNumber],
                            startPoint: CGPoint = CGPoint(x: 0, y: 0),
                            endPoint: CGPoint = CGPoint(x: 1, y: 0)) {
        self.init()

        //创建CAGradientLayer对象并设置参数
        self.colors = gradientColors.map { $0.cgColor }
        self.locations = gradientLocations

        //设置渲染的起始结束位置（横向渐变）
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension UIView {

    /// 添加渐变色背景
    /// - Parameters:
    ///   - colors: 渐变色组
    ///   - locations: 颜色比例
    ///   - direction: 方向
    public func addGradientLayer(_ colors: [UIColor],
                                 _ locations: [NSNumber] = [0.0, 1.0],
                                 _ direction: GradientColorDirectionType = .horizontal) {

        let gradientLayer = CAGradientLayer(colors, locations, startPoint: direction.startPoint, endPoint: direction.endPoint)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}

// 扩展 UIImage 的 init 方法，获得渐变效果
public extension UIImage {
    convenience init?(gradientColors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), _ direction: GradientColorDirectionType = .horizontal) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map { $0.cgColor } as NSArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil) else { return nil }

        // 第二个参数是起始位置，第三个参数是终止位置
        let end = direction == .horizontal ? CGPoint(x: size.width, y: 0) : CGPoint(x: 0, y: size.height)

        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: end, options: CGGradientDrawingOptions(rawValue: 0))

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }

        self.init(cgImage: cgImage)
        UIGraphicsEndImageContext()
    }
}
