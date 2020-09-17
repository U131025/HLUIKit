//
//  DefaultTextTableViewCell.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

open class DefaultTextTableViewCell: HLTableViewCell {

    public let leftLabel = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .left
    }

    public let rightLabel = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .right
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func initConfig() {
        super.initConfig()

        backgroundColor = .white

        addSubview(leftLabel)
        addSubview(rightLabel)

        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }

        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
        }
    }

    override open func layoutConfig() {
        super.layoutConfig()

    }

    override open func updateData() {

        if let (title, detail) = data as? (String, String?) {

            leftLabel.text = title
            rightLabel.text = detail

        } else if let (titileConfig, detailConfig) = data as? (TextCellConfig, TextCellConfig?) {

            leftLabel.text = titileConfig.text
            leftLabel.textColor = titileConfig.textColor
            leftLabel.font = titileConfig.font
            leftLabel.sizeToFit()

            let maxWidth = kScreenW - 30 - 80
            var width = leftLabel.width
            if width > maxWidth {
                width = maxWidth
            }

            leftLabel.snp.updateConstraints { (make) in
                make.width.equalTo(leftLabel.width)
            }

            rightLabel.text = detailConfig?.text
            rightLabel.textColor = detailConfig?.textColor
            rightLabel.font = detailConfig?.font

        } else if let config = data as? TextCellConfig {

            leftLabel.text = config.text
            leftLabel.textColor = config.textColor
            leftLabel.font = config.font
        }
    }

}

extension DefaultTextTableViewCell {

    open func showArrow(_ image: UIImage?) {

        accessoryType = .disclosureIndicator
        accessoryView = UIImageView(image: image)

        rightLabel.snp.updateConstraints { (make) in
            make.right.equalTo(-35)
        }

    }

}
