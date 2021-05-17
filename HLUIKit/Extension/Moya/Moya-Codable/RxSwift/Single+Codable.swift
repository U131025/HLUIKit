//
//  PrimitiveSequence + Codable.swift
//  GamerSky
//
//  Created by QY on 2018/5/5.
//  Copyright © 2018年 QY. All rights reserved.
//

import RxSwift
import Moya
import Cache

extension PrimitiveSequence where Trait == SingleTrait, Element: Codable {

    public func storeCachedObject(for target: TargetType) -> Single<Element> {
        return map { object -> Element in

            CacheManager.setObject(object, forKey: target.cachedKey)
            return object
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    public func storeCachedResponse(for target: TargetType) -> Single<Response> {
        return map { response -> Response in

            CacheManager.setResponse(response, forKey: target.cachedKey)
            return response
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapObject<T: Codable>(_ type: T.Type, atKeyPath path: String? = nil) -> Single<T> {

        return map {

            guard let response = try? $0.map(type, atKeyPath: path, failsOnEmptyData: true) else {

                throw MoyaError.jsonMapping($0)
            }

            return response
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Codable {

    public func setObject(for target: TargetType) -> Single<Element> {

        return flatMap { object -> Single<Element> in

            CacheManager.setObject(object, forKey: target.cachedKey)
            return Single.just(object)
        }
    }
}
