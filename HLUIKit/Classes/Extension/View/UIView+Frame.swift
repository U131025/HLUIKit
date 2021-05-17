//
//  UIView+Frame.swift
//  RxBaseUIKit
//
//  Created by mac on 2020/6/2.
//

import Foundation

public extension UIView {

    var left: CGFloat {
        get {
            return bounds.minX
        }
        set {
            var tframe = frame
            tframe.origin.x = newValue
            frame = tframe
        }
    }

    var right: CGFloat {
        get {
            return frame.origin.x + frame.width
        }
        set {
            var tframe = frame
            tframe.origin.x = newValue - frame.width
            frame = tframe
        }
    }

    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tframe = frame
            tframe.origin.y = newValue
            frame = tframe
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.height
        }
        set {
            var tframe = frame
            tframe.origin.y = newValue - frame.height
            frame = tframe
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tframe = frame
            tframe.size.width = newValue
            frame = tframe
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tframe = frame
            tframe.size.height = newValue
            frame = tframe
        }
    }
}
