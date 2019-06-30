//
//  GridPrensentingTransitionAnimation.swift
//  CSV-Parser
//
//  Created by Son on 6/25/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct GridPrensentingTransitionAnimation {
    public init(
        duration: TimeInterval,
        transitionContext: UIViewControllerContextTransitioning,
        cardCollectionViewController: SCardCollectionViewController,
        activatedTabIndex: Int
        ) {
        let indexPath = IndexPath(item: activatedTabIndex, section: 0)
        let from = transitionContext.viewController(forKey: .from)
        guard
            let fromViewController = (from as? SCardCollectionViewController) ?? (from as? UINavigationController)?.children.last as? SCardCollectionViewController,
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let selectedCell = cardCollectionViewController.collectionView?.cellForItem(at: indexPath),
            let collectionView = cardCollectionViewController.collectionView else {
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
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

        // Final
        let finalTransforms = visibleCells.map { (cell) -> CATransform3D in
            let cellIndexPath = collectionView.indexPath(for: cell)!
            let cellGridIndexPath = IndexPath(item: cellIndexPath.row % numberOfItemsPerRow, section: Int(cellIndexPath.row / numberOfItemsPerRow))

            let center = collectionView.convert(selectedCell.center, to: nil)
            let translateToX = collectionView.bounds.width / 2 + CGFloat(cellGridIndexPath.item - gridIndexPath.item) * collectionView.bounds.width - center.x
            let translateToY = collectionView.bounds.height / 2 + CGFloat(cellGridIndexPath.section - gridIndexPath.section) * collectionView.bounds.height - center.y

            return LayoutUtils.getTransform(translateToX: translateToX, translateToY: translateToY, scaleOut: (1, 1, 1), isRotate: false)
        }

        // Completed
        let completedToolBarHidden = fromViewController.navigationController?.isToolbarHidden ?? false
        let completedHeaderAlpha = (selectedCell as? SCardCollectionViewCell)?.headerAlpha() ?? 0.0
        let completedTransforms = visibleCells.map({ $0.layer.transform })
        let completedCellCornerRadiuses = visibleCells.map({ $0.layer.cornerRadius })

        toView.alpha = 0.0
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 10.0,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                // Apply final transforms
                visibleCells.enumerated().forEach({
                    $0.element.layer.transform = finalTransforms[$0.offset]
                    $0.element.layer.cornerRadius = 0.0
                })

                // Hide ToolBar
                fromViewController.navigationController?.setToolbarHidden(true, animated: false)

                // Hide Card Cell header
                (selectedCell as? SCardCollectionViewCell)?.setHeaderAlpha(0)
                (selectedCell as? SCardCollectionViewCell)?.layoutIfNeeded()
        },
            completion: { _ in
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)

                // Apply views completed state
                toView.alpha = 1.0
                fromView.alpha = 1.0

                // Apply completed transforms
                visibleCells.enumerated().forEach({
                    $0.element.layer.transform = completedTransforms[$0.offset]
                    $0.element.layer.cornerRadius = completedCellCornerRadiuses[$0.offset]
                })

                // Apply tool bar completed state
                fromViewController.navigationController?.setToolbarHidden(completedToolBarHidden, animated: false)

                // Apply Card Cell header completed state
                (selectedCell as? SCardCollectionViewCell)?.setHeaderAlpha(completedHeaderAlpha)
                (selectedCell as? SCardCollectionViewCell)?.layoutIfNeeded()
        })
    }
}
