//
//  CollectionViewDataSource.swift
//  VGCLIP
//
//  Created by mac on 2019/9/9.
//  Copyright © 2019 Mojy. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable identifier_name

import Foundation
import RxDataSources

extension String {
    public func toCollectionCell() -> HLCollectionViewCell? {

        if let clsType = self.toClass() as? HLCollectionViewCell.Type {
            return clsType.init()
        }
        return nil
    }
}

class HLCollectioViewDataSource {

    typealias CellEventBlock = (HLCollectionViewCell, IndexPath) -> Void
    static func generateDataSource(style: HLTableViewStyle, eventBlock: CellEventBlock? = nil) -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, HLCellType>> {

        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, HLCellType>>(
            configureCell: { _, collectionView, indexPath, item in
                let identifier = style == .normal ? item.identifier : "\(item.identifier)_\(indexPath.section)_\(indexPath.row)"
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? HLCollectionViewCell ?? item.identifier.toCollectionCell() else {
                    print("Error: 没有注册HLCell(\(item.identifier))")
                    return UICollectionViewCell.init(frame: CGRect.zero)
                }
                if cell.isKind(of: HLCollectionViewCell.self) {
                    cell.data = item.cellData
                    eventBlock?(cell, indexPath)
                } else {
                    print("Not HLCellType")
                }
                return cell
            }, canMoveItemAtIndexPath:  { (datasoure, indexpath) -> Bool in
                return true
            })
    }

    static func generateDataSourceUIWithSection() -> (
        CollectionViewSectionedDataSource<SectionModel<String, HLCellType>>.ConfigureCell,
        CollectionViewSectionedDataSource<SectionModel<String, HLCellType>>.ConfigureSupplementaryView
        ) {
            return ({(ds, cv, ip, item) in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: ip) as? HLCollectionViewCell
                    cell?.data = item.cellData
                    return cell ?? HLCollectionViewCell()
            }, {(ds, cv, kind, ip) in
                    let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip)
                    return section
            })
    }
}
