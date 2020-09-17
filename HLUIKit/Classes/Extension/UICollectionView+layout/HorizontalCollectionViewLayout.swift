//
//  HorizontalCollectionViewLayout.swift
//  IM_XMPP
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

open class HorizontalCollectionViewLayout: UICollectionViewFlowLayout {

    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    fileprivate var col: Int = 5
    fileprivate var row: Int = 1

    fileprivate var viewWidth: CGFloat = kScreenW
    fileprivate var viewHeight: CGFloat?

    public init(column: Int, row: Int, width: CGFloat = kScreenW, height: CGFloat? = nil) {
        super.init()
        self.col = column
        self.row = row
        self.viewWidth = width
        self.viewHeight = height
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init()
    }

    override open func invalidateLayout() {
        super.invalidateLayout()
        attributesArr.removeAll()
    }

    // MARK: 重新布局
    override open func prepare() {
        super.prepare()

        let itemW: CGFloat = viewWidth / CGFloat(col)
        var itemH: CGFloat

        if let height = self.viewHeight {
            itemH = height / CGFloat(row)
        } else {
            itemH = itemW
        }

        // 设置itemSize
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal

        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true
        let insertMargin = (collectionView!.bounds.height - CGFloat(row) * itemH) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: insertMargin, left: 0, bottom: insertMargin, right: 0)

        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            page = itemIndex / (col * row)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(col)) + (CGFloat(page) * viewWidth)
            let y = itemSize.height * CGFloat((itemIndex - page * row * col) / col)

            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }

    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }

    override open var collectionViewContentSize: CGSize {

        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        let nbOfScreen: Int = Int(ceil(Double(itemsCount) / Double(col * row)))

        let size: CGSize = super.collectionViewContentSize
        let collectionViewWidth: CGFloat = self.collectionView!.frame.size.width

        let newSize: CGSize = CGSize(width: collectionViewWidth * CGFloat(nbOfScreen)+0.1, height: size.height)

        return newSize
    }

}
