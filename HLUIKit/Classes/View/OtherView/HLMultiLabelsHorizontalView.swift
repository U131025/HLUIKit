//
//  MultiLabelsHorizontalView.swift
//  Exchange
//
//  Created by lihaifei on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

public class HLMultiLabelsHorizontalView: HLMultiLabelsView {

    required convenience init() {
        self.init(frame: CGRect.zero)

        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
//        stackView.spacing = 5

        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in

            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
    }

}
