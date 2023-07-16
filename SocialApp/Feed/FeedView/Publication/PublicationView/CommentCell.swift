//
//  CommentCell.swift
//  SocialApp
//
//  Created by Олеся on 05.07.2023.
//

import UIKit

class CommentCell: UITableViewCell {

    private var cellConstraints: [NSLayoutConstraint] = []
    private let commentView = CommentView()
    private var commentViewModel: CommentViewModel?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        commentView.forAutolayout()
        contentView.addSubview(commentView)

        cellConstraints.append(contentsOf: [
            commentView.pinTop(to: contentView.topAnchor),
            commentView.pinLeading(to: contentView.leadingAnchor),
            commentView.pinBottom(to: contentView.bottomAnchor),
            commentView.pinTrailing(to: contentView.trailingAnchor),
        ])
        NSLayoutConstraint.activate(cellConstraints)
    }
    func configure(viewModel: CommentViewModel){
        commentView.configureCell(viewModel: viewModel)

    }
}

