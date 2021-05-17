//
//  RxBaseCollectionViewCell.swift
//  VGCLIP
//
//  Created by mac on 2019/9/9.
//  Copyright © 2019 Mojy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias HLCollectionViewCellSelectedBlock = (Bool) -> Void

// MARK: CollectionView
open class HLCollectionViewCell: UICollectionViewCell {

    public var disposeBag = DisposeBag()
    public var data: Any? {
        didSet {
            updateData()
        }
    }

    public var event: Binder<(tag: Int, value: Any?)> {
        return Binder(self) { cell, value in
            cell.cellEvent.onNext(value)
        }
    }

    public var cellEvent = PublishSubject<(tag: Int, value: Any?)>()

    public var selectedBlock: HLCollectionViewCellSelectedBlock?

    override public init(frame: CGRect) {
        super.init(frame: frame)

        initConfig()
        layoutConfig()
        bindConfig()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func initConfig() {

    }

    open func layoutConfig() {

    }

    //cell内部事件绑定
    open func bindConfig() {

    }

    /// 缺省的处理
    open func updateData() {

    }

    /// 刷新尺寸
    override open var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }

    /// 选中状态设置
    override open var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            self.selectedBlock?(newValue)
        }
    }
    
    public func setSelectedStatus(config: HLCollectionViewCellSelectedBlock?) {
        selectedBlock = config
    }

}
