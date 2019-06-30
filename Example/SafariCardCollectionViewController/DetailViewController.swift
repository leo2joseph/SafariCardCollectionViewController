//
//  DetailViewController.swift
//  SafariCardCollectionViewController_Example
//
//  Created by Son on 6/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var centerLabel: UILabel!

    override var title: String? {
        didSet {
            self.centerLabel?.text = self.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPresent(_:)))
        doneButton.tintColor = UIColor.darkText
        self.navigationItem.setLeftBarButton(doneButton, animated: false)

        self.centerLabel.text = self.title
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: - Actions
    @objc private func dismissPresent(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
