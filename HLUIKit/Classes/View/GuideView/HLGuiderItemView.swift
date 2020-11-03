//
//  GuiderItemView.swift
//  Community
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

open class HLGuiderItemView: HLView {
    
    public let imageView = UIImageView().then { (imageView) in
        imageView.contentMode = .scaleAspectFit
    }
    
    public let titleLabel = UILabel().then { (label) in
        label.font = .pingfang(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .black
    }
    
    public let subTitleLabel = UILabel().then { (label) in
        label.font = .pingfang(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
    }

    open override func initConfig() {
        super.initConfig()
        
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenW - 70*scaleRate)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
            make.top.equalTo(imageView.snp.bottom).offset(75 * scaleRate)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
    }
    
    open func setConfig(_ config: HLGuiderConfig) -> Self {
        imageView.image = config.image
        titleLabel.text = config.title
        subTitleLabel.text = config.subTitle
        
        return self
    }

}
