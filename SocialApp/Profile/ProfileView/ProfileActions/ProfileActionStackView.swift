//
//  ProfileActionStackView.swift
//  SocialApp
//
//  Created by Олеся on 27.06.2023.
//

import UIKit

class ProfileActionStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        forAutolayout()
        axis = .horizontal
        distribution = .fillEqually
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(buttonViewModels: [ProfileActionViewModel]) {
        buttonViewModels.forEach { [weak self] model in
            let button = ProfileActionView()
            button.configure(with: model)
            self?.addArrangedSubview(button)
        }
    }
}

