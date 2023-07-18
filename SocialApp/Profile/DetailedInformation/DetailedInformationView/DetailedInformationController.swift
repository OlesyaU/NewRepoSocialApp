//
//  DetailedInformationController.swift
//  SocialApp
//
//  Created by Олеся on 06.07.2023.
//

import UIKit

final class DetailedInformationController: UIViewController {

    private let viewModel: DetailInformationViewModel

    private lazy var tableView = UITableView()
    private lazy var headerView = DetailedInformationHeaderView()

    init(viewModel: DetailInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationController?.setNavigationBarHidden(true, animated: false)

        viewModel.headerViewModel.delegate = self
        headerView.configure(viewModel: viewModel.headerViewModel)
        setupConstraints()
        setTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupConstraints() {
        [headerView, tableView].forEach({$0.forAutolayout()})
        [headerView, tableView].forEach({view.addSubview($0)})
        NSLayoutConstraint.activate([
            headerView.pinTop(to: view.topAnchor),
            headerView.pinLeading(to: view.leadingAnchor),
            headerView.pinTrailing(to: view.trailingAnchor),


            tableView.pinTop(to: headerView.bottomAnchor),
            tableView.pinLeading(to: view.leadingAnchor),
            tableView.pinTrailing(to: view.trailingAnchor),
            tableView.pinBottom(to: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setTableView() {
        tableView.backgroundColor = viewModel.backgroundColor
        tableView.separatorStyle = .none
    }
}

extension DetailedInformationController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.type == .information {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                if viewModel.type == .information {
                    return viewModel.titlesButtonInformationState.count
                } else {
                    return viewModel.titlesButtonSettingsState.count
                }
            case 1:
                return  1
            default:
                break
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                switch viewModel.type {
                    case .settings:
                        let cell = UITableViewCell()
                        cell.imageView?.image = UIImage(systemName: viewModel.iconNamesSettingsState[indexPath.row])
                        cell.textLabel?.text = viewModel.titlesButtonInformationState[indexPath.row]
                        cell.contentView.backgroundColor = viewModel.backgroundColor
                       addGestureToCell(cell: cell)
                        return cell
                    case .information:
                        let cell = UITableViewCell()
                        cell.textLabel?.text = viewModel.titlesButtonInformationState[indexPath.row]
                        cell.contentView.backgroundColor = viewModel.backgroundColor
                        addGestureToCell(cell: cell)
                        return cell
                }
            case 1:
                let cell = UITableViewCell()
                cell.imageView?.image = UIImage(systemName: viewModel.iconNamesSettingsState.last ?? "")
                cell.textLabel?.text = viewModel.titlesButtonSettingsState.last
                cell.contentView.backgroundColor = viewModel.backgroundColor
                return cell
            default:
                return UITableViewCell()
        }

    }
    private func addGestureToCell(cell: UITableViewCell) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(popViewController))
        cell.contentView.addGestureRecognizer(tap)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  tableView.cellForRow(at: indexPath) != nil else {return}
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc private func popViewController() {
        pop()
    }
}

extension DetailedInformationController: DetailedInformationHeaderViewModelDelegate {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
