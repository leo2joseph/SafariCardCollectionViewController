//
//  SCardCollectionViewControllerDataSource.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public protocol SCardCollectionViewControllerDataSource: class {

    func numberOfCardsInCardCollectionViewController() -> Int

    func snapShotForCard(at index: Int) -> UIImage?

    func titleForCard(at index: Int) -> String?

    func indexForActiveCard() -> Int?

    func cardAdded(at index: Int)

    func cardDeleted(at index: Int)

    func cardMoved(from source: Int, to destination: Int)
}
