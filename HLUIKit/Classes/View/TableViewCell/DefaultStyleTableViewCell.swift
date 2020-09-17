//
//  DefaultStyleTableViewCell.swift
//  Community
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

open class DefaultStyleTableViewCell: HLTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func initConfig() {
        super.initConfig()
        backgroundColor = .white
    }

    override open func updateData() {

        if let (icon, config) = data as? (UIImage?, TextCellConfig) {

            self.tag = config.tag
            self.imageView?.image = icon
            self.textLabel?.text = config.text
            self.textLabel?.textColor = config.textColor
            self.textLabel?.font = config.font
        } else if let config = data as? TextCellConfig {

            self.tag = config.tag
            self.textLabel?.text = config.text
            self.textLabel?.textColor = config.textColor
            self.textLabel?.font = config.font
            self.imageView?.image = config.icon
        }
    }

    public func showArrow(_ image: UIImage? = "next".image) {

        accessoryType = .disclosureIndicator
        accessoryView = UIImageView(image: image)
    }

}
