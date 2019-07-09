//
//  SCardTileCollectionViewLayout.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public class SCardTileCollectionViewLayout: SCardCollectionViewLayout {

    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0

    private var separatorDevisor: CGFloat = 3.0
    public var translationDivisor: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 4.46
        } else {
            switch UIScreen.main.nativeBounds.height {
            case 1792: // iPhone XR
                return 4.22
            case 2436: // iPhone X, XS
                return 4.24
            case 2688: // iPhone XS Max
                return 4.33
            default:
                return 4.13
            }
        }
    }

    public var currentMotionOffset: UIOffset = UIOffset(horizontal: 0, vertical: 0) {
        didSet { self.invalidateLayout() }
    }

    public override func prepare() {
        super.prepare()

        self.layoutAttributes = [:]
        self.contentHeight = 0

        if let collectionView = self.collectionView {

            let itemDistance =  collectionView.bounds.height / self.separatorDevisor

            for section in 0..<collectionView.numberOfSections {
                let itemCount = collectionView.numberOfItems(inSection: section)
                if itemCount == 0 { continue }

                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    let origin = self.getItemOrigin(at: indexPath)
                    let size = self.getItemSize(at: indexPath)
                    attributes.frame = CGRect(origin: origin, size: size)
                    attributes.transform3D = LayoutUtils.getTransform(translateToX: 0, translateToY: 0, scaleOut: (0.8, 0.8, 0.8), isRotate: true)
                    attributes.zIndex = item

                    self.layoutAttributes[indexPath] = attributes
                    self.contentHeight += itemDistance
                }

                // Extra height
                self.contentHeight += itemDistance
            }
        }
    }

    public override func getItemOrigin(at indexPath: IndexPath) -> CGPoint {
        if let collectionView = self.collectionView {
            let itemDistance = collectionView.bounds.height / separatorDevisor
            return .init(x: 0, y: CGFloat(indexPath.item) * itemDistance)
        }
        return super.getItemOrigin(at: indexPath)
    }

    public override func getItemSize(at indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView {
            return collectionView.bounds.size
        }
        return super.getItemSize(at: indexPath)
    }

    public override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            return CGSize(width: collectionView.frame.size.width, height: self.contentHeight)
        }
        return .zero
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath]
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttributes.values.filter({ rect.intersects($0.frame) })
    }

    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) {
            if self.addingIndexPath == itemIndexPath {
                attributes.transform3D = CATransform3DScale(CATransform3DTranslate(attributes.transform3D, 0, attributes.bounds.height, 0), 0.8, 0.8, 0.8)
            }
            return attributes
        }
        return nil
    }

    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) {
            if self.removingIndexPath == itemIndexPath {
                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, -attributes.bounds.width, 0, 0)
            }
            return attributes
        }
        return nil
    }

    public override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        return attributes
    }
}

internal extension SCardTileCollectionViewLayout {

    func applyMotionEffects(toCollectionView collectionView: UICollectionView) {
        for effect in collectionView.motionEffects where effect is NotifyingMotionEffect {
            collectionView.removeMotionEffect(effect)
        }

        collectionView.addMotionEffect(NotifyingMotionEffect(layout: self))
    }
}

@objc private class NotifyingMotionEffect: UIMotionEffect {

    private weak var layout: SCardTileCollectionViewLayout?
    init(layout: SCardTileCollectionViewLayout) {
        self.layout = layout
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String: Any]? {
        self.layout?.currentMotionOffset = viewerOffset
        return nil
    }
}
