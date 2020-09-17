//
//  VerAlignmentLabel.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

public enum VerAlignmentType {
    case top
    case center
    case bottom
}

public class VerAlignmentLabel: UIView {

    public let label = UILabel()

    public var font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            label.font = font
        }
    }

    public var text: String? {
        didSet {
            label.text = text
        }
    }

    public var attributedText: NSAttributedString? {
        didSet {
            label.attributedText = attributedText
        }
    }

    public var textColor: UIColor = .black {
        didSet {
            label.textColor = textColor
        }
    }

    public var numberOfLines: Int = 1 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }

    public var textAlignment: NSTextAlignment = .left {
        didSet {
            label.textAlignment = textAlignment
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(text: String?) -> Self {
        self.text = text
        return self
    }

    public func setAttributedText(attrText: NSAttributedString?) -> Self {
        self.attributedText = attrText
        return self
    }

    public func alignment(_ type: VerAlignmentType = .center) {

        layoutIfNeeded()
        let textSize = label.sizeThatFits(bounds.size)

        switch type {
        case .center:
            label.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }

        case .top:

            label.snp.remakeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(textSize.height)
            }

        case .bottom:

            label.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(textSize.height)
            }
        }
    }
}
