//
//  ListViewModel.swift
//  HLUIKit_Example
//
//  Created by 屋联-神兽 on 2020/9/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import HLUIKit

class ListViewModel: HLViewModel {
    
    override func refresh() {
        var items = [HLCellType]()
        for index in 0..<10 {
            items.append("item_\(index)")
        }
        
        _ = setItems(items)
    }
}
