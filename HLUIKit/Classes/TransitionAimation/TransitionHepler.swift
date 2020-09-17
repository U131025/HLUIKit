//
//  TransitionHepler.swift
//  Community
//
//  Created by mac on 2019/11/22.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

public class TransitionHelper: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    static public let shared = TransitionHelper(styleType: .push)

    public var styleType: TransitionStyleType = .push

    public init(styleType: TransitionStyleType) {
        self.styleType = styleType
    }

    public func setStyleType(_ styleType: TransitionStyleType) -> Self {
        self.styleType = styleType
        return self
    }

    // 转场持续时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    // 过场动画实现
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 动画持续时间
        let duration = self.transitionDuration(using: transitionContext)

        self.styleType.presentTransitionAnimation(transitionContext, isPresenting: self.isPresenting, duration: duration)
    }

    private var isPresenting = false

    //UIViewControllerTransitioningDelegate代理方法
    //presented
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }

    //dismissed
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }

}
