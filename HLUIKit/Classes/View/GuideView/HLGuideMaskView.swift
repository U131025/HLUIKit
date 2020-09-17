//
//  GuideMaskView.swift
//  Community
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxGesture

open class HLGuideMaskView: HLPopView {

    open var maskBgView = UIImageView().then { (view) in
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
    }
    
    open var maskItems = [UIView]()

    open lazy var path = UIBezierPath(rect: UIScreen.main.bounds)
    
    open override func initConfig() {
        super.initConfig()
        
        self.addSubview(maskBgView)
        maskBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    open func addBackgroundClickClose() -> Self {
        
        self.rx.tapGesture().when(.recognized)
            .subscribe(onNext: {[unowned self] (_) in
                self.hide(animated: false)
            }).disposed(by: disposeBag)
        
        return self
    }
    
    /// 添加镂空位置
    open func addHollowOutRect(_ frame: CGRect, cornerRadius: CGFloat = 0) -> Self {
        path.append(UIBezierPath.init(roundedRect: frame, cornerRadius: cornerRadius).reversing())
                
        return self
    }
    
    open func addImage(_ image: UIImage?, _ frame: CGRect) -> Self {
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = frame
        self.addSubview(imageView)
        return self
    }
    
    open func addView(_ view: UIView) -> Self {
        self.addSubview(view)
        return self
    }
    
    open func build() -> Self {
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.path = path.cgPath
        maskBgView.layer.mask = shaperLayer
        
        return self
    }
}
