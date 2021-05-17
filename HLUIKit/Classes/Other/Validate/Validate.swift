//
//  Validate.swift
//  IM_XMPP
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable identifier_name
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length

import Foundation

/// 校验
///
/// - email: 邮箱
/// - phoneNum: 手机
/// - carNum: 卡号
/// - username: 用户名
/// - password: 密码
/// - nickname: 昵称
/// - purInt: 纯数字
/// - URL: URL
/// - IP: IP地址
public enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case phoneOrEmail(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    case purInt(_: String)
    case url(_: String)
    case ip(_: String)
    case dynamicCode(_: String)
    case recommendCode(_: String)
    case bankCardNum(_: String)
    case allAreaPhone(_: String)
    case loginPassword(_: String)

    func createRule() -> (predicateStr: String, currObject: String) {
        var predicateStr: String!
        var currObject: String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str.lowercased()
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"
            currObject = str
        case let .phoneOrEmail(str):

            if str.contains("@") == true {
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                currObject = str.lowercased()
            } else {
                predicateStr = "^[A-Za-z0-9]{6,20}+$"
                currObject = str
            }

        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            //字母，数字，特殊字符两两组合
            predicateStr = "^((?=.*?[a-zA-Z])(?=.*?[0-9])|(?=.*?[a-zA-Z])(?=.*?[_~!@$%&,;/?\\-\\.\\*\\#])|(?=.*?[0-9])(?=.*?[_~!@$%&,;/?\\-\\.\\*\\#]))[A-Za-z0-9_~!@$%&,;/?\\-\\.\\*\\#]{8,20}$"
            currObject = str
        case let .loginPassword(str):
            predicateStr = "^[A-Za-z0-9_~!@$%&,;/?\\-\\.\\*\\#]{6,20}$"
            currObject = str
        case let .nickname(str):
            // "[^(\\u4E00-\\u9FA5)|(a-zA-Z0-9_~!@$%&,;/?\\-\\.\\*\\#)]"
            predicateStr = "^[(\\u4E00-\\u9FA5)|(a-zA-Z0-9_~!@$%&,;/?\\-\\.\\*\\#)]{4,8}$"
            currObject = str
        case let .url(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .ip(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        case let .purInt(str):
            predicateStr = "^[0-9]{0, 30}$"
            currObject = str

        case let .dynamicCode(str):
            predicateStr = "^[0-9]{6}$"
            currObject = str
        case let .recommendCode(str):
            predicateStr = "^[A-Za-z0-9]{6}$"
            currObject = str
        case let .bankCardNum(str):
            predicateStr = "^[0-9]{5, 30}$"
            currObject = str
        case let .allAreaPhone(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        }
        return (predicateStr, currObject)
    }

    /// 输入规则
    public var isRight: Bool {
        
        if case .purInt(let string) = self {
            let scan: Scanner = Scanner(string: string)
            var val:Int = 0
            return scan.scanInt(&val) && scan.isAtEnd
        }

        let (predicateStr, currObject) = createRule()
        let predicate =  NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with: currObject)
    }

    var regularExpressions: String {
        let (predicateStr, currObject) = createRule()
        return currObject.pregReplace(pattern: predicateStr, with: "")
    }
}
