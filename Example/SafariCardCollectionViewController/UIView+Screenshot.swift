//
//  UIView+Screenshot.swift
//  SafariCardCollectionViewController_Example
//
//  Created by Son on 6/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
    func takeScreenshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { (context) in
            self.layer.render(in: context.cgContext)
        }
    }

    func takeSnapshot() -> UIImage {
        _ = snapshotView(afterScreenUpdates: true)
        if let screenshot = self.takeScreenshot() {
            return screenshot
        }
        return UIImage()
    }
}

extension UIViewController {
    func takeSnapshot() -> UIImage {
        return self.view.takeSnapshot()
    }
}
