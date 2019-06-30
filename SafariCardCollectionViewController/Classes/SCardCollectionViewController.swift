//
//  SCardCollectionViewController.swift
//  CSV-Parser
//
//  Created by Son on 6/22/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

open class SCardCollectionViewController: UICollectionViewController {

    open weak var dataSource: SCardCollectionViewControllerDataSource?
    open weak var delegate: SCardCollectionViewControllerDelegate?

    open var activatedTabIndex: Int?

    public init() {
        let layout = SCardCollectionViewLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        layout.dataSource = self

        self.transitioningDelegate = self
    }

    required public init?(coder: NSCoder) {
        let layout = SCardCollectionViewLayout()
        super.init(coder: coder)

        layout.delegate = self
        layout.dataSource = self

        self.transitioningDelegate = self
    }

    /// Trigger reload data
    open func reloadData() {
        self.collectionView?.reloadData()
    }

    open func addCard(at index: Int) {
        self.dataSource?.cardAdded(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        let layout = self.collectionView?.collectionViewLayout as? SCardCollectionViewLayout
        layout?.addingIndexPath = indexPath
        self.collectionView?.insertItems(at: [indexPath])
        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        layout?.addingIndexPath = nil
    }

    open func removeCard(at index: Int) {
        self.dataSource?.cardDeleted(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        let layout = self.collectionView?.collectionViewLayout as? SCardCollectionViewLayout
        layout?.removingIndexPath = indexPath
        self.collectionView?.deleteItems(at: [indexPath])
        layout?.removingIndexPath = nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = self.collectionView else {
            assertionFailure("Collection view not found in UICollectionViewController")
            return
        }

        // Set up collection view
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SCardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.updateCollectionViewLayout()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.updateCollectionViewLayout()
    }

    private func updateCollectionViewLayout() {
        let layout: SCardCollectionViewLayout
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
                let tiltedLayout = SCardTileCollectionViewLayout()
                tiltedLayout.applyMotionEffects(toCollectionView: self.collectionView!)
                layout = tiltedLayout
            } else {
                layout = SCardGridCollectionViewLayout()
            }
        case .pad:
            layout = SCardGridCollectionViewLayout()
        default:
            return
        }

        layout.delegate = self
        layout.dataSource = self
        self.collectionView?.collectionViewLayout = layout
    }

    // MARK: UICollectionViewDataSource

    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.numberOfCardsInCardCollectionViewController()
    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SCardCollectionViewCell

        // Configure the cell
        cell.delegate = self
        cell.title = self.dataSource?.titleForCard(at: indexPath.item)
        cell.snapshot = self.dataSource?.snapShotForCard(at: indexPath.item)

        return cell
    }

    open override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource?.cardMoved(from: sourceIndexPath.item, to: destinationIndexPath.item)
    }

    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.delegate?.cardSelected(at: indexPath.item)
    }
}

extension SCardCollectionViewController: SCardCollectionViewCellDelegate {
    public func cardCollectionViewCellCloseButtonTapped(_ cell: SCardCollectionViewCell) {
        guard let indexPath = self.collectionView?.indexPath(for: cell)
            else { return }
        removeCard(at: indexPath.item)
    }
}
