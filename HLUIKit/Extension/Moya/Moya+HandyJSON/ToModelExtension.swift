//
//  ToModelExtension.swift
//  ZhiHu+RxSwift
//
//  Created by like on 2017/1/28.
//  Copyright © 2017年 like. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON

extension ObservableType where Element: TargetType {

    public func request() -> Observable<Response> {

        return flatMap { target -> Observable<Response> in

            let source = target.request().storeCachedResponse(for: target).asObservable()
            if let response = target.cachedResponse {
                return Observable.just(response)
//                return source.startWith(response)
            }
            return source
        }
    }
}

extension ObservableType where Element == Response {

    public func mapModel<T: HandyJSON>(_ type: T.Type, handleError: Bool = true) -> Observable<T> {
        return flatMap { response -> Observable<T> in

            return Observable.just(response.mapModel(T.self, handleError))
        }
    }
}

public extension Response {

    func mapModel<T: HandyJSON>(_ type: T.Type, _ handleError: Bool) -> T {

        let jsonString = String.init(data: data, encoding: .utf8)

        guard JSONDeserializer<HLBaseModel>.deserializeFrom(json: jsonString) != nil  else {
            return T()
        }

        if let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
            return model
        }

        return T()
    }
}
