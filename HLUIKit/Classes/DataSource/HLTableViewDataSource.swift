//
//  TableViewDataSource.swift
//  VGCLIP
//
//  Created by mojingyu on 2019/4/21.
//  Copyright © 2019 Mojy. All rights reserved.
//
// swiftlint:disable line_length

import Foundation
import RxDataSources

extension String {
    func toCell() -> HLTableViewCell? {
        if let clsType = self.toClass() as? HLTableViewCell.Type {
            return clsType.init(reuseIdentifier: self)
        }
        return nil
    }
}

class HLTableViewDataSource {
    typealias CellEventBlock = (HLTableViewCell, IndexPath) -> Void
    static func generateDataSource(style: HLTableViewStyle, eventBlock: CellEventBlock? = nil) -> RxTableViewSectionedReloadDataSource<SectionModel<String, HLCellType>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<String, HLCellType>>(
            configureCell: { _, tableView, indexPath, item in
                let identifier = style == .normal ? item.identifier : "\(item.identifier)_\(indexPath.section)_\(indexPath.row)"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HLTableViewCell ?? item.identifier.toCell() else {
                    print("Error: 没有注册BaseCell(\(item.identifier))")
                    return UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: item.identifier)
                }
                if cell.isKind(of: HLTableViewCell.self) {
                    cell.data = item.cellData
                    eventBlock?(cell, indexPath)
                } else {
                    print("Not BaseCellType")
                }
                return cell
        },
            canEditRowAtIndexPath: { (_, _) in
                return true
        })
    }
}
