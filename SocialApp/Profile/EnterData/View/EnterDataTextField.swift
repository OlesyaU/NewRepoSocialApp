//
//  EnterDataTextField.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit

final class EnterDataTextField: UIView {

    private var viewModel: EnterDataTextFieldViewModel?

    private lazy var typeTitleLabel = UILabel()
    private lazy var dataTextField = UITextField()
    private lazy var textFieldContainer = UIView()
    private let datePicker = UIDatePicker()

    private var enterDataTextFieldConstraints: [NSLayoutConstraint] = []

    init() {
        super.init(frame: .zero)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        [typeTitleLabel, textFieldContainer].forEach { $0.placed(on: self) }
        dataTextField.placed(on: textFieldContainer)
        [typeTitleLabel, dataTextField, textFieldContainer].forEach { $0.forAutolayout() }
        if case .birthDate = viewModel?.type {
            createDatePicker()
        }

        enterDataTextFieldConstraints.append(contentsOf: [
            typeTitleLabel.pinTop(to: self, inset: Constants.inset8),
            typeTitleLabel.pinLeading(to: self, inset: Constants.inset8),

            textFieldContainer.pinTop(to: typeTitleLabel.bottomAnchor, inset: Constants.inset4),
            textFieldContainer.pinLeading(to: typeTitleLabel),
            textFieldContainer.pinTrailing(to: self, inset: Constants.inset8),
            textFieldContainer.pinHeight(equalTo: 40),
            textFieldContainer.pinBottom(to: self, inset: Constants.inset8),

            dataTextField.pinTop(to: textFieldContainer, inset: Constants.inset4),
            dataTextField.pinBottom(to: textFieldContainer, inset: Constants.inset4),
            dataTextField.pinLeading(to: textFieldContainer, inset: 16),
            dataTextField.pinTrailing(to: textFieldContainer, inset: Constants.inset4)
        ])
        NSLayoutConstraint.activate(enterDataTextFieldConstraints)
    }

    func setup(with viewModel: EnterDataTextFieldViewModel) {
        self.viewModel = viewModel
        viewModel.viewModelChanged = { [weak self] in
            self?.updateUI()
        }
        setupUI()
        updateUI()
    }

    func prepareForReuse() {
        dataTextField.inputView = nil
    }

    private func updateUI() {
        dataTextField.text = viewModel?.enteredData
    }

    private func setupUI() {
        textFieldContainer.backgroundColor = viewModel?.backgroundTextFieldColor
        textFieldContainer.layer.cornerRadius = 4
        textFieldContainer.clipsToBounds = true

        configureLabel()
        configureTextField()
        if case .birthDate = viewModel?.type {
            createDatePicker()
        }
    }

    private func configureLabel() {
        typeTitleLabel.font = UIFont.systemFont(ofSize: 14)
        typeTitleLabel.numberOfLines = 1
        typeTitleLabel.textColor = .black
        typeTitleLabel.text = viewModel?.typeName
    }

    private func configureTextField() {
        let dataPlaceholderString = NSAttributedString(
            string: viewModel?.typePlaceholder ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
        )
        dataTextField.delegate = self
        dataTextField.attributedPlaceholder = dataPlaceholderString
        dataTextField.returnKeyType = .done
    }

    private func createDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .plain,
            target: self,
            action: #selector(pickerDonePressed)
        )
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        var dateComponents = DateComponents()
        dateComponents.year = 1900
        dateComponents.month = 1
        dateComponents.day = 1
        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        datePicker.minimumDate = Calendar.current.date(from: dateComponents)
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        toolbar.setItems([emptySpace, doneButton], animated: false)

        dataTextField.inputAccessoryView = toolbar
        dataTextField.inputView = datePicker
    }

    @objc
    private func pickerDonePressed() {
        viewModel?.date = datePicker.date
        dataTextField.resignFirstResponder()
    }

    @objc
    private func dateChanged() {
        viewModel?.date = datePicker.date
    }
}

extension EnterDataTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.enteredData = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel?.enteredData = textField.text ?? ""
        return true
    }
}
