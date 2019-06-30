//
//  GridDismissingTransitionAnimation.swift
//  CSV-Parser
//
//  Created by Son on 6/25/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct GridDismissingTransitionAnimation {
    public init(
        duration: TimeInterval,
        transitionContext: UIViewControllerContextTransitioning,
        activatedTabIndex: Int
        ) {
        let indexPath = IndexPath(item: activatedTabIndex, section: 0)
        let to = transitionContext.viewController(forKey: .to)
        guard
            let tabViewController = (to as? SCardCollectionViewController) ?? (to as? UINavigationController)?.children.last as? SCardCollectionViewController,
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let selectedCell = tabViewController.collectionView?.cellForItem(at: indexPath),
            let collectionView = tabViewController.collectionView else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        let layout = collectionView.collectionViewLayout as! SCardGridCollectionViewLayout
        let visibleCells = collectionView.visibleCells

        let itemCount = collectionView.numberOfItems(inSection: 0)
        let numberOfItemsPerRow = min(itemCount, layout.maxItemsPerRow)
        let gridIndexPath = IndexPath(item: indexPath.row % numberOfItemsPerRow, section: Int(indexPath.row / numberOfItemsPerRow))

        // Start
        let startTransforms = visibleCells.map { (cell) -> CATransform3D in
            let cellIndexPath = collectionView.indexPath(for: cell)!
            let cellGridIndexPath = IndexPath(item: cellIndexPath.item % numberOfItemsPerRow, section: Int(cellIndexPath.item / numberOfItemsPerRow))

            let center = collectionView.convert(selectedCell.center, to: nil)
            let translateToX = collectionView.bounds.width / 2 + CGFloat(cellGridIndexPath.item - gridIndexPath.item) * collectionView.bounds.width - center.x
            let translateToY = collectionView.bounds.height / 2 + CGFloat(cellGridIndexPath.section - gridIndexPath.section) * collectionView.bounds.height - center.y

            return LayoutUtils.getTransform(translateToX: translateToX, translateToY: translateToY, scaleOut: (1, 1, 1), isRotate: false)
        }
        let startCellCornerRadiuses = Array(0..<visibleCells.count).map({ (_) -> CGFloat in return 0 })
        let startToolBarHidden = true
        let startHeaderAlpha = CGFloat(0.0)

        // Final
        let finalTransforms = visibleCells.map({ $0.layer.transform })
        let finalCellCornerRadiuses = visibleCells.map({ $0.layer.cornerRadius })
        let finalToolBarHidden = tabViewController.navigationController?.isToolbarHidden ?? false
        let finalHeaderAlpha = (selectedCell as? SCardCollectionViewCell)?.headerAlpha() ?? 0

        // Completed

        // Animate
        fromView.alpha = 0.0
        toView.alpha = 1.0
        visibleCells.enumerated().forEach {
            $0.element.layer.transform = startTransforms[$0.offset]
            $0.element.layer.cornerRadius = startCellCornerRadiuses[$0.offset]
        }
        tabViewController.navigationController?.setToolbarHidden(startToolBarHidden, animated: false)
        (selectedCell as? SCardCollectionViewCell)?.setHeaderAlpha(startHeaderAlpha)
        (selectedCell as? SCardCollectionViewCell)?.layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 5.0,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                // Apply final transforms
                visibleCells.enumerated().forEach({
                    $0.element.layer.transform = finalTransforms[$0.offset]
                    $0.element.layer.cornerRadius = finalCellCornerRadiuses[$0.offset]
                })

                // Hide ToolBar
                tabViewController.navigationController?.setToolbarHidden(false, animated: false)

                // Hide Card Cell header
                tabViewController.navigationController?.setToolbarHidden(finalToolBarHidden, animated: false)
                (selectedCell as? SCardCollectionViewCell)?.setHeaderAlpha(finalHeaderAlpha)
                (selectedCell as? SCardCollectionViewCell)?.layoutIfNeeded()

        }, completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)

            // Apply views completed state
            toView.alpha = 1.0
            fromView.alpha = 1.0
        })
    }
}
