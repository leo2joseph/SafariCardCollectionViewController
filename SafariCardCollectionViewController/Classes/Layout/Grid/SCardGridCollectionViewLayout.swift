//
//  SCardGridCollectionViewLayout.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public class SCardGridCollectionViewLayout: SCardCollectionViewLayout {
    public let maxItemsPerRow: Int = 3
    public let minSpacingBetweenItems: CGFloat = 35

    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0

    public override func prepare() {
        super.prepare()

        self.layoutAttributes = [:]

        guard let collectionView = collectionView else {
            return
        }

        var currentHeight: CGFloat = 0

        // Subtract spacing on left/right
        let horizontalSpacing = self.minSpacingBetweenItems
        let verticalSpacing = self.minSpacingBetweenItems
        let rowUsableWidth = collectionView.bounds.width - horizontalSpacing
        let maxItemWidth = collectionView.bounds.width * 0.8

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if itemCount == 0 { continue }
            let numberOfItemsPerRow = min(itemCount, maxItemsPerRow)
            let numberOfRows = Int(ceil(Double(itemCount) / Double(numberOfItemsPerRow)))

            let itemWidth = min(rowUsableWidth / CGFloat(numberOfItemsPerRow) - horizontalSpacing, maxItemWidth)
            // Item size should match aspect ratio of collection view's bounds
            let itemHeight = (collectionView.bounds.height / collectionView.bounds.width) * itemWidth

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let itemOrigin = getItemOrigin(at: indexPath)
                let scaleSize = getItemSize(at: indexPath)
                let itemSize = collectionView.bounds.size
                attributes.frame = CGRect(origin: itemOrigin, size: itemSize)
                attributes.transform3D = LayoutUtils.getTransform(
                    translateToX: 0,
                    translateToY: 0,
                    scaleOut: (scaleSize.width / itemSize.width, scaleSize.height / itemSize.height, 1.0),
                    isRotate: false)
                attributes.zIndex = item

                self.layoutAttributes[indexPath] = attributes
            }

            currentHeight += (itemHeight * CGFloat(numberOfRows)) + (verticalSpacing * CGFloat(numberOfRows))
        }

        // Add some spacing onto the end for bottom padding
        self.contentHeight = currentHeight + verticalSpacing
    }

    public override func getItemOrigin(at indexPath: IndexPath) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.getItemOrigin(at: indexPath)
        }

        let horizontalSpacing = self.minSpacingBetweenItems
        let verticalSpacing = self.minSpacingBetweenItems
        let rowUsableWidth = collectionView.bounds.width - horizontalSpacing
        let maxItemWidth = collectionView.bounds.width * 0.8

        let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
        let numberOfItemsPerRow = min(itemCount, self.maxItemsPerRow)
        let itemWidth = min(rowUsableWidth / CGFloat(numberOfItemsPerRow) - horizontalSpacing, maxItemWidth)
        let itemHeight = (collectionView.bounds.height / collectionView.bounds.width) * itemWidth

        let row = Int(ceil(Double(indexPath.item + 1) / Double(numberOfItemsPerRow))) - 1
        let positionInRow = indexPath.item % numberOfItemsPerRow

        let scaleSize = getItemSize(at: indexPath)
        let itemSize = collectionView.bounds.size
        let xPadding =  -itemSize.width / 2 + scaleSize.width / 2
        let yPadding =  -itemSize.height / 2 + scaleSize.height / 2

        let xPosition: CGFloat
        if itemWidth == maxItemWidth {
            // Case where there is one item in section, and it is the max width, it should be centered horizontally.
            xPosition = (collectionView.bounds.width - itemWidth) / 2 + xPadding
        } else {
            // Otherwise (most cases), it should be positionInRow * itemWidth, plus padding
            xPosition = horizontalSpacing + (CGFloat(positionInRow) * itemWidth) + (CGFloat(positionInRow) * horizontalSpacing) + xPadding
        }

        return CGPoint(x: xPosition, y: verticalSpacing + (CGFloat(row) * itemHeight) + (CGFloat(row) * verticalSpacing) + yPadding)
    }

    public override func getItemSize(at indexPath: IndexPath) -> CGSize {
        guard let collectionView = self.collectionView else {
            return super.getItemSize(at: indexPath)
        }

        let horizontalSpacing = self.minSpacingBetweenItems
        let rowUsableWidth = collectionView.bounds.width - horizontalSpacing
        let maxItemWidth = collectionView.bounds.width * 0.8

        let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
        let numberOfItemsPerRow = min(itemCount, self.maxItemsPerRow)
        let itemWidth = min(rowUsableWidth / CGFloat(numberOfItemsPerRow) - horizontalSpacing, maxItemWidth)
        let itemHeight = (collectionView.bounds.height / collectionView.bounds.width) * itemWidth

        return CGSize(width: itemWidth, height: itemHeight)
    }

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.size.width ?? 0, height: self.contentHeight)
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath]
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttributes.values.filter { rect.intersects($0.frame) }
    }
}
