//
//  UIView+RoundCorner.swift
//  添加圆角
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

extension CAShapeLayer {

    public static func createRoundCorner(frame: CGRect, cornerRadii: CGSize, type: UIRectCorner) -> CAShapeLayer {

        let maskPath = UIBezierPath(roundedRect: frame, byRoundingCorners: type, cornerRadii: cornerRadii)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = frame
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
}

extension UIView {

    public func createRoundCorner(type: UIRectCorner, cornerRadii: CGSize = CGSize(width: 5, height: 5)) {

        layoutIfNeeded()

        let maskLayer = CAShapeLayer.createRoundCorner(frame: self.bounds, cornerRadii: cornerRadii, type: type)

        self.layer.mask = maskLayer
    }
}
