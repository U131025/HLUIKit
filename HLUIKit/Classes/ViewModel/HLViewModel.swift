//
//  BaseViewModel.swift
//  Exchange
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift

/// 刷新类型
public enum HLRefreshType {
    case reload
    case loadMore
}
/// ViewModel基类
open class HLViewModel {
    /// 刷新类型
    public var refreshType = HLRefreshType.reload {
        didSet {
            if refreshType == .reload {
                self.page = 1
            } else {
                self.page += 1
            }
        }
    }
    /// 页面和页面大小
    public var page: Int = 1
    public var pageSize: Int = 20

    public var disposeBag = DisposeBag()
    public var disposable: Disposable?

    /// 数据源
    public var items = BehaviorRelay<[SectionModel<String, HLCellType>]>(value: [])

    public weak var viewController: HLViewController?

    /// 初始化
    public init(_ viewController: HLViewController? = nil) {
        self.viewController = viewController

        initConfig()
        bindConfig()
    }

    open func initConfig() {

    }
    
    open func release() {
        disposeBag = DisposeBag()
        self.viewController = nil
    }

    /// 释放
    deinit {
        self.release()
    }

    /// 自定义事件绑定
    public var event: Binder<(tag: Int, value: Any?)> {
        return Binder(self) { base, event in
            base.handleEvent(event: event)
        }
    }
    /// 自定义事件处理
    open func handleEvent(event: (tag: Int, value: Any?)) {

    }

    /// 选中处理
    open func itemSelected(_ type: HLCellType) {

    }    
   
    /// 序列
    open func itemSelected(indexPath: IndexPath) {

    }
    
    open func itemDeselected(type: HLCellType) {

    }
    
    open func itemDeselected(indexPath: IndexPath) {

    }

    /// 刷新
    open func refresh() {
        
        refresh(type: .reload)
        HLTableViewCell.defaultCellMarginValue = 16
    }

    open func refresh(type: HLRefreshType) {
        self.refreshType = type
    }
    
    /// 预加载处理
    public lazy var isLoadFinish: Bool = false {
        didSet {
            if isLoadFinish == true {
                if let vc = viewController as? HLTableViewController {
                    vc.listView.mj_footer?.endRefreshingWithNoMoreData()
                }
                if let vc = viewController as? HLCollectionViewController {
                    vc.listView.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        }
    }
    
    open func preload(indexPath: IndexPath) {
        
    }

    /// 绑定处理
    open func bindConfig() {
        disposeBag = DisposeBag()
    }

    //cell内部控件绑定扩展
    open func cellConfig(_ cell: HLTableViewCell, _ indexPath: IndexPath) {
      
    }
    
    /// cell内部控件绑定扩展
    open func cellControlBindConfig(_ cell: HLCollectionViewCell, _ indexPath: IndexPath) {

    }
    
    open func calculateCellHeight(_ indexPath: IndexPath) -> CGFloat? {
        return nil
    }
}

extension HLViewModel {

    public func setItems(_ datas: [HLCellType]) -> Self {
        items.accept([SectionModel(model: "list", items: datas)])
        return self
    }

    public func setSections(sections: [SectionModel<String, HLCellType>]) -> Self {
        items.accept(sections)
        return self
    }
    
    public func reloadItemsAtIndexPaths(_ ips: [IndexPath]) {
        
        if let vc = viewController as? HLTableViewController {
            
            vc.listView.reloadItemsAtIndexPaths(ips, animationStyle: .none)
        }
    }
}
