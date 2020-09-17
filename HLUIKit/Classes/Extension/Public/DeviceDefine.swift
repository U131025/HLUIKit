//
//  DeviceDefine.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

/// 通过安全距离判断是否为 XService
public func isIphoneXSeries() -> Bool {

    if #available(iOS 11.0, *) {

        let window = UIApplication.shared.keyWindow!
        if window.safeAreaInsets.bottom > 0.0 {
            return true
        }
    }

    return false
}

public struct Platform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height >= 812 {
            return true
        }

        return false
    }
}
