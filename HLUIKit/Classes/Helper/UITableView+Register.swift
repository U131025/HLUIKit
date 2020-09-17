//
//  UITableView+Register.swift
//  VGCLIP
//
//  Created by mojingyu on 2019/4/16.
//  Copyright © 2019 Mojy. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public func registerCell(cellTypes: [AnyClass]) {
        for cellType in cellTypes {
            let typeString = String(describing: cellType)
            let xibPath = Bundle.init(for: cellType).path(forResource: typeString, ofType: "nib")
            if xibPath == nil {
                self.register(cellType, forCellReuseIdentifier: typeString)
            } else {
                self.register(UINib.init(nibName: typeString, bundle: nil), forCellReuseIdentifier: typeString)
            }
        }
    }
}
