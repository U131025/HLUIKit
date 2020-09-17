//
//  Define.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

/// 测试模式 true: 使用；false：不使用
let TESTMODLE = true
//let TESTMODLE = Platform.isSimulator

//var kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate

//iPhone X 宏定义
public let isIPhoneX = UIDevice.current.isX()

// 屏幕宽度
public let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
public let kScreenW = UIScreen.main.bounds.width

public let kScreenSize = UIScreen.main.bounds

//适配因子，以6P为准 6P逻辑分辨率: 414x736
public let scaleRate = 1 / 414.0 * kScreenW

//适配因子，以6为准 6逻辑分辨率: 375 * 667
public let scaleRateIphone6 = 1 / 375.0 * kScreenW

/// 屏幕尺寸大于 375 * 667
public let kMoreIphone6Size = scaleRateIphone6 > 1.0 ? true : false

// 距离底部的安全区域
public let safeAreaBottom: CGFloat = isIPhoneX ? 34.0 : 0.0

/// 获取statusBar的高度
public let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

/// Navigation bar height.
public let kNavigationBarHeight: CGFloat = 44 + kStatusBarHeight

/// Tabbar height.
public let kTabbarHeight: CGFloat = isIphoneXSeries() ? (49+34) : 49
