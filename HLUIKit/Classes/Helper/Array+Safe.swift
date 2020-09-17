//
//  Array+Safe.swift
//  Exchange
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        if index < 0 { return nil }
        return index < count ? self[index] : nil
    }
}
