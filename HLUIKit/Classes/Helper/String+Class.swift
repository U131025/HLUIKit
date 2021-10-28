//
//  String+Class.swift
//  VGCLIP
//
//  Created by mojingyu on 2019/4/16.
//  Copyright © 2019 Mojy. All rights reserved.
//

import Foundation

extension String {
    public func toClass() -> AnyClass? {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            assert(false, "命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls: AnyClass? = NSClassFromString((clsName) + "." + self)
        if let clsType = cls {
            return clsType
        } else {
            // HLUIKit命名空间
            guard let clsType = NSClassFromString("HLUIKit" + "." + self) else {
                assert(false, "无法通过类名转换成成类: \(self)")
                return nil
            }
            return clsType
        }
    }
}
