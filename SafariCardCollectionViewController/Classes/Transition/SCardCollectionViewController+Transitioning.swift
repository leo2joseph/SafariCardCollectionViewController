//
//  SCardCollectionViewController+Transitioning.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

extension SCardCollectionViewController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if
            let navigationController = source as? UINavigationController {
            let lastViewController = navigationController.children.last
            if
                let cardCollectionViewController = lastViewController as? SCardCollectionViewController,
                let activatedTabIndex = (lastViewController as? SCardCollectionViewControllerDataSource)?.indexForActiveCard() {
                self.activatedTabIndex = activatedTabIndex
                return PresentingAnimationController(
                    cardCollectionViewController: cardCollectionViewController,
                    activatedTabIndex: activatedTabIndex
                )
            }
        }
        if
            let cardCollectionViewController = source as? SCardCollectionViewController,
            let activatedTabIndex = (cardCollectionViewController as? SCardCollectionViewControllerDataSource)?.indexForActiveCard() {
            self.activatedTabIndex = activatedTabIndex
            return PresentingAnimationController(
                cardCollectionViewController: cardCollectionViewController,
                activatedTabIndex: activatedTabIndex
            )
        }

        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let activatedTabIndex = self.activatedTabIndex
            else { return nil }
        return DismissingAnimationController(activatedTabIndex: activatedTabIndex)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
}
