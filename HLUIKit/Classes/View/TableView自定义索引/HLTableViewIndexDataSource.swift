//
//  TableViewIndexDataSource.swift
//  Exchange
//
//  Created by mac on 2019/8/28.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import MYTableViewIndex

extension UIView {

    public func setHightlightStyle(_ shouldHighlight: Bool) {
        layer.cornerRadius = frame.height / 2
        tintColor = shouldHighlight ? UIColor.white : UIColor.black
        backgroundColor = shouldHighlight ? UIColor.systemGray : UIColor.clear
    }
}

public class StringItemEx: StringItem {

    override init(text: String) {
        super.init(text: text)
        textAlignment = .center
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        let maxValue = fmax(size.width, size.height) + 6
        return CGSize(width: maxValue, height: maxValue)
    }
}

open class ImageIndexDataSource: NSObject, TableViewIndexDataSource {

//    fileprivate let collaction = UILocalizedIndexedCollation.current()
    public var titles = [String]()

    open func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {

        let items = titles.map { title -> UIView in
            return StringItemEx(text: title)
        }

        return items
    }
}
