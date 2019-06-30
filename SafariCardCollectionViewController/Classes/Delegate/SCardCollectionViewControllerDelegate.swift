//
//  SCardCollectionViewControllerDelegate.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public protocol SCardCollectionViewControllerDelegate: class {

    func cardSelected(at index: Int)
}
