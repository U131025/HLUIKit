//
//  RxBaseView.swift
//  VGCLIP
//
//  Created by mac on 2019/9/10.
//  Copyright © 2019 Mojy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class HLView: UIView {

    public var disposeBag = DisposeBag()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        layer.cornerRadius = 4

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

    open func bindConfig() {
        disposeBag = DisposeBag()

    }
}
