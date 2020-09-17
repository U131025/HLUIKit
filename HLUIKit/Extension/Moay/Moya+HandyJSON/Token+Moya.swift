//
//  Token+Moya.swift
//  Exchange
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON

let authorizationInvalidate = "AuthorizationInvalidate"

//extension ObservableType where E == Response {
//    func filterAuthorizationInvalidate() -> Observable<E> {
//        return flatMap { response -> Observable<E> in
//            return Observable.just(response.handleAuthorizationInvalidateCode())
//        }
//    }
//}
