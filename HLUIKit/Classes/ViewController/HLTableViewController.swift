//
//  RxBaseTableViewController.swift
//  VGCLIP
//
//  Created by mac on 2019/9/9.
//  Copyright © 2019 Mojy. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

open class HLTableViewController: HLViewController, UITableViewDelegate {

    public var style: HLTableViewStyle = .normal
    public var bounces: Bool = true {
        didSet {
            listView.tableView.bounces = bounces
        }
    }

    fileprivate var itemSelectedBlock: HLItemSelectedBlock?
    fileprivate var itemSelectedIndexPathBlock: HLItemSelectedIndexPathBlock?

    lazy public var listView = HLTableView()
        .setStyle(self.style)
        .setTableViewConfig(config: {(tableView) in
            self.setTableViewConfig(tableView)
        })
        .setCellConfig(config: {(cell, indexPath) in
            self.cellConfig(cell, indexPath)
        })
        .selectedAction(action: {(type) in
            self.itemSelected(type)
        })
        .selectedIndexPathAction(action: {(indexPath) in
            self.itemSelected(indexPath: indexPath)
        })
        .build()

    required public init(style: HLTableViewStyle = .normal) {
        self.style = style
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {

        self.style = .normal
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.listView)
        self.listView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open var viewModel: HLViewModel? {
        didSet {

            if let viewModel = self.viewModel {

                bindConfig()

                _ = cellEvent
                    .takeUntil(self.rx.deallocated)
                    .bind(to: viewModel.event)

                _ = listView.cellEvent
                    .takeUntil(self.rx.deallocated)
                    .bind(to: viewModel.event)

                _ = viewModel.items
                    .takeUntil(self.rx.deallocated)
                    .subscribe(onNext: {[weak self] (sections) in
                        _ = self?.listView.setSections(sections: sections)
                    })

                viewModel.refresh()
            }
        }
    }

    // MARK: 扩展
    /// collectionView 设置扩展
    open func setTableViewConfig(_ tableView: UITableView) {

    }

    /// cell内部控件绑定扩展
    open func cellConfig(_ cell: HLTableViewCell, _ indexPath: IndexPath) {
        self.viewModel?.cellConfig(cell, indexPath)
    }

    /// 选中事件
    open func itemSelected(_ type: HLCellType) {
        self.viewModel?.itemSelected(type)
        self.itemSelectedBlock?(type)
    }

    open func itemSelected(indexPath: IndexPath) {
        self.viewModel?.itemSelected(indexPath: indexPath)
        self.itemSelectedIndexPathBlock?(indexPath)
    }

    /// 无数据界面，需要添加到ViewModel初始化后
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
            make.edges.equalTo(listView)
        }

        guard let viewModel = viewModel else {
            return
        }

        _ = viewModel
            .items
            .takeUntil(self.rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (sections) in

                if sections.count == 0 || (sections.count == 1 && sections[0].items.count == 0) {
                    self?.view.bringSubviewToFront(emptyView)
                } else {
                    self?.view.sendSubviewToBack(emptyView)
                }
            })
    }
}

extension HLTableViewController {

    public func setItems(_ datas: [HLCellType]) -> Self {
        _ = listView.setItems(datas)
        return self
    }

    public func selectedAction(_ block: HLItemSelectedBlock?) -> Self {
        self.itemSelectedBlock = block
        return self
    }

    public func selectedIndexPathAction(_ block: HLItemSelectedIndexPathBlock?) -> Self {
        self.itemSelectedIndexPathBlock = block
        return self
    }
}
