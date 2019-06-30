//
//  SCardCollectionViewCell.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public protocol SCardCollectionViewCellDelegate: class {
    func cardCollectionViewCellCloseButtonTapped(_ cell: SCardCollectionViewCell)
}

public class SCardCollectionViewCell: UICollectionViewCell {
    private var cornerRadius: CGFloat = 8.0

    public weak var delegate: SCardCollectionViewCellDelegate?

    public var title: String? {
        didSet {
            headerView.titleLabel.text = title
        }
    }
    public var snapshot: UIImage? {
        didSet {
            self.snapshotContainer.image = self.snapshot
        }
    }
    private var isPortrait = true
    private let snapshotContainer: UIImageView
    private let headerView: SCardCollectionViewCell.HeaderView

    public override init(frame: CGRect) {
        headerView = SCardCollectionViewCell.HeaderView()
        snapshotContainer = UIImageView()
        super.init(frame: frame)

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor(white: 0.75, alpha: 1.0).cgColor
        self.contentView.layer.borderWidth = 0.5
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .white
        self.snapshotContainer.contentMode = .scaleAspectFit
        self.snapshotContainer.layer.masksToBounds = true

        let contentView = self.contentView
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.snapshotContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.snapshotContainer)
        contentView.addSubview(self.headerView)

        //gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.4).cgColor, UIColor.init(white: 0, alpha: 0.6).cgColor]
        //gradientLayer.locations = [0, 0.4, 1]
        //self.snapshotContainer.layer.addSublayer(gradientLayer)
        self.contentView.backgroundColor = UIColor.white

        self.headerView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 32)
            ])

        NSLayoutConstraint.activate([
            self.snapshotContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.snapshotContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.snapshotContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.snapshotContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    public func setHeaderAlpha(_ value: CGFloat) {
        self.headerView.alpha = value
    }

    public func headerAlpha() -> CGFloat {
        return self.headerView.alpha
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    @objc private func closeTapped() {
        self.delegate?.cardCollectionViewCellCloseButtonTapped(self)
    }
}
