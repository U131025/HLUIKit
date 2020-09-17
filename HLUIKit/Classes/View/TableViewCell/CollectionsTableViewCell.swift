//
//  CollectionsTableViewCell.swift
//  Apartment
//
//  Created by mac on 2020/6/16.
//  Copyright © 2020 Fd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class HLCollectionsTableViewCell: HLTableViewCell {

    lazy public var listView = HLCollectionView()
    .setFlowLayout(config: {[weak self] () -> (UICollectionViewFlowLayout?) in
        return self?.generateFlowLayout()
    })
    .selectedAction(action: {[weak self] (type) in
        self?.cellEvent.onNext((tag: 0, value: type))
    }).build()

    /// 布局
    open func generateFlowLayout() -> UICollectionViewFlowLayout? {
        return UICollectionViewFlowLayout().then { (layout) in
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }

    override open func initConfig() {
        super.initConfig()

        addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open func bindConfig() {
        super.bindConfig()

        listView.cellEvent.bind(to: event).disposed(by: disposeBag)
    }

    override open func updateData() {

        if let datas = data as? [HLCellType] {
            _ = listView.setItems(datas)
        }
    }
}
