//
//  CollectionViewController.swift
//  SafariCardCollectionViewController
//
//  Created by hoangson11592@gmail.com on 06/30/2019.
//  Copyright (c) 2019 hoangson11592@gmail.com. All rights reserved.
//

import UIKit
import SafariCardCollectionViewController

class CollectionViewController: SCardCollectionViewController {

    var controllers: [UIViewController]!
    var activedViewController: UIViewController?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
        initLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activedViewController = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        /// A short delay is required to let UINavigationViewController prepare for reloading
        /// I really don't know why the navigation not reload before reloading snapshot 🤣
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.updateChildrenLayouts(to: size)
        }
    }

    // MARK: - Common Initiation
    private func initData() {
        self.controllers = []
        self.dataSource = self
        self.delegate = self
    }

    private func initLayout() {
        // Set up navigation bar
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barStyle = .blackTranslucent

        // Set up tool bar
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTab)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        // Custom collection view
        self.collectionView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: navigationController?.toolbar.frame.height ?? 0, right: 0)

        // Create default workspace
        self.addDefaultWorkspace()
    }

    @objc private func addNewTab() {
        self.addCard(at: self.controllers.count)
    }
}

// MARK: - Default Workspace

extension CollectionViewController {
    func addDefaultWorkspace() {
        let workspaceViewController = self.detailViewController()
        let navigationController = UINavigationController(rootViewController: workspaceViewController)
        workspaceViewController.title = "Detail 0"
        navigationController.view.setNeedsLayout()
        self.controllers.append(navigationController)
    }
}

extension CollectionViewController: SCardCollectionViewControllerDataSource {

    func numberOfCardsInCardCollectionViewController() -> Int {
        return self.controllers.count
    }

    func snapShotForCard(at index: Int) -> UIImage? {
        return self.controllers[index].view.takeSnapshot()
    }

    func titleForCard(at index: Int) -> String? {
        return self.controllers[index].title
    }

    func indexForActiveCard() -> Int? {
        return self.activatedTabIndex
    }

    func cardAdded(at index: Int) {
        let viewController = self.detailViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.title = "Detail \(index)"
        navigationController.view.setNeedsLayout()
        self.controllers.insert(navigationController, at: index)
    }

    func cardDeleted(at index: Int) {
        self.controllers.remove(at: index)
    }

    func cardMoved(from source: Int, to destination: Int) {
        let controller = self.controllers.remove(at: source)
        self.controllers.insert(controller, at: destination)
    }
}

extension CollectionViewController: SCardCollectionViewControllerDelegate {
    func cardSelected(at index: Int) {
        let controller = self.controllers[index]
        controller.modalPresentationStyle = .fullScreen
        controller.transitioningDelegate = self
        self.activatedTabIndex = index
        self.navigationController?.transitioningDelegate = self
        self.navigationController?.present(controller, animated: true, completion: nil)
        self.activedViewController = controller
    }
}

// MARK: Update Chilren Layouts

extension CollectionViewController {
    func updateChildrenLayouts(to size: CGSize) {
        self.controllers
            .enumerated()
            .filter({
                $0.element !== self.activedViewController
            })
            .forEach({
                $0.element.view.frame.size = size
                $0.element.view.setNeedsLayout()
                _ =  $0.element.view.snapshotView(afterScreenUpdates: true)
            })

        self.collectionView.reloadData()
    }
}

// MARK: - Builder

extension CollectionViewController {
    func detailViewController() -> DetailViewController {
        return DetailViewController(nibName: "DetailViewController", bundle: Bundle(for: DetailViewController.self))
    }
}
