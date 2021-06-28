//
//  ToModelExtension.swift
//  ZhiHu+RxSwift
//
//  Created by like on 2017/1/28.
//  Copyright © 2017年 like. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

open class HLBaseModel: NSObject, HandyJSON {
    public static var isMapping: Bool = false
    
    required public override init() {}
    
    open func mapping(mapper: HelpingMapper) {
        //        mapper <<< self.des <-- "description"
    }
    
    public func toJsonWithMapping() -> [String : Any] {
        HLBaseModel.isMapping = true
        let result = toJSON() ?? [:]
        HLBaseModel.isMapping = false
        return result
    }
    
    public func copy(with model: HLBaseModel) {
        var obj = self
        let json = model.toJSON()
        JSONDeserializer.update(object: &obj, from: json)
    }
}

extension ObservableType where Element == Any {

    public func mapModel<T: HandyJSON>(_ type: T.Type, handleError: Bool = true) -> Observable<T> {

        return flatMap({ (base) -> Observable<T> in

            if let jsonString = base as? String {
                return jsonString.mapModel(T.self)
            } else if let jsonData = base as? Data {
                if let jsonString = String.init(data: jsonData, encoding: .utf8) {
                    return jsonString.mapModel(T.self)
                }
            }

            return Observable.error(RxError.noElements)
        })
    }

}

public extension String {

    func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {

        if let model = JSONDeserializer<T>.deserializeFrom(json: self) {

//            print("==== mapModel: \(model)")
            return Observable.just(model)
        }
        return Observable.error(RxError.noElements)
    }
    
    func mapToModel<T: HandyJSON>(_ type: T.Type) -> T? {
        return JSONDeserializer<T>.deserializeFrom(json: self)
    }
}
