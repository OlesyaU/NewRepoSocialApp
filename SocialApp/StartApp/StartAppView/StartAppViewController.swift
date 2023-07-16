//
//  StartAppViewController.swift
//  SocialApp
//
//  Created by Олеся on 14.06.2023.
//

import UIKit

class StartAppViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: StartAppControllerViewModel?

    private let startScreenImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { [unowned self] _ in
                self.registerButtonTapped()
            }
        )
        button.setBackgroundImage(.buttonBackgroundImageNormal, for: .normal)
        button.setBackgroundImage(.buttonBackgroundImageSelected, for: .highlighted)
        button.setBackgroundImage(.buttonBackgroundImageSelected, for: .disabled)
        button.cornerRadius()
        return button
    }()

    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { [unowned self] _ in
                self.alreadyHaveAccountButtonTapped()
            }
        )
        return button
    }()

    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var commonConstraints: [NSLayoutConstraint] = []

    // MARK: - Lifecycle
    init(with viewModel: StartAppControllerViewModel){
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

    // MARK: - Helpers

    private func addSubviews() {
        [startScreenImage, registerButton, alreadyHaveAccountButton].forEach({$0.forAutolayout()})
        [startScreenImage, registerButton, alreadyHaveAccountButton].forEach({$0.placed(on: view)})
    }

    private func configure() {
        registerButton.setTitle(viewModel?.registerButtonTitle, for: .normal)
        alreadyHaveAccountButton.setTitle(viewModel?.alreadyButtonTitle, for: .normal)
        startScreenImage.image = viewModel?.startAppImage
    }

    // MARK: - Navigation
    private func alreadyHaveAccountButtonTapped() {
        let model = CombackViewModel()
        let combackViewController = CombackViewController(with: model)
        navigationController?.pushViewController(combackViewController, animated: true)
    }

    private func registerButtonTapped(){
       let model = EnterPhoneNumberViewModel()
       let enterNunberViewController = EnterPhoneNumberViewController(with: model)
        navigationController?.pushViewController(enterNunberViewController, animated: true)
    }
}

// MARK: - Constraints

extension StartAppViewController {
    private func setupConstraints() {
        commonConstraints.append(
            contentsOf: [
                startScreenImage.pinHeight(equalTo: view, multiplier: 0.3),
                startScreenImage.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset16),
                startScreenImage.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                registerButton.pinHeight(equalTo: Constants.inset56),
                registerButton.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset16),
                registerButton.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor, inset: Constants.inset16),

                alreadyHaveAccountButton.pinHeight(equalTo: 44),
                alreadyHaveAccountButton.pinLeading(to: registerButton.leadingAnchor, inset: Constants.inset16),
                alreadyHaveAccountButton.pinTrailing(to: registerButton.trailingAnchor, inset: Constants.inset16)
            ]
        )

        landscapeConstraints.append(
            contentsOf: [
                startScreenImage.pinTop(to: view.safeAreaLayoutGuide.topAnchor, inset: Constants.inset16 * 2),
                registerButton.pinTop(to: startScreenImage.bottomAnchor, inset: Constants.iconHeight24),
                alreadyHaveAccountButton.pinTop(to: registerButton.bottomAnchor, inset: Constants.iconHeight24)
            ]
        )

        portraitConstraints.append(
            contentsOf: [
                startScreenImage.pinTop(to: view.safeAreaLayoutGuide.topAnchor, inset: 100),
                registerButton.pinTop(to: startScreenImage.bottomAnchor, inset: Constants.inset56),
                alreadyHaveAccountButton.pinTop(to: registerButton.bottomAnchor, inset: Constants.inset56)
            ]
        )
        activateOrientationConstraints()
    }

    private func activateOrientationConstraints() {
        if Orientation.isLandscape {
            NSLayoutConstraint.activate(landscapeConstraints)
            NSLayoutConstraint.deactivate(portraitConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
        }
        NSLayoutConstraint.activate(commonConstraints)
    }
}

// MARK: - View Will Transition
extension StartAppViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.activateOrientationConstraints()
        }
    }
}

// MARK: - SetThemeColorProtocol
extension StartAppViewController: SetThemeColorProtocol {
    func setColor() {
        // TODO: - Add theme if need
        view.backgroundColor = .backgroundPrimary
        registerButton.setTitleColor(.contentColor, for: .normal)
        alreadyHaveAccountButton.tintColor = .textPrimary
    }
}
