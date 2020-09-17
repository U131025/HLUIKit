//
//  RxIndexStyleTableViewController.swift
//  Community
//
//  Created by mac on 2019/9/21.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MYTableViewIndex

open class RxIndexStyleTableViewController: HLTableViewController {

    /// 索引
    public var tableViewIndexController: TableViewIndexController!
    /// 索引数据源
    public var indexDataSource: ImageIndexDataSource = ImageIndexDataSource()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        initIndexConfig()
    }

    open func initIndexConfig() {
        /// 索引
        tableViewIndexController = TableViewIndexController(scrollView: listView.tableView)
        tableViewIndexController.tableViewIndex.delegate = self

        /// 索引数据源
        tableViewIndexController.tableViewIndex.dataSource = indexDataSource
        tableViewIndexController.tableViewIndex.font = UIFont.pingfang(ofSize: 10)
        tableViewIndexController.tableViewIndex.tintColor = UIColor.black

        tableViewIndexController.layouter = { tableView, tableIndex in
            var frame = tableIndex.frame
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                frame.origin = CGPoint(x: frame.origin.x + 3, y: frame.origin.y)
            } else {
                frame.origin = CGPoint(x: frame.origin.x - 3, y: frame.origin.y)
            }
            tableIndex.frame = frame
        }
    }

}

extension RxIndexStyleTableViewController: TableViewIndexDelegate {

    // MARK: - UIScrollView

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 高亮选中项
        updateHighlightedItems()
    }

    fileprivate func updateHighlightedItems() {
        let frame = uncoveredTableViewFrame()
        var visibleSections = Set<Int>()
        for section in 0..<listView.tableView.numberOfSections {
            if frame.intersects(listView.tableView.rect(forSection: section)) ||
                frame.intersects(listView.tableView.rectForHeader(inSection: section)) {
                visibleSections.insert(section)
                break
            }
        }

        trackSelectedSections(visibleSections)
    }

    func trackSelectedSections(_ sections: Set<Int>) {
        let sortedSections = sections.sorted()

        UIView.animate(withDuration: 0.25, animations: {

            for (index, item) in self.tableViewIndexController.tableViewIndex.items.enumerated() {

                let section = self.mapIndexItemToSection(item, index: index)
                let shouldHighlight = sortedSections.count > 0 && section >= sortedSections.first! && section <= sortedSections.last!

                item.setHightlightStyle(shouldHighlight)
            }
        })
    }

    // MARK: - Helpers
    fileprivate func uncoveredTableViewFrame() -> CGRect {
        return CGRect(x: listView.tableView.bounds.origin.x, y: listView.tableView.bounds.origin.y + topLayoutGuide.length,
                      width: listView.tableView.bounds.width, height: listView.tableView.bounds.height - topLayoutGuide.length)
    }

    // MARK: - TableViewIndex
    public func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {

        let originalOffset = listView.tableView.contentOffset

        let sectionIndex = mapIndexItemToSection(item, index: index)
        if sectionIndex != NSNotFound {

            tableViewIndex.items.forEach { (view) in
                view.setHightlightStyle(false)
            }
            item.setHightlightStyle(true)

            let rowCount = listView.tableView.numberOfRows(inSection: sectionIndex)
            let indexPath = IndexPath(row: rowCount > 0 ? 0 : NSNotFound, section: sectionIndex)
            listView.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        } else {
            listView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }

        return listView.tableView.contentOffset != originalOffset
    }

    ///
    func mapIndexItemToSection(_ indexItem: IndexItem, index: NSInteger) -> Int {
        return index < 0 ? NSNotFound : index
    }
}
