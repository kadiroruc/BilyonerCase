//
//  BasketViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import UIKit

fileprivate enum Layout {
    static let collectionViewSpacing: CGFloat = 12
    static let standardMargin: CGFloat = 16
    static let bottomViewHeight: CGFloat = 230
    static let textFieldHeight: CGFloat = 44
    static let buttonHeight: CGFloat = 44
    static let matchCellHeight: CGFloat = 120
}

fileprivate enum Typography {
    static let labelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let boldLabelFont = UIFont.systemFont(ofSize: 16, weight: .bold)
}

fileprivate enum UI {
    static let navigationTitle = "Basket"
    static let playNowTitle = "Play Now"
    static let clearAllTitle = "Clear All"
    static let amountPlaceholder = "Amount"
    static let couponAmountPrefix = "Coupon Amount: "
    static let totalOddsPrefix = "Total Odds: "
    static let maxWinPrefix = "Max Win: "
    static let currencySuffix = " TL"
    static let errorAlertTitle = "Error"
    static let successAlertTitle = "Success"
    static let alertButtonTitle = "OK"
}

protocol BasketViewDelegate: AnyObject {
    func showBets()
    func updateBadgeValue(_ value: Int)
    func updateCouponDetails()
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func enablePlayNowButton(isEnabled: Bool)
}

// MARK: - BasketViewController

final class BasketViewController: UIViewController {
    
    private let viewModel: BasketViewModelDelegate
    
