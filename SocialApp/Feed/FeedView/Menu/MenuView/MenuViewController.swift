//
//  MenuViewController.swift
//  SocialApp
//
//  Created by Олеся on 22.06.2023.
//

import UIKit

class MenuViewController: UIViewController {
    private let viewModel = MenuViewViewModel()
    private var constraintsForTableView: [NSLayoutConstraint] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        tableView.forAutolayout()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isMultipleTouchEnabled  = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {
        view.addSubview(tableView)
        constraintsForTableView.append(contentsOf: [
            tableView.pinTop(to: view.topAnchor, inset: 32),
            tableView.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate(constraintsForTableView)
    }
}

extension MenuViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else { return UITableViewCell()}
        let action = viewModel.model[indexPath.row]
        cell.conigure(action: action)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
