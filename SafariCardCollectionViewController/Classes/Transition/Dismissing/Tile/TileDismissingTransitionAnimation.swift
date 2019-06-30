//
//  TileDismissingTransitionAnimation.swift
//  CSV-Parser
//
//  Created by Son on 6/25/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct TileDismissingTransitionAnimation {
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

        let layout = collectionView.collectionViewLayout as! SCardTileCollectionViewLayout
        let visibleCells = collectionView.visibleCells

        // Start
        let startTranslateToY = collectionView.contentOffset.y - (selectedCell.frame.origin.y - selectedCell.bounds.size.height / layout.translationDivisor)
        let startTransforms = visibleCells.map({ (cell) -> CATransform3D in
            let cellIndexPath = collectionView.indexPath(for: cell)!
            if cellIndexPath.item < activatedTabIndex {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: -collectionView.bounds.height, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            } else if cellIndexPath.item == activatedTabIndex {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: startTranslateToY, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            } else {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: 2.0 * collectionView.bounds.size.height, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            }
        })
        let startCellCornerRadiuses = Array(0..<visibleCells.count).map({ (_) -> CGFloat in return 0 })
        let startToolBarHidden = true
        let startHeaderAlpha = CGFloat(0.0)

        // Final
        let finalTransforms = visibleCells.map({ $0.layer.transform })
        let finalCellCornerRadiuses = visibleCells.map({ $0.layer.cornerRadius })

        // Completed
        let completedToolBarHidden = tabViewController.navigationController?.isToolbarHidden ?? false
        let completedHeaderAlpha = (selectedCell as? SCardCollectionViewCell)?.headerAlpha() ?? 0

        // Animate
        fromView.alpha = 0.0
        toView.alpha = 1.0
        visibleCells.enumerated().forEach({
            $0.element.layer.transform = startTransforms[$0.offset]
            $0.element.layer.cornerRadius = startCellCornerRadiuses[$0.offset]
        })
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
                (selectedCell as? SCardCollectionViewCell)?.setHeaderAlpha(completedHeaderAlpha)
                (selectedCell as? SCardCollectionViewCell)?.layoutIfNeeded()
                tabViewController.navigationController?.setToolbarHidden(completedToolBarHidden, animated: false)

        }, completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)

            // Apply views completed state
            toView.alpha = 1.0
            fromView.alpha = 1.0
        })
    }
}
