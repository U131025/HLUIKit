//
//  RxBaseCollectionViewController.swift
//  VGCLIP
//
//  Created by mac on 2019/9/9.
//  Copyright © 2019 Mojy. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

open class HLCollectionViewController: HLViewController {

    lazy public var listView = HLCollectionView()
        .setFlowLayout(config: {[unowned self] () -> (UICollectionViewFlowLayout?) in
            return self.generateFlowLayout()
        })
        .setCollectionViewConfig(config: {[unowned self] (collectionView) in
            self.setCollectionViewConfig(collectionView)
        })
        .setCellConfig(config: {[unowned self] (cell) in
            self.cellControlBindConfig(cell)
        })
        .selectedAction(action: {[unowned self] (type) in
            self.itemSelected(type)
        })
        .build()

    /// 布局
    open func generateFlowLayout() -> UICollectionViewFlowLayout? {
        return nil
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open var viewModel: HLViewModel? {
        didSet {
            if let viewModel = viewModel {

                _ = cellEvent
                    .takeUntil(self.rx.deallocated)
                    .bind(to: viewModel.event)

                _ = listView.cellEvent
                    .takeUntil(self.rx.deallocated)
                    .bind(to: viewModel.event)

                _ = viewModel.items
                    .takeUntil(self.rx.deallocated)
                    .subscribe(onNext: {[unowned self] (sections) in
                        _ = self.listView.setSections(sections: sections)
                    })

                viewModel.refresh()
            }
        }
    }

    // MARK: 扩展
    /// collectionView 设置扩展
    open func setCollectionViewConfig(_ collectionView: UICollectionView) {

    }

    /// cell内部控件绑定扩展
    open func cellControlBindConfig(_ cell: HLCollectionViewCell) {

    }

    /// 选中事件
    open func itemSelected(_ type: HLCellType) {
        self.viewModel?.itemSelected(type)
        print("==== \(type)")
    }

    override open func reloadData() {

        DispatchQueue.main.async { [weak self] in
            self?.listView.collectionView.reloadData()
        }
    }

    /// 无数据界面
    open var noDataView: UIView? {
        didSet {
            initNoDataView()
        }
    }

    public func setNoDataView(_ view: UIView?) -> Self {
        self.noDataView = view
        return self
    }

    open func initNoDataView() {

        noDataView?.removeFromSuperview()
        guard let emptyView = noDataView else { return }

        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        guard let viewModel = viewModel else { return }

        _ = viewModel
            .items
            .takeUntil(self.rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (sections) in

                if sections.count == 0 || (sections.count == 1 && sections[0].items.count == 0) {
                    self.view.bringSubviewToFront(emptyView)
                } else {
                    self.view.sendSubviewToBack(emptyView)
                }
            })
    }
}

extension HLCollectionViewController {

    public func setItems(_ datas: [HLCellType]) -> Self {
        _ = listView.setItems(datas)
        return self
    }
}
