//
//  TransitionStyleType.swift
//  Present自定义转场效果
//
//  Created by mac on 2019/11/22.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable multiple_closures_with_trailing_closure

import Foundation

public protocol TransitionStyleAnimationType {

    func presentTransitionAnimation(_ transitionContext: UIViewControllerContextTransitioning, isPresenting: Bool, duration: TimeInterval)
}

public enum TransitionStyleType {
    case push
}

extension TransitionStyleType: TransitionStyleAnimationType {

    public func presentTransitionAnimation(_ context: UIViewControllerContextTransitioning, isPresenting: Bool, duration: TimeInterval) {

        switch self {
        case .push:
            pushTransitionAnimation(context, isPresenting, duration)
//        default:
//            break
        }
    }
}

extension TransitionStyleType {

    public func pushTransitionAnimation(_ transitionContext: UIViewControllerContextTransitioning, _ isPresenting: Bool, _ duration: TimeInterval) {

        // 转场容器
        let container = transitionContext.containerView

        // 转场控制器
        let toVC = transitionContext.viewController(forKey: !isPresenting ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: isPresenting ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to)!

        // 转场视图
        let toView = toVC.view!
        let fromView = fromVC.view!

        // 初始位置
        if isPresenting {
            fromView.transform = CGAffineTransform(translationX: 0, y: 0)
            toView.transform = CGAffineTransform(translationX: kScreenW, y: 0)
        } else {
            fromView.transform = CGAffineTransform(translationX: -kScreenW, y: 0)
            toView.transform = CGAffineTransform(translationX: 0, y: 0)
        }

        // 加入转场容器
        container.addSubview(toView)
        container.addSubview(fromView)

        // 动画实现
        UIView.animate(withDuration: duration, animations: {

            if isPresenting {
                toView.transform = CGAffineTransform(translationX: 0, y: 0)
                fromView.transform = CGAffineTransform(translationX: -kScreenW, y: 0)
            } else {
                toView.transform = CGAffineTransform(translationX: kScreenW, y: 0)
                fromView.transform = CGAffineTransform(translationX: 0, y: 0)
            }

        }) { (_) in

            fromView.transform = .identity
            toView.transform = CGAffineTransform.identity
            transitionContext.completeTransition(true)
        }
    }
}
