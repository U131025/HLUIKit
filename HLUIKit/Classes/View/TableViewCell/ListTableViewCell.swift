//
//  ListTableViewCell.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ListTableViewCell: HLTableViewCell {

    public lazy var list = HLTableView()
        .selectedAction(action: {[unowned self] (type) in
            self.cellEvent.onNext((tag: 0, value: type))
        })
        .build()

    override open func initConfig() {
        super.initConfig()

        addSubview(list)
        list.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open func updateData() {

        if let datas = data as? [HLCellType] {
            _ = list.setItems(datas)
        }
    }

    public func setItemInsert(insert: UIEdgeInsets) {

        list.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview().inset(insert)
        }
    }
}

extension ListTableViewCell {

    static public func calculateCellHeight(_ datas: Any?) -> CGFloat {

        if let items = datas as? [HLCellType] {

            let cellHeight = items.map { $0.cellHeight }.reduce(0) { (left, right) -> CGFloat in
                return left + right
            }

            return cellHeight
        }

        return 44
    }
}
