//
//  ConfirmViewController.swift
//  SocialApp
//
//  Created by Олеся on 18.06.2023.
//

import UIKit

class ConfirmViewController: UIViewController {

    private let viewModel: ConfirmControllerViewModel?
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.orange
        return label
    }()

    private let sentInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textRegular
        label.textColor = AppColors.gray
        return label
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = AppColors.darkGray
        return label
    }()

    private let badge: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var phoneNumberField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.delegate = self
        return field
    }()

    private lazy var registrationButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { [unowned self] _ in
                self.checkButtonTapped()
            }
        )
        button.cornerRadius()
        button.setBackgroundImage(.buttonBackgroundImageSelected, for: .normal)
        button.setBackgroundImage(.buttonBackgroundImageNormal, for: .highlighted)
        button.setBackgroundImage(.buttonBackgroundImageNormal, for: .disabled)
        return button
    }()

    private let readyImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var commonConstraints: [NSLayoutConstraint] = []

    init(with viewModel: ConfirmControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setColor()
        setUpTextField()

    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backItemAction)), animated: true)
        phoneNumberField.text = ""
    }

    // MARK: - Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }

    private func addSubviews() {
        [confirmLabel, sentInfoLabel, numberLabel, badge, phoneNumberField, registrationButton, readyImage].forEach({$0.forAutolayout()})
        [confirmLabel, sentInfoLabel, numberLabel, badge, phoneNumberField, registrationButton, readyImage].forEach({$0.placed(on: view)})
    }

    private func configure(){
        [confirmLabel, sentInfoLabel, numberLabel].forEach({$0.textAlignment = viewModel?.centerText ?? .center})
        [confirmLabel, numberLabel].forEach({$0.font = viewModel?.boldFont})
        confirmLabel.text = viewModel?.confirmLabelTitle
        sentInfoLabel.text = viewModel?.pushNumberUserTitle
        numberLabel.text = viewModel?.numberLabelTitle
        badge.text = viewModel?.badgeText
        badge.font = viewModel?.badgeFont
        badge.textColor = viewModel?.lightGray
        registrationButton.setTitle(viewModel?.buttonTitle, for: .normal)
        readyImage.image = viewModel?.readyImage
    }

    private func setUpTextField() {
        phoneNumberField.delegate = self
        phoneNumberField.cornerRadius()
        phoneNumberField.layer.borderWidth = 0.8
        phoneNumberField.layer.borderColor = viewModel?.blackColor.cgColor
        phoneNumberField.keyboardType = .phonePad
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        phoneNumberField.attributedPlaceholder = NSAttributedString(
            string: viewModel?.placeholderString ?? "",
            attributes: [.paragraphStyle: centeredParagraphStyle]
        )
        phoneNumberField.clearButtonMode = .whileEditing
    }

    private func checkButtonTapped() {
        let confirmViewController = MainTabBarController()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setViewControllers([confirmViewController], animated: false)
    }

    @objc private func backItemAction(){
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Constraints

extension ConfirmViewController {
    private func setupConstraints() {
        commonConstraints.append(
            contentsOf: [
                sentInfoLabel.pinTopLessThanOrEqualTo(to: confirmLabel.bottomAnchor, inset: Constants.inset56),
                numberLabel.pinTop(to: sentInfoLabel.bottomAnchor),

                badge.pinLeading(to: phoneNumberField.leadingAnchor),
                badge.pinBottom(to: phoneNumberField.topAnchor),

                confirmLabel.pinTopLessThanOrEqualTo(to: view.topAnchor, inset: Constants.inset8 * 10),
                phoneNumberField.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                registrationButton.pinTopLessThanOrEqualTo(to: phoneNumberField.bottomAnchor, inset: 100),
                registrationButton.pinHeight(equalTo: 44),
                registrationButton.pinLeading(to: phoneNumberField.leadingAnchor),
                registrationButton.pinTrailing(to: phoneNumberField.trailingAnchor),
                readyImage.pinBottom(to: view.bottomAnchor, inset: Constants.inset16),
            ]
        )

        landscapeConstraints.append(
            contentsOf: [
                confirmLabel.pinLeading(to: phoneNumberField.leadingAnchor),
                confirmLabel.pinTrailing(to: view.trailingAnchor, inset: Constants.inset16),

                sentInfoLabel.pinLeading(to: phoneNumberField.leadingAnchor),
                sentInfoLabel.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                phoneNumberField.pinHeight(equalTo: 44),
                phoneNumberField.pinTop(to: numberLabel.bottomAnchor, inset: 24),
                phoneNumberField.pinLeading(to: readyImage.trailingAnchor, inset: Constants.inset16),

                numberLabel.pinLeading(to: readyImage.trailingAnchor, inset: Constants.inset16),
                numberLabel.pinTrailing(to: phoneNumberField.trailingAnchor, inset: Constants.inset16),

                readyImage.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor,inset: Constants.inset16),
                readyImage.pinTop(to: confirmLabel.topAnchor),
                readyImage.pinWidth(equalTo: UIScreen.main.bounds.width / 2),
                registrationButton.pinTopLessThanOrEqualTo(to: phoneNumberField.bottomAnchor, inset: Constants.inset56)
            ]
        )

        portraitConstraints.append(
            contentsOf: [
                confirmLabel.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset16),
                confirmLabel.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                sentInfoLabel.pinTop(to: confirmLabel.bottomAnchor, inset: Constants.inset16),
                sentInfoLabel.pinLeading(to: confirmLabel.leadingAnchor),
                sentInfoLabel.pinTrailing(to: confirmLabel.trailingAnchor),

                numberLabel.pinTop(to: sentInfoLabel.bottomAnchor),
                numberLabel.pinLeading(to: sentInfoLabel.leadingAnchor),

                phoneNumberField.pinHeight(equalTo: Constants.inset56),
                phoneNumberField.pinTop(to: numberLabel.bottomAnchor, inset: Constants.inset56),
                phoneNumberField.pinLeading(to: numberLabel.leadingAnchor, inset: Constants.inset16),
                phoneNumberField.pinTrailing(to: numberLabel.trailingAnchor, inset: Constants.inset16),

                readyImage.pinTop(to: registrationButton.bottomAnchor, inset: 32),
                readyImage.pinLeading(to: registrationButton.leadingAnchor),
                readyImage.pinTrailing(to: registrationButton.trailingAnchor),
                readyImage.pinHeight(equalTo: 200)
            ]
        )

        if Orientation.isLandscape {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
        NSLayoutConstraint.activate(commonConstraints)
    }
}

// MARK: - View Will Transition

extension ConfirmViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { _ in
            if UIDevice.current.orientation.isLandscape {
                NSLayoutConstraint.deactivate(self.portraitConstraints)
                NSLayoutConstraint.activate(self.landscapeConstraints)
            } else {
                NSLayoutConstraint.deactivate(self.landscapeConstraints)
                NSLayoutConstraint.activate(self.portraitConstraints)
            }
        }
    }
}

extension ConfirmViewController: SetThemeColorProtocol {
    func setColor() {
        view.backgroundColor = .backgroundPrimary
        phoneNumberField.backgroundColor = .textFieldColor
        registrationButton.tintColor = .contentColor
    }
}

extension ConfirmViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return  false}
        textField.text = text.applyPatternOnNumbers(pattern: "# # # # # #", replacementCharacter: "#")
        let newLength = text.count
        return newLength <= 10 || string.isEmpty
    }
}
