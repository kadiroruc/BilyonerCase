//
//  MatchCell.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

final class MatchCell: UICollectionViewCell {
    static let identifier = "MatchCell"

    private let leagueLabel: UILabel = {
        let leagueLabel = UILabel()
        leagueLabel.font = .systemFont(ofSize: 14, weight: .bold)
        leagueLabel.textColor = .systemGray
        leagueLabel.translatesAutoresizingMaskIntoConstraints = false
        return leagueLabel
    }()

    private let teamsLabel: UILabel = {
        let teamsLabel = UILabel()
        teamsLabel.font = .systemFont(ofSize: 16, weight: .medium)
        teamsLabel.textColor = .label
        teamsLabel.textAlignment = .center
        teamsLabel.translatesAutoresizingMaskIntoConstraints = false
        return teamsLabel
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        timeLabel.textColor = .systemGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    private let ms1Button = OddsButton()
    private let msxButton = OddsButton()
    private let ms2Button = OddsButton()

    private lazy var oddsStack: UIStackView = {
        let oddsStack = UIStackView(arrangedSubviews: [ms1Button, msxButton, ms2Button])
        oddsStack.axis = .horizontal
        oddsStack.distribution = .fillEqually
        oddsStack.spacing = 36
        oddsStack.translatesAutoresizingMaskIntoConstraints = false
        return oddsStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        [leagueLabel, teamsLabel, timeLabel, oddsStack].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            leagueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leagueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            teamsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            teamsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            oddsStack.topAnchor.constraint(equalTo: teamsLabel.bottomAnchor, constant: 8),
            oddsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            oddsStack.heightAnchor.constraint(equalToConstant: 36),
            oddsStack.widthAnchor.constraint(equalToConstant: 64*3 + 36*2),
            oddsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
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



