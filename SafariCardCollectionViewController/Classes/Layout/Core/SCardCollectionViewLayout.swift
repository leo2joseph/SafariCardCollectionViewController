//
//  SCardCollectionViewLayout.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public typealias ScaleRatio = (x: CGFloat, y: CGFloat, z: CGFloat)

public class SCardCollectionViewLayout: UICollectionViewLayout {

    public weak var delegate: UICollectionViewDelegate?
    public weak var dataSource: UICollectionViewDataSource?

    public var addingIndexPath: IndexPath?
    public var removingIndexPath: IndexPath?

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    public func getItemOrigin(at indexPath: IndexPath) -> CGPoint {
        return .zero
    }

    public func getItemSize(at indexPath: IndexPath) -> CGSize {
        return .zero
    }
}
