//
//  MenuCell.swift
//  SocialApp
//
//  Created by Олеся on 22.06.2023.
//

import UIKit

class MenuCell: UITableViewCell {
    private let viewModel = MenuViewViewModel()
    private var constraintsForButton: [NSLayoutConstraint] = []
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doSomething), for: .touchUpInside)
        return button
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func doSomething() {
        print("buttonTapped")
    }

    private func layout() {
        button.forAutolayout()
        contentView.addSubview(button)
        constraintsForButton.append(contentsOf: [
            
            button.pinHeight(equalTo: 44),
            button.pinTop(to: contentView.topAnchor),
            button.pinBottom(to: contentView.bottomAnchor),
            button.pinLeading(to: contentView.leadingAnchor),
        ])
        NSLayoutConstraint.activate(constraintsForButton)
    }

    func conigure(action: String) {
        button.setTitle(action, for: .normal)
        button.setTitleColor(viewModel.colorTitle, for: .normal)
        button.titleLabel?.textAlignment = viewModel.textAlignment
    }
}
