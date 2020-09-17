//
//  UIApplication+Rx.swift
//  BluetoothBox2
//
//  Created by mojingyu on 2019/1/27.
//  Copyright © 2019 Mojy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//自定义应用状态枚举
public enum AppState {
    case active
    case inactive
    case background
    case terminated
}

//扩展
extension UIApplication.State {
    //将其转为我们自定义的应用状态枚举
    public func toAppState() -> AppState {
        switch self {
        case .active:
            return .active
        case .inactive:
            return .inactive
        case .background:
            return .background
        @unknown default:
            return .active
        }
    }
}

//UIApplicationDelegate 代理委托
public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>,
UIApplicationDelegate, DelegateProxyType {

    public weak private(set) var application: UIApplication?

    public init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxUIApplicationDelegateProxy(application: $0) }
    }

    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?,
                                          to object: UIApplication) {
        object.delegate = delegate
    }

    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?,
                                            retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
}

//UIApplication的Rx扩展
extension Reactive where Base: UIApplication {

    //代理委托
    public var delegate: DelegateProxy<UIApplication, UIApplicationDelegate> {
        return RxUIApplicationDelegateProxy.proxy(for: base)
    }

    //应用重新回到活动状态
    public var didBecomeActive: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map { _ in return .active}
    }

    //应用从活动状态进入非活动状态
    public var willResignActive: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map { _ in return .inactive}
    }

    //应用从后台恢复至前台（还不是活动状态）
    public var willEnterForeground: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
            .map { _ in return .inactive}
    }

    //应用进入到后台
    public var didEnterBackground: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map { _ in return .background}
    }

    //应用终止
    public var willTerminate: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map { _ in return .terminated}
    }

    //应用各状态变换序列
    public var state: Observable<AppState> {
        return Observable.of(
            didBecomeActive,
            willResignActive,
            willEnterForeground,
            didEnterBackground,
            willTerminate
            )
            .merge()
            .startWith(base.applicationState.toAppState()) //为了让开始订阅时就能获取到当前状态
    }
}
