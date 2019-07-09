//
//  TilePresentingTransitionAnimation.swift
//  CSV-Parser
//
//  Created by Son on 6/25/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct TilePresentingTransitionAnimation {
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

        let layout = collectionView.collectionViewLayout as! SCardTileCollectionViewLayout
        let visibleCells = collectionView.visibleCells

        // Start

        // Final
        let finalTranslateToY = collectionView.contentOffset.y - (selectedCell.frame.origin.y - selectedCell.bounds.size.height / layout.translationDivisor)
        let finalTransforms = visibleCells.map({ cell -> CATransform3D in
            let cellIndexPaths = collectionView.indexPath(for: cell)!
            if cellIndexPaths.row < activatedTabIndex {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: -collectionView.bounds.height * 1.5, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            } else if cellIndexPaths.row == activatedTabIndex {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: finalTranslateToY, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            } else {
                return LayoutUtils.getTransform(translateToX: 0, translateToY: 2.0 * collectionView.bounds.size.height, scaleOut: (1.0, 1.0, 1.0), isRotate: false)
            }
        })

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
