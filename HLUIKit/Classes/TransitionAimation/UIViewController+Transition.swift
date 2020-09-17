//
//  UIViewController+Transition.swift
//  Community
//
//  Created by mac on 2019/11/22.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

/*私有API
cube                   立方体效果
pageCurl               向上翻一页
pageUnCurl             向下翻一页
rippleEffect           水滴波动效果
suckEffect             变成小布块飞走的感觉
oglFlip                上下翻转
cameraIrisHollowClose  相机镜头关闭效果
cameraIrisHollowOpen   相机镜头打开效果
*/

extension UIViewController {

    public func present(_ viewController: UIViewController, transiotnStyle: CATransitionType, direction: CATransitionSubtype = .fromTop) {

        let transition = CATransition()
        transition.duration = 0.5

        /*
        3.设置切换速度效果
        枚举值:
        kCAMediaTimingFunctionLinear
        kCAMediaTimingFunctionEaseIn
        kCAMediaTimingFunctionEaseOut
        kCAMediaTimingFunctionEaseInEaseOut
        kCAMediaTimingFunctionDefault
        */
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)

        /*
         4.动画切换风格
         枚举值:
         kCATransitionFade = 1,     // 淡入淡出
         kCATransitionPush,         // 推进效果
         kCATransitionReveal,       // 揭开效果
         kCATransitionMoveIn,       // 慢慢进入并覆盖效果
         */
        transition.type = transiotnStyle

        /*
         5.动画切换方向
         枚举值:
         kCATransitionFromRight//右侧
         kCATransitionFromLeft//左侧
         kCATransitionFromTop//顶部
         kCATransitionFromBottom//底部
         */
        transition.subtype = direction

        self.view.window?.layer.add(transition, forKey: nil)
        present(viewController, animated: false)
    }
}
