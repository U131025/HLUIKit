//
//  RxBaseView.swift
//  VGCLIP
//
//  Created by mojingyu on 2019/5/7.
//  Copyright © 2019 Mojy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit
import MJRefresh

public enum HLTableViewStyle {
    case normal
    case form
}

public typealias HLTableViewCellConfigBlock = (HLTableViewCell, IndexPath) -> Void
public typealias HLTableViewViewInSectionConfigBlock = (Int) -> UIView?
public typealias HLTableViewHeightInSectionConfigBlock = (Int) -> CGFloat

public typealias HLTableViewEditingStyleConfigBlock = (IndexPath) -> UITableViewCell.EditingStyle?

open class HLTableView: HLView, UITableViewDelegate {

    var style: HLTableViewStyle = .normal
    var cellEvent = PublishSubject<(tag: Int, value: Any?)>()
    var items = BehaviorRelay<[SectionModel<String, HLCellType>]>(value: [])

    var itemSelectedBlock: HLItemSelectedBlock?
    var itemSelectedIndexPathBlock: HLItemSelectedIndexPathBlock?

    var cellConfigBlock: HLTableViewCellConfigBlock?

    var headerInSectionBlock: HLTableViewViewInSectionConfigBlock?
    var headerHeightInSectionBlock: HLTableViewHeightInSectionConfigBlock?
    var footerInSectionBlock: HLTableViewViewInSectionConfigBlock?
    var footerHeightInSectionBlock: HLTableViewHeightInSectionConfigBlock?

    var editingStyeBlock: HLTableViewEditingStyleConfigBlock?

    lazy public var tableView = UITableView().then({ (tableView) in
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    })

    // MARK: DataSource
    lazy public var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, HLCellType>> = {

        return HLTableViewDataSource.generateDataSource(style: .normal, eventBlock: {[unowned self] (cell, indexPath) in

            self.cellConfigBlock?(cell, indexPath)

            // cell内部事件
            cell.cellEvent
                .subscribe(onNext: {[unowned self] (info) in
                    self.cellEvent.onNext(info)
                }).disposed(by: cell.disposeBag)
        })
    }()

    func refreshHeader(block: CompleteBlock?, config: TextCellConfig? = nil) -> MJRefreshStateHeader {

        let header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in

            if (self?.tableView.mj_footer) != nil {
                self?.tableView.mj_footer?.resetNoMoreData()
            }

            self?.tableView.mj_footer?.resetNoMoreData()
            block?()

        }).then {

            $0.lastUpdatedTimeLabel?.isHidden = true
            $0.stateLabel?.isHidden = false

            $0.stateLabel?.textColor = config?.textColor ?? UIColor.black
            $0.stateLabel?.font = config?.font ?? .pingfang(ofSize: 13)

//            let images = UIImage.getLoadingImages()
//            $0.setImages(images, duration: 1, for: .refreshing)
//            $0.setImages(images, duration: 1, for: .pulling)
        }

        return header
    }

    func loadMoreFooter(block: CompleteBlock?, config: TextCellConfig? = nil) -> MJRefreshAutoFooter {

        return MJRefreshAutoNormalFooter.init(refreshingBlock: {
            block?()
        }).then {

            $0.stateLabel?.textColor = UIColor.black
            $0.stateLabel?.font = config?.font ?? .pingfang(ofSize: 13)
            $0.isRefreshingTitleHidden = false
            $0.isAutomaticallyRefresh = false

//            $0.setTitle(LocalizedString(""), for: .idle)
//            $0.setTitle(LocalizedString("释放即可刷新"), for: .pulling)
//            $0.setTitle(LocalizedString("正在加载更多数据"), for: .refreshing)
//            $0.setTitle(LocalizedString("暂无更多数据"), for: .noMoreData)

        }
    }

    //cell内部控件绑定扩展        
    override open func initConfig() {

        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open func bindConfig() {
        super.bindConfig()

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    /// 缺省事件绑定，晚于initConfig, bindConfig执行
    func initDefaultConfig() {

        _ = items.asObservable()
            .do(onNext: {[unowned self] (_) in
                self.endRefreshing()
            })
            .takeUntil(self.rx.deallocated)
            .bind(to: tableView.rx.items(dataSource: dataSource))

//        _ = tableView.rx
//            .modelSelected(RxBaseCellType.self)
//            .takeUntil(self.rx.deallocated)
//            .subscribe(onNext: {[unowned self] (type) in
//                self.itemSelectedBlock?(type)
//            })
//
        _ = tableView.rx
            .itemSelected
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[unowned self] (indexPath) in

                let type = self.dataSource[indexPath]
                self.itemSelectedBlock?(type)

                self.itemSelectedIndexPathBlock?(indexPath)
            })

    }

    func endRefreshing() {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }

    func reloadData() {
        self.tableView.reloadData()
    }

    /// Cell 高度
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = self.items.value[safe: indexPath.section]?.items[safe: indexPath.row]
        return item?.cellHeight ?? 0
    }

    /// 设置Section Header
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerInSectionBlock?(section)
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeightInSectionBlock?(section) ?? 0.01
    }

    /// Footer
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerInSectionBlock?(section)
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.footerHeightInSectionBlock?(section) ?? 0.01
    }

    // 编辑状态单选多选设置
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.editingStyeBlock?(indexPath) ?? UITableViewCell.EditingStyle.none
    }

}

