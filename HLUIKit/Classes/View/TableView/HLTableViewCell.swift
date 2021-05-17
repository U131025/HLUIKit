//
//  BaseTableViewCell.swift
//  Exchange
//
//  Created by mac on 2018/12/24.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias HLTableViewCellSelectedBlock = (Bool) -> Void
public typealias HLTableViewCellActionBlock = (HLCellType) -> Void

open class HLTableViewCell: UITableViewCell {
    
    public static var defaultCellMarginValue: CGFloat = 30

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

    public var selectedBlock: HLTableViewCellSelectedBlock?

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

        initConfig()
        layoutConfig()
        bindConfig()
    }

    required convenience public init(reuseIdentifier: String?) {
        self.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        if #available(iOS 14.0, *) {
            self.backgroundConfiguration = UIBackgroundConfiguration.clear()
        } else {
            // Fallback on earlier versions
        }

        initConfig()
        layoutConfig()
        bindConfig()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
        bindConfig()
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
        if let data = data as? String {
            self.textLabel?.text = data
        }
    }

    /// 选中状态设置
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBlock?(selected)
    }

    open func setSelectedStatus(config: HLTableViewCellSelectedBlock?) {
        selectedBlock = config
    }
}
