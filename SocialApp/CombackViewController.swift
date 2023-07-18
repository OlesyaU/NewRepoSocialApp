//
//  ConfirmViewController.swift
//  SocialApp
//
//  Created by Олеся on 14.06.2023.
//

import UIKit

protocol ComebackViewModelProtocol {
    func checkUser(by phone: String) -> Profile?
}

final class CombackViewController: UIViewController {

    private var viewModel: CombackViewModel?

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textBold
        label.textColor = AppColors.orange
        label.textAlignment = .center
        label.cornerRadius()
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.cornerRadius()
        return label
    }()

    private lazy var phoneNumberField: UITextField = {
        let field = UITextField().forAutolayout()
        field.cornerRadius()
        field.layer.borderWidth = 0.8
        field.layer.borderColor = AppColors.black.cgColor
        field.keyboardType = .phonePad
        field.textAlignment = TextAttribute.centerText
        field.delegate = self
        field.clearButtonMode = .always
        return field
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { [unowned self] _ in
                self.confirmButtonTapped()
            }
        )
        button.cornerRadius()
        button.setBackgroundImage(.buttonBackgroundImageSelected, for: .normal)
        button.setBackgroundImage(.buttonBackgroundImageNormal, for: .highlighted)
        button.setBackgroundImage(.buttonBackgroundImageNormal, for: .disabled)
        return button
    }()

    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var commonConstraints: [NSLayoutConstraint] = []

    init(with viewModel: CombackViewModel) {
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
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        phoneNumberField.text = ""
    }

    // MARK: - Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }

    private func addSubviews() {
        [welcomeLabel, secondLabel, phoneNumberField, confirmButton].forEach({$0.forAutolayout()})
        [welcomeLabel, secondLabel, phoneNumberField, confirmButton].forEach({$0.placed(on: view)})
    }

    private func configure() {
     welcomeLabel.text = viewModel?.welcomeLabelTitle
        let text = viewModel?.secondLabelTitle ?? ""
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.gray,
            .shadow: shadow
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        secondLabel.attributedText = attributedText
        phoneNumberField.placeholder = viewModel?.placeholderString
        confirmButton.setTitle(viewModel?.buttonTitle, for: .normal)
    }

    private func confirmButtonTapped() {
        guard let phoneNumber = phoneNumberField.text else { return }
        if !phoneNumber.isEmpty, phoneNumber.count == 16, viewModel?.checkUser(by: phoneNumber) != nil {
            pushFeedViewController()
        } else {
            showAleart()
        }
    }
}

// MARK: - Constraints

extension CombackViewController {
    private func setupConstraints() {
        commonConstraints.append(
            contentsOf: [
                welcomeLabel.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset16),
                welcomeLabel.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                phoneNumberField.pinLeading(to: secondLabel.leadingAnchor, inset: Constants.inset16),
                phoneNumberField.pinTrailing(to: secondLabel.trailingAnchor, inset: Constants.inset16),

                secondLabel.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset16),
                secondLabel.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                confirmButton.pinHeight(equalTo: 44),
                confirmButton.pinTopLessThanOrEqualTo(to: phoneNumberField.bottomAnchor, inset: 100),
                confirmButton.pinLeading(to: phoneNumberField.leadingAnchor, inset: Constants.inset16),
                confirmButton.pinTrailing(to: phoneNumberField.trailingAnchor, inset: Constants.inset16)
            ]
        )

        landscapeConstraints.append(
            contentsOf: [
                welcomeLabel.pinTopLessThanOrEqualTo(to: view.topAnchor, inset: 100),

                secondLabel.pinTop(to: welcomeLabel.bottomAnchor, inset: Constants.inset8),

                phoneNumberField.pinHeight(equalTo: 44),
                phoneNumberField.pinTop(to: secondLabel.bottomAnchor, inset: Constants.inset16),

                confirmButton.pinBottom(to: view.bottomAnchor, inset: Constants.iconHeight24)
            ]
        )

        portraitConstraints.append(
            contentsOf: [
                welcomeLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, inset: 100),
                secondLabel.pinTop(to: welcomeLabel.bottomAnchor, inset: Constants.inset8),
                phoneNumberField.pinHeight(equalTo: Constants.inset56),
                phoneNumberField.pinTop(to: secondLabel.bottomAnchor, inset: Constants.iconHeight24)
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

extension CombackViewController {
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

extension CombackViewController: SetThemeColorProtocol {
    func setColor() {
        view.backgroundColor = .backgroundPrimary
        phoneNumberField.backgroundColor = .textFieldColor
        confirmButton.tintColor = .contentColor
    }
}

extension CombackViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.replacingOccurrences(of: "+7", with: "") else {
            return false
        }
        let newText = text.applyPatternOnNumbers(pattern: "### ### ## ##", replacementCharacter: "#")
        textField.text = "+7 \(newText)"

        let newLength = text.count - 3
        return newLength <= 10 || string.isEmpty
    }
}

extension CombackViewController {
    private func showAleart () {
        let aleart = UIAlertController(title: "OOPPPSS", message: "The phone number is incorrect. Please write correctly", preferredStyle: .alert)
        let action = UIAlertAction(title:  "OMG! SURE THING", style: .destructive, handler: { [weak self ] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        aleart.addAction(action)
        present(aleart, animated: true)
    }

    private func pushFeedViewController() {
        let feedViewController = FeedTableViewController()
        navigationController?.pushViewController(feedViewController, animated: true)
    }
}
