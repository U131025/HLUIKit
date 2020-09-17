//
//  GuiderView.swift
//  Community
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxGesture
import RxCocoa
import RxSwift
import SnapKit
import SDCycleScrollView

public struct GuiderConfig {
    public var image: UIImage?
    public var title: String?
    public var subTitle: String?
}

public class GuiderView: HLPopView {
    
    public static let shared = GuiderView(identify: "GuiderView")

    public let scrollView = UIScrollView().then { (scrollView) in
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    public let pageCtrl = TAPageControl()
//        .then { (pageCtrl) in
//
//        let dotGray = UIColor(hex: "D8D8D8")?.image.reSizeImage(reSize: CGSize(width: 11, height: 4)).byRoundCornerRadius(2)
//
//        let dot = UIColor(hex: "3378FD").image.reSizeImage(reSize: CGSize(width: 11, height: 4)).byRoundCornerRadius(2)
//
//        pageCtrl.dotImage = dotGray
//        pageCtrl.currentDotImage = dot
//    }
    
    open override func initConfig() {
        super.initConfig()
        
        self.backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addSubview(pageCtrl)

        pageCtrl.currentPage = 0
        pageCtrl.numberOfPages = scrollView.subviews.count
        pageCtrl.sizeToFit()
        
        pageCtrl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(pageCtrl.width)
            make.height.equalTo(pageCtrl.height)
            make.bottom.equalTo(-123*scaleRate)
        }
    }
    
    open func addGuideView(config: GuiderConfig, isEnd: Bool = false) -> Self {
        
        let view = HLGuiderItemView().setConfig(config)
        
        let count = scrollView.subviews.count
        
        scrollView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(CGFloat(count) * kScreenW)
            make.height.equalTo(kScreenH)
            make.width.equalTo(kScreenW)
            make.top.bottom.equalToSuperview()
            
            if isEnd {
                make.right.equalToSuperview()
            }
        }

        pageCtrl.numberOfPages = scrollView.subviews.count
        pageCtrl.sizeToFit()

        pageCtrl.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(pageCtrl.width)
            make.height.equalTo(pageCtrl.height)
            make.bottom.equalTo(-123*scaleRate)
        }

        return self
    }
    
    open override func bindConfig() {
        super.bindConfig()
        
        scrollView.rx.contentOffset.filter { $0.x > 0 }
            .subscribe(onNext: {[unowned self] (pt) in
                
                let index = Int(pt.x / kScreenW)
                if index >= 0 && index < self.scrollView.subviews.count {
                    self.pageCtrl.currentPage = index
                }
                
                /// 结束
                if pt.x + kScreenW > self.scrollView.contentSize.width {
                    self.hide()
                }
            
            }).disposed(by: disposeBag)
    }
}