extension HLTableView {
    /// 样式
    public func setStyle(_ style: HLTableViewStyle) -> Self {
        self.style = style
        return self
    }
    /// Setion Header 设置
    public func setHeaderInSection(config: HLTableViewViewInSectionConfigBlock?) -> Self {
        self.headerInSectionBlock = config

        return self
    }

    public func setHeaderHeightInSection(config: HLTableViewHeightInSectionConfigBlock?) -> Self {
        self.headerHeightInSectionBlock = config
        return self
    }

    /// Footer
    public func setFooterInSection(config: HLTableViewViewInSectionConfigBlock?) -> Self {
        self.footerInSectionBlock = config
        return self
    }

    public func setFooterHeightInSection(config: HLTableViewHeightInSectionConfigBlock?) -> Self {
        self.footerHeightInSectionBlock = config
        return self
    }

    /// TableView 设置
    public func setTableViewConfig(config: ((UITableView) -> Void)) -> Self {
        config(tableView)
        return self
    }

    /// Cell 设置
    public func setCellConfig(config: HLTableViewCellConfigBlock?) -> Self {
        self.cellConfigBlock = config
        return self
    }

    /// 选中事件
    public func selectedAction(action: HLItemSelectedBlock?) -> Self {
        self.itemSelectedBlock = action
        return self
    }

    public func selectedIndexPathAction(action: HLItemSelectedIndexPathBlock?) -> Self {
        self.itemSelectedIndexPathBlock = action
        return self
    }

    /// 设置刷新头部
    public func setRefreshHeader(block: CompleteBlock?, config: TextCellConfig? = nil) -> Self {
        self.tableView.mj_header = refreshHeader(block: block, config: config)
        return self
    }
    // 设置加载更多footer
    public func setLoardMoreFooter(block: CompleteBlock?, config: TextCellConfig? = nil) -> Self {

        self.tableView.mj_footer = loadMoreFooter(block: block, config: config)
        return self
    }

    /// 注：需要创建后才能绑定，否则不会生效
    public func build() -> Self {

        initDefaultConfig()
        return self
    }
}

extension HLTableView {

    public func setItems(_ datas: [HLCellType]) -> Self {
        items.accept([SectionModel(model: "list", items: datas)])
        return self
    }

    public func setSections(sections: [SectionModel<String, HLCellType>]) -> Self {

        items.accept(sections)
        return self
    }

    public func setEditingStye(_ block: HLTableViewEditingStyleConfigBlock?) -> Self {
        editingStyeBlock = block
        return self
    }
}