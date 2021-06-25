//
//  Wireframe.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/3/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//
// swiftlint:disable line_length

import RxSwift
import JGProgressHUD

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public enum RetryResult {
    case retry
    case cancel
}

public let defaultHUDShowTime: TimeInterval = 2
public typealias CompleteBlock = () -> Void

public protocol Wireframe {
    func open(url: URL?) -> Bool
    func promptFor<Action: CustomStringConvertible>(_ title: String, _ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

open class DefaultWireframe: NSObject, Wireframe {
    static public let shared = DefaultWireframe()
    public let juhua = JGProgressHUD.init(style: .dark)
    public var disposeBag = DisposeBag()
    
    public func getKeyWindow() -> UIWindow? {
        var window: UIWindow? = nil
        if #available(iOS 13.0, *) {
            for windowScene: UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    window = windowScene.windows.first
                    break
                }
            }
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public func open(urls: [URL?]) {
        for url in urls {
            if open(url: url) == true {
                break
            }
        }
    }

    public func open(url: URL?) -> Bool {
        
        guard let url = url else { return false }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {

                #if os(iOS)
                UIApplication.shared.open(url)
                #elseif os(macOS)
                #if swift(>=4.0)
                NSWorkspace.shared.open(url)
                #else
                NSWorkspace.shared.open(url)
                #endif
                #endif

            } else {
                // Fallback on earlier versions
            }
            return true
        } else {
//            showErrorJuhua(message: localizedString("无法打开\(url.absoluteString)"))
            return false
        }
    }

    #if os(iOS)
    private static func rootViewController() -> UIViewController? {
        // cheating, I know
        return UIApplication.shared.keyWindow?.rootViewController
    }
    #endif

    static public func presentAlert(_ title: String, _ message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: localizedString("确定"), style: .cancel) { _ in
            })
            rootViewController()?.present(alertView, animated: true, completion: nil)
        #endif
    }

    public func promptFor<Action: CustomStringConvertible>(_ title: String, _ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }

            DefaultWireframe.rootViewController()?.present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated: false, completion: nil)
            }
        }
        #elseif os(macOS)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
}

extension DefaultWireframe {

    public func showMessageJuhua(message: String?, hideAfter: TimeInterval = defaultHUDShowTime, in view: UIView? = nil, completeBlock: CompleteBlock? = nil) {
        
        if message == nil { return }

        dismissJuhua()
        DispatchQueue.main.async {
            guard let window = view ?? self.getKeyWindow() else {
                return
            }

            let juhua = JGProgressHUD.init(style: .dark)
            juhua.interactionType = .blockNoTouches
            juhua.indicatorView = nil
            juhua.textLabel.text = message ?? ""
            juhua.show(in: window)
            juhua.dismiss(afterDelay: hideAfter)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+hideAfter, execute: {
                completeBlock?()
            })
        }
    }

    public func showInfoJuhua(message: String?, image: UIImage? = nil, style: JGProgressHUDStyle = .dark, backgroundColor: UIColor = .white, hideAfter: TimeInterval = defaultHUDShowTime, completeBlock: CompleteBlock? = nil) {

        dismissJuhua()
        DispatchQueue.main.async {
            guard let window: UIWindow = self.getKeyWindow() else {
                return
            }

            let juhua = JGProgressHUD.init(style: style)
            juhua.interactionType = .blockNoTouches
            juhua.indicatorView = image != nil ? JGProgressHUDImageIndicatorView(image: image!) : nil
            juhua.textLabel.text = message ?? ""
            juhua.show(in: window)
            juhua.contentView.backgroundColor = backgroundColor
            juhua.dismiss(afterDelay: hideAfter)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+hideAfter, execute: {
                completeBlock?()
            })
        }
    }

    public func showErrorJuhua(message: String?, hideAfter: TimeInterval = defaultHUDShowTime) {

        dismissJuhua()
        DispatchQueue.main.async {
            guard let window: UIWindow = self.getKeyWindow() else {
                return
            }

            let juhua = JGProgressHUD.init(style: .dark)
            juhua.interactionType = .blockNoTouches
            juhua.indicatorView = JGProgressHUDErrorIndicatorView.init()
            juhua.textLabel.text = message ?? ""
            juhua.show(in: window)
            juhua.dismiss(afterDelay: hideAfter)
        }
    }

    public func showSuccessJuhua(message: String?, hideAfter: TimeInterval = defaultHUDShowTime) {

        dismissJuhua()
        DispatchQueue.main.async {
            guard let window: UIWindow = self.getKeyWindow() else {
                return
            }

            let juhua = JGProgressHUD.init(style: .dark)
            juhua.interactionType = .blockNoTouches
            juhua.indicatorView = JGProgressHUDSuccessIndicatorView.init()
            juhua.textLabel.text = message ?? ""
            juhua.show(in: window)
            juhua.dismiss(afterDelay: hideAfter)
        }
    }

    public func showWaitingJuhua(message: String? = nil, in view: UIView? = nil, interactionType: JGProgressHUDInteractionType = .blockAllTouches) {

        DispatchQueue.main.async {
            
            if self.juhua.isVisible {
                self.juhua.textLabel.text = message ?? ""
                return
            }
            
            guard let window = view ?? self.getKeyWindow() else {
                return
            }
            self.juhua.indicatorView = JGProgressHUDIndeterminateIndicatorView.init()
            self.juhua.interactionType = .blockAllTouches

            self.juhua.textLabel.text = message ?? ""
            self.juhua.show(in: window)
        }
    }

    public func dismissJuhua() {
        DispatchQueue.main.async {
            if self.juhua.isVisible {
                self.juhua.dismiss()
            }
        }
    }
}

extension RetryResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .retry:
            return localizedString("重试")
        case .cancel:
            return localizedString("取消")
        }
    }
}

extension UIView {

    public func delayHidden(_ time: TimeInterval) {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
            self.removeFromSuperview()
        }
    }
}
