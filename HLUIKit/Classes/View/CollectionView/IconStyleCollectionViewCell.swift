//
//  IconStyleCollectionViewCell.swift
//  Apartment
//
//  Created by mac on 2020/6/15.
//  Copyright © 2020 Fd. All rights reserved.
//

import UIKit

public struct IconStyleConfig: HLCellType {
    public var icon: UIImage?
    public var backgroundColor: UIColor = .white
    public var height: CGFloat = 64
    
    public init() {}
    
    public var cellClass: AnyClass { return IconStyleCollectionViewCell.self }
    public var cellHeight: CGFloat { return height }
}

open class IconStyleCollectionViewCell: HLCollectionViewCell {

    public let iconImageView = UIImageView().then { (imageView) in
        imageView.contentMode = .scaleAspectFit
    }

    public let titleLabel = UILabel().then { (label) in
        label.font = .pingfang(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
    }

    open override func initConfig() {
        super.initConfig()

        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 30, right: 10))
            make.edges.equalToSuperview().inset(5)
        }

        titleLabel.isHidden = true
        contentView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { (make) in
//            make.left.right.equalTo(iconImageView)
//            make.top.equalTo(iconImageView.snp.bottom).offset(5)
//            make.bottom.equalTo(-5)
//        }
    }

    open override func updateData() {
        if let config = data as? TextCellConfig {

            iconImageView.image = config.icon
            titleLabel.text = config.text
            titleLabel.textAlignment = config.textAlignment
            titleLabel.textColor = config.textColor ?? .black
            titleLabel.font = config.font ?? .pingfang(ofSize: 15)
            
        } else if let config = data as? IconStyleConfig {
            iconImageView.image = config.icon
            backgroundColor = config.backgroundColor
        }
    }
}
