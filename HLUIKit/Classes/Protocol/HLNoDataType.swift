//
//  NoDataType.swift
//  Community
//
//  Created by mac on 2019/11/1.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

open class HLNoDataView: HLView {

    public var icon: UIImage? {
        didSet {
            imageView.image = icon
        }
    }

    public var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }

    public let imageView = UIImageView().then({ imageView in
        imageView.contentMode = .scaleAspectFit
    })

    public let messageLabel = UILabel().then({ label in
        label.font = .pingfang(ofSize: 15)
        label.textColor = .systemGray
        label.textAlignment = .center
    })

    override open func initConfig() {
        super.initConfig()

        self.icon = "noData".image
        self.message = "暂无数据".localized

        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(messageLabel.snp.top).offset(25)
            make.width.height.equalTo(kScreenW / 2.0)
        }
    }

    public func setImage(_ image: UIImage?) -> Self {
        self.icon = image
        return self
    }

    public func setMessage(_ string: String) -> Self {
        self.message = string
        return self
    }

}
