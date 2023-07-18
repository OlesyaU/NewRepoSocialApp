//
//  DotsContainerView.swift
//  SocialApp
//
//  Created by Олеся on 03.07.2023.
//

import UIKit

final class DotsContainerView: UIView {

    private var constraintsView: [NSLayoutConstraint] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.forAutolayout()
    backgroundColor = .red
    alpha = 0.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout(to view: UIView) {
        constraintsView.append(contentsOf: [
            self.pinTop(to: view.topAnchor),
            self.pinBottom(to: view.bottomAnchor),
            self.pinLeading(to: view.leadingAnchor),
            self.pinTrailing(to: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate(constraintsView)
    }
}
