//
//  ProfileIconButtonsStackView.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

class ProfileIconButtonsStackView: UIStackView {
 init() {
        super.init(frame: .zero)
        forAutolayout()
        axis = .horizontal
        distribution = .fillEqually
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(buttonViewModels: [ProfileIconButtonViewModel]) {
        buttonViewModels.forEach { [weak self] model in
            let button = ProfileIconButton(viewModel: model)
            self?.addArrangedSubview(button)
        }
    }
}
