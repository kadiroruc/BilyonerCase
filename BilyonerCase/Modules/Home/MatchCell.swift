//
//  MatchCell.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

// MARK: - Constants

fileprivate enum Layout {
    static let cornerRadius: CGFloat = 12
    static let standardPadding: CGFloat = 8
    static let oddsStackSpacing: CGFloat = 36
    static let oddsStackHeight: CGFloat = 36
    static let oddsButtonWidth: CGFloat = 64
    static let oddsStackTotalWidth: CGFloat = oddsButtonWidth * 3 + oddsStackSpacing * 2
}

fileprivate enum Typography {
    static let leagueLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let teamsLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let timeLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
}

fileprivate enum Colors {
    static let leagueLabelColor = UIColor.systemGray
    static let timeLabelColor = UIColor.systemGray
    static let teamsLabelColor = UIColor.label
    static let cellBackgroundColor = UIColor.secondarySystemBackground
}

final class MatchCell: UICollectionViewCell {
    static let identifier = "MatchCell"

    private let leagueLabel: UILabel = {
        let leagueLabel = UILabel()
        leagueLabel.font = Typography.leagueLabelFont
        leagueLabel.textColor = Colors.leagueLabelColor
        leagueLabel.translatesAutoresizingMaskIntoConstraints = false
        leagueLabel.accessibilityIdentifier = "MatchCell.leagueLabel"
        return leagueLabel
    }()

    private let teamsLabel: UILabel = {
        let teamsLabel = UILabel()
        teamsLabel.font = Typography.teamsLabelFont
        teamsLabel.textColor = Colors.teamsLabelColor
        teamsLabel.textAlignment = .center
        teamsLabel.translatesAutoresizingMaskIntoConstraints = false
        teamsLabel.accessibilityIdentifier = "MatchCell.teamsLabel"
        return teamsLabel
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = Typography.timeLabelFont
        timeLabel.textColor = Colors.timeLabelColor
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.accessibilityIdentifier = "MatchCell.timeLabel"
        return timeLabel
    }()
    
    private let ms1Button = OddsButton()
    private let msxButton = OddsButton()
    private let ms2Button = OddsButton()

    private lazy var oddsStack: UIStackView = {
        let oddsStack = UIStackView(arrangedSubviews: [ms1Button, msxButton, ms2Button])
        oddsStack.axis = .horizontal
        oddsStack.distribution = .fillEqually
        oddsStack.spacing = Layout.oddsStackSpacing
        oddsStack.translatesAutoresizingMaskIntoConstraints = false
        return oddsStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.cellBackgroundColor
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.clipsToBounds = true
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        [leagueLabel, teamsLabel, timeLabel, oddsStack].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            leagueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.standardPadding),
            leagueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.standardPadding)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.standardPadding),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.standardPadding)
        ])
        
        NSLayoutConstraint.activate([
            teamsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.standardPadding),
            teamsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.standardPadding)
        ])
        
        NSLayoutConstraint.activate([
            oddsStack.topAnchor.constraint(equalTo: teamsLabel.bottomAnchor, constant: Layout.standardPadding),
            oddsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            oddsStack.heightAnchor.constraint(equalToConstant: Layout.oddsStackHeight),
            oddsStack.widthAnchor.constraint(equalToConstant: Layout.oddsStackTotalWidth),
            oddsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.standardPadding)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ms1Button.resetSelection()
        msxButton.resetSelection()
        ms2Button.resetSelection()
    }

    func configure(with match: Match) {
        leagueLabel.text = match.sportTitle
        teamsLabel.text = "\(match.homeTeam) vs \(match.awayTeam)"
        timeLabel.text = match.commenceTime.formattedToLocalString()

        if let outcomes = match.bookmakers.first?.markets.first?.outcomes {
            if outcomes.count == 2 {
                ms1Button.setOddTitle(odd: String(format: "%.2f", outcomes[0].price), label: "MS1")
                msxButton.setOddTitle(odd: "X", label: "MSX")
                ms2Button.setOddTitle(odd: String(format: "%.2f", outcomes[1].price), label: "MS2")
            } else if outcomes.count == 3 {
                ms1Button.setOddTitle(odd: String(format: "%.2f", outcomes[0].price), label: "MS1")
                msxButton.setOddTitle(odd: String(format: "%.2f", outcomes[2].price), label: "MSX")
                ms2Button.setOddTitle(odd: String(format: "%.2f", outcomes[1].price), label: "MS2")
            }
        }
    }
}



