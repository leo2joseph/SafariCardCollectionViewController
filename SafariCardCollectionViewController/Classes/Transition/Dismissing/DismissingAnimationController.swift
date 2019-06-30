//
//  DismissingAnimationController.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public class DismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    public let activatedTabIndex: Int

    public init(activatedTabIndex: Int) {
        self.activatedTabIndex = activatedTabIndex
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to = transitionContext.viewController(forKey: .to)
        if
            let tabViewController = (to as? SCardCollectionViewController) ?? (to as? UINavigationController)?.children.last as? SCardCollectionViewController,
            let collectionView = tabViewController.collectionView {

            self.updateBackViewLayout(using: transitionContext)

            if collectionView.collectionViewLayout is SCardTileCollectionViewLayout {
                _ = TileDismissingTransitionAnimation(
                    duration: self.transitionDuration(using: transitionContext),
                    transitionContext: transitionContext,
                    activatedTabIndex: self.activatedTabIndex
                )
                return
            }

            if collectionView.collectionViewLayout is SCardGridCollectionViewLayout {
                _ = GridDismissingTransitionAnimation(
                    duration: self.transitionDuration(using: transitionContext),
                    transitionContext: transitionContext,
                    activatedTabIndex: self.activatedTabIndex
                )
                return
            }
        }

        _ = DefaultDismissingTransitionAnimation(
            duration: self.transitionDuration(using: transitionContext),
            transitionContext: transitionContext
        )
    }

    private func updateBackViewLayout(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!

        toView.frame = fromView.frame
        toView.setNeedsLayout()
        toView.layoutIfNeeded()

        let to = transitionContext.viewController(forKey: .to)
        ((to as? UINavigationController)?.children.last as? SCardCollectionViewController)?.collectionViewLayout.prepare()
        (to as? SCardCollectionViewController)?.collectionViewLayout.prepare()
    }
}
