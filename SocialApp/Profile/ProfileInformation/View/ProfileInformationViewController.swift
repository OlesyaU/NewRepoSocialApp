//
//  ProfileInformationViewController.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//
import UIKit

final class ProfileInformationViewController: UITableViewController {
    let viewModel: ProfileInformationViewModel

    init(viewModel: ProfileInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        registerCells()
    }

    private func configure() {
        tableView.allowsSelection = false
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }

    private func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemOrange

        let rightBarButtonItem = UIBarButtonItem(
            image: viewModel.rightBarItemImage,
            style: .plain,
            target: viewModel,
            action: #selector(viewModel.donePressed)
        )
        rightBarButtonItem.tintColor = .systemOrange
        rightBarButtonItem.width = 30
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
    }

    private func registerCells() {
        tableView.register(EnterDataTextFieldCell.self, forCellReuseIdentifier: EnterDataTextFieldCell.identifier)
        tableView.register(ProfileInformationSelectGenderCell.self, forCellReuseIdentifier: ProfileInformationSelectGenderCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.items.count else { return UITableViewCell()}
        switch viewModel.items[indexPath.row] {
        case let .textField(vm):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnterDataTextFieldCell.identifier) as? EnterDataTextFieldCell else { return UITableViewCell()
            }
            cell.configure(with: vm)
            return cell
        case let .genderPicker(vm):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInformationSelectGenderCell.identifier) as? ProfileInformationSelectGenderCell else { return UITableViewCell() }
            cell.configure(with: vm)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
