//
//  RealmHelper.swift
//  Exchange
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

let realmIdentifier = "MyInMemoryRealm"

class RealmHelper {

    enum RealmNofityType {
        case initial
        case update
    }

    /// 配置数据库
    class func configRealm() {

        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 2

        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { _, oldSchemaVersion in

            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if oldSchemaVersion < schemaVersion {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in

            /* Realm 成功打开，迁移已在后台线程中完成 */
            if realm != nil {
                print("Realm 数据库配置成功")
            } else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }

    static func queryFirst<Element: Object>(_ type: Element.Type, predicate: NSPredicate? = nil, identifier: String? = nil) -> Element? {

        let finder = query(type, predicate: predicate, identifier: identifier)?.first?.copy()
        return finder as? Element
    }

    static func query<Element: Object>(_ type: Element.Type, predicate: NSPredicate? = nil, identifier: String? = nil) -> Results<Element>? {

        var realm: Realm?
        if let identifier = identifier {
            realm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: identifier))
        } else {
            realm = try? Realm()
        }

        guard let realmObj = realm else {
            return nil
        }

        var finders = realmObj.objects(type)
        if let predicate = predicate {
            finders = finders.filter(predicate)
        }

        return finders
    }

    static func update(_ list: [Object], identifier: String? = nil, isReset: Bool = false) {

        let queue = DispatchQueue(label: "RealmQueueIdetifier", qos: .background)
        queue.async {
            autoreleasepool {

                do {
                    var realm: Realm
                    if let identifier = identifier {
                        realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: identifier))
                    } else {
                        realm = try Realm()
                    }

                    realm.beginWrite()

                    if isReset == true {
                        if let obj = list.first {

                            let finders = realm.objects(type(of: obj))
                            if finders.count > 0 {
                                realm.delete(finders)
                            }
                        }
                    }

                    for obj in list {
                        realm.create(type(of: obj), value: obj, update: Realm.UpdatePolicy.all)
                    }
                    try realm.commitWrite()

                } catch {

                }
            }
        }
    }

    static func notify(_ objType: Object.Type, _ predicate: NSPredicate? = nil, identifier: String? = nil) -> Observable<RealmNofityType> {

        return Observable.create({ (obs) -> Disposable in

            var realm: Realm?
            if let identifier = identifier {
                realm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: identifier))
            } else {
                realm = try? Realm()
            }

            guard let realmObj = realm else {
                return Disposables.create()
            }

            var results = realmObj.objects(objType)
            if let predicate = predicate {
                results = results.filter(predicate)
            }

            let notificationToken = results.observe({(changes: RealmCollectionChange) in

                switch changes {
                case .initial:
                    obs.onNext(.initial)
                case .update:
                    obs.onNext(.update)
                default:
                    break
                }
            })

            return Disposables.create {
                notificationToken.invalidate()
            }
        })
    }

    /// 删除会有异常，Object需要实现NSCopying协议
    static func remove(_ objType: Object.Type, predicate: NSPredicate? = nil, identifier: String? = nil) {

        do {
            var realm: Realm?
            if let identifier = identifier {
                realm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: identifier))
            } else {
                realm = try? Realm()
            }

            guard let realmObj = realm else {
                return
            }

            var finders = realmObj.objects(objType)
            if let predicate = predicate {
                finders = finders.filter(predicate)
            }

            if finders.count == 0 { return }

            try realmObj.write {
                realmObj.delete(finders)
            }
        } catch {

        }
    }

}

extension Object {

    func save() {
        RealmHelper.update([self])
    }
}
