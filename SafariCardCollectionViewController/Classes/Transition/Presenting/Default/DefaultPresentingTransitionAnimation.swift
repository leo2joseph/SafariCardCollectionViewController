//
//  DefaultPresentingTransitionAnimation.swift
//  CSV-Parser
//
//  Created by Son on 6/25/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct DefaultPresentingTransitionAnimation {
    public init(duration: TimeInterval,
                transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        // Start
        let startFromViewAlpha: CGFloat = 1.0
        let startToViewAlpha: CGFloat = 0.0

        // Final
        let finalFromViewAlpha: CGFloat = 0.0
        let finalToViewAlpha: CGFloat = 1.0

        // Completed

        // Animate
        fromView.alpha = startFromViewAlpha
        toView.alpha = startToViewAlpha
        UIView.animate(
            withDuration: duration,
            animations: {
                fromView.alpha = finalFromViewAlpha
                toView.alpha = finalToViewAlpha
        },
            completion: { _ in
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
        })
    }
}
