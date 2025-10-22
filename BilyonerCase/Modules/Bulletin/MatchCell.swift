//
//  MatchCell.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

protocol MatchCellDelegate: AnyObject {
    func matchCell(_ cell: MatchCell, didSelectBet bet: MatchBet)
}
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
    weak var delegate: MatchCellDelegate?
    private var currentMatch: Match?

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
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
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
    
    private func setupActions() {
        ms1Button.addTarget(self, action: #selector(oddTapped(_:)), for: .touchUpInside)
        msxButton.addTarget(self, action: #selector(oddTapped(_:)), for: .touchUpInside)
        ms2Button.addTarget(self, action: #selector(oddTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func oddTapped(_ sender: OddsButton) {
        guard let match = currentMatch else { return }
        
        let oddType: String
        let value: String

        switch sender {
        case ms1Button:
            oddType = "MS1"
            value = ms1Button.titleLabel?.text?.components(separatedBy: "\n").first ?? ""
        case msxButton:
            oddType = "MSX"
            value = msxButton.titleLabel?.text?.components(separatedBy: "\n").first ?? ""
        case ms2Button:
            oddType = "MS2"
            value = ms2Button.titleLabel?.text?.components(separatedBy: "\n").first ?? ""
        default:
            return
        }
        
        let bet = MatchBet(match: match, oddType: oddType, value: value)
        delegate?.matchCell(self, didSelectBet: bet)
    }

    private func resetSelection() {
        ms1Button.setSelectedTop(false)
        msxButton.setSelectedTop(false)
        ms2Button.setSelectedTop(false)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ms1Button.resetSelection()
        msxButton.resetSelection()
        ms2Button.resetSelection()
    }

    func configure(with match: Match) {
        currentMatch = match
        
        leagueLabel.text = match.sportTitle
        teamsLabel.text = "\(match.homeTeam) vs \(match.awayTeam)"
        timeLabel.text = match.commenceTime.formattedToLocalString()

        if let outcomes = match.bookmakers.first?.markets.first?.outcomes {
            if outcomes.count == 2 {
                ms1Button.setOddTitle(odd: String(format: "%.2f", outcomes[0].price), label: "MS1")
                msxButton.setOddTitle(odd: "X", label: "MSX")
                msxButton.isEnabled = false
                ms2Button.setOddTitle(odd: String(format: "%.2f", outcomes[1].price), label: "MS2")
            } else if outcomes.count == 3 {
                ms1Button.setOddTitle(odd: String(format: "%.2f", outcomes[0].price), label: "MS1")
                msxButton.setOddTitle(odd: String(format: "%.2f", outcomes[2].price), label: "MSX")
                msxButton.isEnabled = true
                ms2Button.setOddTitle(odd: String(format: "%.2f", outcomes[1].price), label: "MS2")
            }
        }
        
        if let selectedOdd = match.selectedOdd {
            switch selectedOdd {
            case "MS1":
                resetSelection()
                ms1Button.setSelectedTop(true)
            case "MS2":
                resetSelection()
                ms2Button.setSelectedTop(true)
            case "MSX":
                resetSelection()
                msxButton.setSelectedTop(true)
            default:
                resetSelection()
            }
        } else {
            resetSelection()
        }
    }
}



