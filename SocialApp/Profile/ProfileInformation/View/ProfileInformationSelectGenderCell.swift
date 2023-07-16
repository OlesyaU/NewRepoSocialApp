//
//  ProfileInformationSelectGenderCell.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//
import UIKit

final class ProfileInformationSelectGenderCell: UITableViewCell {
    private enum Constants {
        static let inset: CGFloat = 8
    }

    private let selectGenderLabel = UILabel()
    private let selectMaleButton = UIButton()
    private let selectFemaleButton = UIButton()

    private var viewModel: ProfileInformationSelectGenderViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let views = [
            selectGenderLabel,
            selectMaleButton,
            selectFemaleButton
        ]
        views.forEach { $0.placed(on: contentView) }
        views.forEach { $0.forAutolayout() }

        let constraints: [NSLayoutConstraint] = [
            selectGenderLabel.pinTop(to: contentView, inset: Constants.inset),
            selectGenderLabel.pinLeading(to: contentView, inset: Constants.inset),

            selectMaleButton.pinTop(to: selectGenderLabel.bottomAnchor, inset: Constants.inset),
            selectMaleButton.pinLeading(to: contentView, inset: Constants.inset),

            selectFemaleButton.pinTop(to: selectMaleButton.bottomAnchor, inset: Constants.inset),
            selectFemaleButton.pinLeading(to: contentView, inset: Constants.inset),
            selectFemaleButton.pinBottom(to: contentView, inset: Constants.inset)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(with viewModel: ProfileInformationSelectGenderViewModel) {
        self.viewModel = viewModel
        setupUI()
        updateUI()
        viewModel.viewModelChanged = { [weak self] in
            self?.updateUI()
        }
    }

    private func setupUI() {
        configureLabel()
        configureButtons()
    }

    private func configureLabel() {
        selectGenderLabel.font = UIFont.systemFont(ofSize: 14)
        selectGenderLabel.textColor = .black
        selectGenderLabel.numberOfLines = 1
    }

    private func configureButtons() {
        guard let viewModel else { return }
        selectMaleButton.setTitleColor(.black, for: .normal)
        selectFemaleButton.setTitleColor(.black, for: .normal)

        selectMaleButton.setTitle(viewModel.maleTitle, for: .normal)
        selectFemaleButton.setTitle(viewModel.femaleTitle, for: .normal)
        selectMaleButton.addAction(
            UIAction { [weak self] _ in
            self?.viewModel?.genderSelected(gender: .male)
        }, for: .touchUpInside
        )
        selectFemaleButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel?.genderSelected(gender: .female)
            }, for: .touchUpInside)
    }

    private func updateUI() {
        guard let viewModel else { return }
        selectGenderLabel.text = viewModel.selectGenderTitle
        switch viewModel.selectedGender {
        case .female:
            selectFemaleButton.setImage(viewModel.selectedImage, for: .normal)
            selectMaleButton.setImage(viewModel.unselectedImage, for: .normal)
        case .male:
            selectFemaleButton.setImage(viewModel.unselectedImage, for: .normal)
            selectMaleButton.setImage(viewModel.selectedImage, for: .normal)
        }
    }
}
