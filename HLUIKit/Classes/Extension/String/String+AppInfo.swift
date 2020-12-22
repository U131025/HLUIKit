//
//  String+AppInfo.swift
//  JingPeng
//
//  Created by 屋联-神兽 on 2020/10/26.
//

import Foundation

extension String {
    
    static public var appVersion: String {
        let infoDic = Bundle.main.infoDictionary

        // 获取App的版本号
        let appVersion = infoDic?["CFBundleShortVersionString"]
        return appVersion as? String ?? ""
    }
    
    // 获取App的build版本
    static public var appBuildVersion: String {
        let infoDic = Bundle.main.infoDictionary

        
        return infoDic?["CFBundleVersion"] as? String ?? ""
    }

    // 获取App的名称
    static public var appName: String {
        let infoDic = Bundle.main.infoDictionary

        return infoDic?["CFBundleDisplayName"] as? String ?? ""
    }
}