    private let betsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Layout.collectionViewSpacing
        let betsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        betsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        betsCollectionView.backgroundColor = .clear
        betsCollectionView.accessibilityIdentifier = "BasketViewController.betsCollectionView"
        return betsCollectionView
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .systemBackground
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomView.layer.shadowRadius = 4
        bottomView.layer.shadowOpacity = 0.1
        bottomView.accessibilityIdentifier = "BasketViewController.bottomView"
        return bottomView
    }()
    
    private let couponAmountLabel: UILabel = {
        let couponAmountLabel = UILabel()
        couponAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        couponAmountLabel.text = "\(UI.couponAmountPrefix)50\(UI.currencySuffix)"
        couponAmountLabel.font = Typography.labelFont
        couponAmountLabel.textColor = .label
        couponAmountLabel.accessibilityIdentifier = "BasketViewController.couponAmountLabel"
        return couponAmountLabel
    }()
    
    private let totalOddsLabel: UILabel = {
        let totalOddsLabel = UILabel()
        totalOddsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalOddsLabel.text = "\(UI.totalOddsPrefix)1.00"
        totalOddsLabel.font = Typography.labelFont
        totalOddsLabel.textColor = .label
        totalOddsLabel.accessibilityIdentifier = "BasketViewController.totalOddsLabel"
        return totalOddsLabel
    }()
    
    private let maxWinLabel: UILabel = {
        let maxWinLabel = UILabel()
        maxWinLabel.translatesAutoresizingMaskIntoConstraints = false
        maxWinLabel.text = "\(UI.maxWinPrefix)50.00\(UI.currencySuffix)"
        maxWinLabel.font = Typography.boldLabelFont
        maxWinLabel.textColor = .systemGreen
        maxWinLabel.accessibilityIdentifier = "BasketViewController.maxWinLabel"
        return maxWinLabel
    }()
    
    private let balanceLabel: UILabel = {
        let balanceLabel = UILabel()
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.text = "1000.00\(UI.currencySuffix)"
        balanceLabel.font = Typography.labelFont
        balanceLabel.textColor = .systemGreen
        balanceLabel.accessibilityIdentifier = "BasketViewController.balanceLabel"
        return balanceLabel
    }()
    
    private let amountTextField: UITextField = {
        let amountTextField = UITextField()
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.placeholder = UI.amountPlaceholder
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.text = "50"
        amountTextField.accessibilityIdentifier = "BasketViewController.amountTextField"
        return amountTextField
    }()
    
    private let playNowButton: UIButton = {
        let playNowButton = UIButton(type: .system)
        playNowButton.translatesAutoresizingMaskIntoConstraints = false
        playNowButton.setTitle(UI.playNowTitle, for: .normal)
        playNowButton.backgroundColor = .systemGreen
        playNowButton.setTitleColor(.white, for: .normal)
        playNowButton.titleLabel?.font = Typography.boldLabelFont
        playNowButton.layer.cornerRadius = 8
        playNowButton.accessibilityIdentifier = "BasketViewController.playNowButton"
        return playNowButton
    }()
    
    private let clearAllButton: UIButton = {
        let clearAllButton = UIButton(type: .system)
        clearAllButton.translatesAutoresizingMaskIntoConstraints = false
        clearAllButton.setTitle(UI.clearAllTitle, for: .normal)
        clearAllButton.backgroundColor = .systemRed
        clearAllButton.setTitleColor(.white, for: .normal)
        clearAllButton.titleLabel?.font = Typography.boldLabelFont
        clearAllButton.layer.cornerRadius = 8
        clearAllButton.accessibilityIdentifier = "BasketViewController.clearAllButton"
        return clearAllButton
    }()
    
    // MARK: - Init
    
    init(viewModel: BasketViewModelDelegate, bulletinVM: BulletinViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
        self.viewModel.bind(to: bulletinVM)
    }

    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollections()
        setupActions()
        updateCouponDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = UI.navigationTitle
        
        [betsCollectionView, bottomView].forEach { view.addSubview($0) }
        [couponAmountLabel, totalOddsLabel, maxWinLabel, balanceLabel, amountTextField, playNowButton, clearAllButton].forEach { bottomView.addSubview($0) }

        NSLayoutConstraint.activate([
            betsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.standardMargin),
            betsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.standardMargin),
            betsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.standardMargin),
            betsCollectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: Layout.bottomViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            couponAmountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Layout.standardMargin),
            couponAmountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            totalOddsLabel.topAnchor.constraint(equalTo: couponAmountLabel.bottomAnchor, constant: 8),
            totalOddsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            maxWinLabel.topAnchor.constraint(equalTo: totalOddsLabel.bottomAnchor, constant: 8),
            maxWinLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Layout.standardMargin),
            balanceLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: maxWinLabel.bottomAnchor, constant: Layout.standardMargin),
            amountTextField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Layout.standardMargin),
            amountTextField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Layout.standardMargin),
            amountTextField.heightAnchor.constraint(equalToConstant: Layout.textFieldHeight)
        ])
        
        NSLayoutConstraint.activate([
            playNowButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: Layout.standardMargin),
            playNowButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Layout.standardMargin),
            playNowButton.trailingAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -8),
            playNowButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            clearAllButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: Layout.standardMargin),
            clearAllButton.leadingAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 8),
            clearAllButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Layout.standardMargin),
            clearAllButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
    }
    
    private func setupCollections() {
        betsCollectionView.delegate = self
        betsCollectionView.dataSource = self
        betsCollectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.identifier)
    }
    
    private func setupActions() {
        playNowButton.addTarget(self, action: #selector(playNowTapped), for: .touchUpInside)
        clearAllButton.addTarget(self, action: #selector(clearAllTapped), for: .touchUpInside)
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    @objc private func playNowTapped() {
        viewModel.playNow()
    }
    
    @objc private func clearAllTapped() {
        viewModel.clearAllBets()
    }
    
    @objc private func amountChanged() {
        guard let text = amountTextField.text, let amount = Double(text) else { return }
        viewModel.updateCouponAmount(amount)
        updateCouponDetails()
    }

}

// MARK: - UICollectionView

extension BasketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCell.identifier, for: indexPath) as! MatchCell
        let bet = viewModel.bets[indexPath.item]
        cell.configure(with: bet.match)
        cell.isUserInteractionEnabled = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Layout.matchCellHeight)
    }
    
}

// MARK: - BasketViewDelegate

extension BasketViewController: BasketViewDelegate {
    func enablePlayNowButton(isEnabled: Bool) {
        playNowButton.isEnabled = isEnabled
        playNowButton.alpha = isEnabled ? 1 : 0.5
    }
    
    func updateBadgeValue(_ value: Int) {
        navigationController?.tabBarItem.badgeValue = String(value)
    }
    
    func showBets() {
        betsCollectionView.reloadData()
    }
    
    func updateCouponDetails() {
        couponAmountLabel.text = "\(UI.couponAmountPrefix)\(String(format: "%.0f", viewModel.couponAmount))\(UI.currencySuffix)"
        totalOddsLabel.text = "\(UI.totalOddsPrefix)\(String(format: "%.2f", viewModel.totalOdds))"
        maxWinLabel.text = "\(UI.maxWinPrefix)\(String(format: "%.2f", viewModel.maxWin))\(UI.currencySuffix)"
        balanceLabel.text = "\(String(format: "%.2f", viewModel.balance))\(UI.currencySuffix)"
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: UI.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.alertButtonTitle, style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: UI.successAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.alertButtonTitle, style: .default))
        present(alert, animated: true)
    }
}
