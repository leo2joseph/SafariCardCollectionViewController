//
//  PresentingAnimationController.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public class PresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    public let cardCollectionViewController: SCardCollectionViewController
    public let activatedTabIndex: Int

    public init(cardCollectionViewController: SCardCollectionViewController, activatedTabIndex: Int) {
        self.cardCollectionViewController = cardCollectionViewController
        self.activatedTabIndex = activatedTabIndex
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let collectionView = cardCollectionViewController.collectionView {
            if collectionView.collectionViewLayout is SCardTileCollectionViewLayout {
                _ = TilePresentingTransitionAnimation(
                    duration: self.transitionDuration(using: transitionContext),
                    transitionContext: transitionContext,
                    cardCollectionViewController: self.cardCollectionViewController,
                    activatedTabIndex: self.activatedTabIndex
                )
                return
            }

            if collectionView.collectionViewLayout is SCardGridCollectionViewLayout {
                _ = GridPrensentingTransitionAnimation(
                    duration: self.transitionDuration(using: transitionContext),
                    transitionContext: transitionContext,
                    cardCollectionViewController: self.cardCollectionViewController,
                    activatedTabIndex: self.activatedTabIndex)
                return
            }
        }

        _ = DefaultPresentingTransitionAnimation(
            duration: self.transitionDuration(using: transitionContext),
            transitionContext: transitionContext
        )
    }
}
