//
//  ButtonStyleTableViewCell.swift
//  JingPeng
//
//  Created by 屋联-神兽 on 2020/10/15.
//

import UIKit

public struct ButtonCellConfig {
    public var title: String?
    public var titleColor: UIColor = .white
    public var backgroundColor: UIColor?
    public var backgroundImage: UIImage?
    public var cornerRate: CGFloat?
    public var icon: UIImage?
    public var iconLayoutType: UPButtonEdgeInsetsStyle = .left
    
    public var font: UIFont = .pingfang(ofSize: 15)
    public var borderColor: UIColor = .clear
    public var tag: Int = 0
    
    public var height: CGFloat = 45
    
    public init() {
    }
}

extension ButtonCellConfig: HLCellType {
    public var cellClass: AnyClass {
        return ButtonStyleTableViewCell.self
    }
    
    public var cellHeight: CGFloat {
        return height
    }
}

open class ButtonStyleTableViewCell: HLTableViewCell {
    
    public var marginValue: CGFloat = 30 {
        didSet {
            commitButton.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.left.equalTo(marginValue)
                make.right.equalTo(-marginValue)
                make.height.equalTo(44)
            }
        }
    }

    public let commitButton = UIButton().then { (button) in
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
    }

    open override func initConfig() {
        super.initConfig()

        backgroundColor = .clear

        contentView.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(marginValue)
            make.right.equalTo(-marginValue)
            make.height.equalTo(44)
        }
    }

    open override func updateData() {

        if let config = data as? ButtonCellConfig {

            tag = config.tag

            if let color = config.backgroundColor {
                _ = commitButton.setBackgroundImage(color.image, .normal)
            }

            _ = commitButton
                .setTitle(config.title)
                .setTitleColor(config.titleColor)
                .setFont(config.font)

            if let image = config.icon {
                commitButton.frame = CGRect(origin: .zero, size: CGSize(width: kScreenW - HLTableViewCell.defaultCellMarginValue*2, height: 44))
                commitButton.setImage(image).layoutButton(with: config.iconLayoutType, imageTitleSpace: 10)
            } else {
                commitButton.setImage(nil).layoutButton(with: config.iconLayoutType, imageTitleSpace: 10)
            }
            
            if let bgImage = config.backgroundImage {
                _ = commitButton.setBackgroundImage(bgImage)
            }
            
            if let corner = config.cornerRate {
                commitButton.layer.cornerRadius = corner
                commitButton.layer.masksToBounds = true
            }

            commitButton.layer.borderColor = config.borderColor.cgColor
            commitButton.layer.borderWidth = 1
        }
    }

    open override func bindConfig() {
        super.bindConfig()

        commitButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            self.cellEvent.onNext((tag: self.tag, value: self.data))
        }).disposed(by: disposeBag)
    }
}
