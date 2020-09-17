//
//  MultiLabelsView.swift
//  Exchange
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

public class HLMultiLabelsView: UIView {

    public let stackView = UIStackView().then { (stackView) in
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
    }

    required convenience init() {
        self.init(frame: CGRect.zero)

        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    public func addLabel(_ config: ((UILabel) -> Void), tag: Int = 0) -> Self {

        let label = UILabel()
        label.tag = tag
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)

        config(label)
        return self
    }

    public func setLabel(_ config: ((UILabel) -> Void), tag: Int) -> Self {

        if let label = stackView.viewWithTag(tag) as? UILabel {
            config(label)
        } else {
            return addLabel(config)
        }

        return self
    }

    public func setStackView(_ config: ((UIStackView) -> Void)) -> Self {
        config(self.stackView)
        return self
    }

    public func addButton(_ config: ((UIButton) -> Void), tag: Int = 0) -> Self {

        let sender = UIButton()
        stackView.addArrangedSubview(sender)
        config(sender)
        return self
    }

    func addEnd() -> Self {
        let label = UILabel()
        label.text = " "
        label.textColor = .clear
        label.backgroundColor = .clear
        stackView.addArrangedSubview(label)
        return self
    }

    public func setButton(_ config: ((UIButton) -> Void), tag: Int) -> Self {

        if let sender = stackView.viewWithTag(tag) as? UIButton {
            config(sender)
        }

        return self
    }

}
