//
//  LanguageHelper.swift
//  
//
//  Created by lihaifei on 2019/5/16.
//

import UIKit
import RxSwift
import RxCocoa

let UserLanguage = "UserLanguage"
let AppleLanguages = "AppleLanguages"

public protocol HLLanguageType {
    var hl_languageCode: String { get }
}

public extension HLLanguageType {
    var path: String? {
        return Bundle.main.path(forResource: hl_languageCode, ofType: "lproj")
    }
}

extension String: HLLanguageType {
    public var hl_languageCode: String {
        return self
    }
}

public enum HLLanguageTypes: String, HLLanguageType {
    case Chinese = "zh-Hans"
    case English = "en"
    case Tradition = "zh-Hant"

    var description: String {
        switch self {
        case .Chinese:
            return "简体中文".localized
        case .Tradition:
            return "繁体中文".localized
        case .English:
            return "英文".localized
        }
    }
        
    public var hl_languageCode: String {
        return rawValue
    }
}

public class HLLanguageHelper: NSObject {
    
    public static let shared = HLLanguageHelper()
    
    public static var isEnable: Bool = false
    
    let userDefault = UserDefaults.standard
    var bundle : Bundle?
    
    public let languageType = BehaviorRelay<HLLanguageType>(value: HLLanguageTypes.English)
        
    public class func getString(_ key: String) -> String {
                
        if HLLanguageHelper.shared.bundle == nil {
            HLLanguageHelper.shared.initUserLanguage()
        }
        return HLLanguageHelper.shared.bundle?.localizedString(forKey: key, value: nil, table: nil) ?? ""
    }
    
    public func initUserLanguage() {
        
        HLLanguageHelper.isEnable = true
        
        var languageType: HLLanguageType = HLLanguageTypes.English
        if let value = userDefault.value(forKey: UserLanguage) as? String {
            languageType = HLLanguageTypes(rawValue: value) ?? value
        } else {
            let languages = userDefault.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0, let value = languages?.object(at: 0) as? String {
                
                if value.contains(HLLanguageTypes.Chinese.hl_languageCode) {
                    languageType = HLLanguageTypes.Chinese
                } else if value.contains(HLLanguageTypes.Tradition.hl_languageCode) {
                    languageType = HLLanguageTypes.Tradition
                } else {
                    languageType = HLLanguageTypes(rawValue: value) ?? value
                }
            }
        }
        self.languageType.accept(languageType)
        
        if let path = languageType.path ?? HLLanguageTypes.English.path {
            bundle = Bundle(path: path)
        }
    }
    
    public func setLanguage(_ langeuage: HLLanguageType) {
        
        HLLanguageHelper.isEnable = true
        
        guard let path = langeuage.path else {
            return
        }
        bundle = Bundle(path: path)
        userDefault.set(langeuage.hl_languageCode, forKey: UserLanguage)
        userDefault.synchronize()
        
        languageType.accept(langeuage)
    }
    
    public func getLanguage() -> HLLanguageType {
        
        let value = userDefault.object(forKey: UserLanguage) as? String ?? HLLanguageTypes.English.hl_languageCode
        let language: HLLanguageType = HLLanguageTypes.init(rawValue: value) ?? value
        return language
    }
}
