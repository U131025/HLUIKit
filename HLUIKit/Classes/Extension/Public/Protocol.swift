//
//  Protocol.swift
//  SwiftDemo
//
//  Created by Mojy on 2018/1/30.
//  Copyright © 2018年 com.swiftdemo.app. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RxCocoa
import RxSwift

public enum ExResult {
    case ok(message: Any?)
    case failed(message: Any?)
    case systemFailed(message: Any?)
    case empty
    case timeout
}

public extension ExResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

public enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

public extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
