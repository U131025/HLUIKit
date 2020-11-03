//
//  Moya+Codable.swift
//  Moya+Codable
//
//  Created by QY on 2018/3/31.
//  Copyright © 2018年 QY. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable identifier_name

import Foundation
import Moya

public class MoyaPlugsConfig {
    public static let shared = MoyaPlugsConfig()
    public var plugins = [PluginType]()
    
    public init() {
    }
    
    public func reload() {
        ApiProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure, plugins: plugins)
    }
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 15
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

public var ApiProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure, plugins: MoyaPlugsConfig.shared.plugins)

//public let ApiProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure, plugins: [LogPlugin(), ErrorCodePlugin()])
