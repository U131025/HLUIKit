//
//  UIButton+Config.swift
//  Community
//
//  Created by mac on 2019/9/25.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension UIButton {

    public func setTitle(_ title: String?, _ state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }

    public func setTitleColor(_ color: UIColor?, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }

    public func setImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }

    public func setBackgroundColor(color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    public func setBackgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }

    public func setFont(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    public func setAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {

        contentHorizontalAlignment = alignment
        return self
    }
}
