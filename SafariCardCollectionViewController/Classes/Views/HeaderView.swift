//
//  HeaderView.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public extension SCardCollectionViewCell {
    public class HeaderView: UIView {
        public let closeButton: UIButton
        public let titleLabel: UILabel
        public let blurView: UIVisualEffectView
        public let separator: UIView

        public init() {
            let blurEffect = UIBlurEffect(style: .extraLight)
            blurView = UIVisualEffectView(effect: blurEffect)
            closeButton = UIButton(type: .system)
            titleLabel = UILabel()
            separator = UIView()
            super.init(frame: .zero)

            self.backgroundColor = UIColor.clear

            self.closeButton.setImage(HeaderView.closeImage, for: .normal)
            self.closeButton.tintColor = .darkText
            self.titleLabel.text = ""
            self.titleLabel.textAlignment = .center
            self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.titleLabel.textColor = .darkText
            self.separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

            self.blurView.translatesAutoresizingMaskIntoConstraints = false
            self.closeButton.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.separator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.blurView)
            self.addSubview(self.closeButton)
            self.addSubview(self.titleLabel)
            self.addSubview(self.separator)

            NSLayoutConstraint.activate([
                self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
                self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])

            NSLayoutConstraint.activate([
                self.closeButton.widthAnchor.constraint(equalTo: self.closeButton.heightAnchor),
                self.closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.closeButton.topAnchor.constraint(equalTo: self.topAnchor),
                self.closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])

            NSLayoutConstraint.activate([
                self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])

            NSLayoutConstraint.activate([
                self.separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.separator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.separator.heightAnchor.constraint(equalToConstant: 1)
                ])
        }

        required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        private static var closeImage: UIImage = {
            return UIGraphicsImageRenderer(size: CGSize(width: 12, height: 12)).image(actions: { context in
                let downwards = UIBezierPath()
                downwards.move(to: CGPoint(x: 1, y: 1))
                downwards.addLine(to: CGPoint(x: 11, y: 11))
                UIColor.darkText.setStroke()
                downwards.lineWidth = 2
                downwards.stroke()

                let upwards = UIBezierPath()
                upwards.move(to: CGPoint(x: 1, y: 11))
                upwards.addLine(to: CGPoint(x: 11, y: 1))
                UIColor.darkText.setStroke()
                upwards.lineWidth = 2
                upwards.stroke()

                context.cgContext.addPath(downwards.cgPath)
                context.cgContext.addPath(upwards.cgPath)
            })
        }()
    }
}
