//
//File name:     AttrStringTextCell.swift
//Author:        Mojy
//
//Description:   富文本TableViewCell
//
//History:  2019/5/8: File created.
// swiftlint:disable line_length

import UIKit

open class HLAttrStringTextCell: HLTableViewCell {
    public var label = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.numberOfLines = 0
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override open func initConfig() {
        super.initConfig()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(HLTableViewCell.defaultCellMarginValue)
            make.right.equalTo(-HLTableViewCell.defaultCellMarginValue)
            make.top.bottom.equalToSuperview()
        }
    }
    override open func updateData() {
        super.updateData()

        if let (attrStr, fontSize) = data as? (NSAttributedString, CGFloat) {
            label.attributedText = attrStr
            label.font = UIFont.systemFont(ofSize: fontSize)
        } else if let config = data as? TextCellConfig {
            if let attributedText = config.attributedText {
                label.attributedText = attributedText
            } else {
                label.text = config.text
            }
            if let color = config.textColor { label.textColor = color }
            if let font = config.font { label.font = font }

            tag = config.tag
            label.textAlignment = config.textAlignment
            
            if let bgColor = config.backgroundColor {
                backgroundColor = bgColor
            }            
            
        } else if let text = data as? String {
            label.text = text
        } else if let attrStr = data as? NSAttributedString {
            label.attributedText = attrStr
        }
    }

}

extension HLAttrStringTextCell {
    static public func calculateCellHeight(_ data: Any?, _ maxWidth: CGFloat = kScreenW - HLTableViewCell.defaultCellMarginValue*2, minHeight: CGFloat = 44, margin: CGFloat = 0) -> CGFloat {
        if let attrStr = data as? NSAttributedString {
            return calculateAttrStringHeight(attrStr, maxWidth, minHeight: minHeight, margin: margin)
        } else if let config = data as? TextCellConfig {
            if let attrStr = config.attributedText {
                return calculateAttrStringHeight(attrStr, maxWidth, minHeight: minHeight, margin: margin)
            }
            return config.calculateTextHeight(maxWidth) + margin
        }
        return minHeight
    }

    static public func calculateAttrStringHeight(_ attrStr: NSAttributedString, _ maxWidth: CGFloat = kScreenW - HLTableViewCell.defaultCellMarginValue*2, minHeight: CGFloat = 44, margin: CGFloat = 0) -> CGFloat {
        let font: UIFont = attrStr.font ?? .pingfang(ofSize: 15)
        let size = (attrStr.string as NSString).boundingRect(with: CGSize(width: Int(maxWidth), height: Int.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let hieght = size.height + margin
        return hieght < minHeight ? minHeight : hieght
    }
}
