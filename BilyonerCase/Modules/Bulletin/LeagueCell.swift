//
//  LeagueCell.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

// MARK: - Constants

fileprivate enum Layout {
    static let cornerRadius: CGFloat = 12
    static let verticalPadding: CGFloat = 4
    static let horizontalPadding: CGFloat = 8
}

fileprivate enum Typography {
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
}

fileprivate enum Colors {
    static let backgroundColor = UIColor.secondarySystemBackground
    static let textColor = UIColor.label
}

final class LeagueCell: UICollectionViewCell {
    static let identifier = "LeagueCell"

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Typography.titleFont
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityIdentifier = "LeagueCell.leagueTitleLabel"
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.backgroundColor
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.verticalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalPadding)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with title: String) {
        titleLabel.text = title
    }
}


