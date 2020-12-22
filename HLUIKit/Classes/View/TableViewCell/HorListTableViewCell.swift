//
//  HorListTableViewCell.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class HorListTableViewCell: HLCollectionsTableViewCell {

    /// 布局
    override open func generateFlowLayout() -> UICollectionViewFlowLayout? {
        return UICollectionViewFlowLayout().then { (layout) in
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 15
        }
    }

    override open func initConfig() {
        super.initConfig()

        listView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: HLTableViewCell.defaultCellMarginValue, bottom: 0, right: HLTableViewCell.defaultCellMarginValue))
        }
    }
}
