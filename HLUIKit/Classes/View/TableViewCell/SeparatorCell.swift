//
//  SeparatorCell.swift
//  Exchange
//
//  Created by 李海飞 on 2019/8/13.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

public struct HLSeparatorConfig {

    public var backgroundColor: UIColor = .white
    public var color: UIColor = .lightGray
    public var offset: CGFloat = 0
    public var height: CGFloat = 1
    public var width: CGFloat?
    
    public init() {
        
    }
}

open class HLSeparatorCell: HLTableViewCell {

    public var separatorView = UIView().then { (view) in
        view.backgroundColor = UIColor.clear
    }

    override open func initConfig() {
        super.initConfig()
        backgroundColor = .clear
    }

    override open func layoutConfig() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open func updateData() {

        if let color = data as? UIColor {
            separatorView.backgroundColor = color
            backgroundColor = color
        } else if let config = data as? HLSeparatorConfig {
            separatorView.backgroundColor = config.color
            backgroundColor = config.backgroundColor

            separatorView.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.height.equalTo(config.height)

                if let width = config.width {
                    make.width.equalTo(width)
                } else {
                    make.left.equalTo(config.offset)
                    make.right.equalTo(-config.offset)
                }
            }
        }
    }
}
