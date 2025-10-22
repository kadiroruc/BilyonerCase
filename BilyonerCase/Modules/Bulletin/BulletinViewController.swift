//
//  BulletinViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

// MARK: - Constants

fileprivate enum Layout {
    static let collectionViewSpacing: CGFloat = 12
    static let standardMargin: CGFloat = 16
    static let leaguesCollectionViewHeight: CGFloat = 60
    static let matchCellHeight: CGFloat = 120
    static let leagueCellHeight: CGFloat = 44
    static let leagueCellHorizontalPadding: CGFloat = 32
}

fileprivate enum Typography {
    static let leagueTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
}

fileprivate enum UI {
    static let searchPlaceholder = "Search League"
    static let errorAlertTitle = "Error"
    static let errorAlertButtonTitle = "OK"
}

protocol BulletinViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showLeagues(_ leagues: [League])
    func showMatches()
}


final class BulletinViewController: UIViewController {

    private let viewModel: BulletinViewModelProtocol
    private var filteredLeagues: [League] = []
    private var selectedLeague: League?

    private let leaguesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Layout.collectionViewSpacing
        let leaguesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        leaguesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        leaguesCollectionView.showsHorizontalScrollIndicator = false
        leaguesCollectionView.backgroundColor = .clear
        leaguesCollectionView.accessibilityIdentifier = "BulletinViewController.leaguesCollectionView"
        return leaguesCollectionView
    }()

    private let matchesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Layout.collectionViewSpacing
        let matchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        matchesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        matchesCollectionView.backgroundColor = .clear
        matchesCollectionView.accessibilityIdentifier = "BulletinViewController.matchesCollectionView"
        return matchesCollectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = "BulletinViewController.activityIndicator"
        return activityIndicator
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Init

    init(viewModel: BulletinViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollections()
        setupSearchController()
        viewModel.fetchLeagues()
    }


    private func setupUI() {
        view.backgroundColor = .systemBackground
        [leaguesCollectionView, matchesCollectionView, activityIndicator].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            leaguesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.standardMargin),
            leaguesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.standardMargin),
            leaguesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.standardMargin),
            leaguesCollectionView.heightAnchor.constraint(equalToConstant: Layout.leaguesCollectionViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            matchesCollectionView.topAnchor.constraint(equalTo: leaguesCollectionView.bottomAnchor, constant: Layout.standardMargin),
            matchesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.standardMargin),
            matchesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.standardMargin),
            matchesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupCollections() {
        leaguesCollectionView.delegate = self
        leaguesCollectionView.dataSource = self
        leaguesCollectionView.register(LeagueCell.self, forCellWithReuseIdentifier: LeagueCell.identifier)

        matchesCollectionView.delegate = self
        matchesCollectionView.dataSource = self
        matchesCollectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.identifier)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = UI.searchPlaceholder
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionView

extension BulletinViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == leaguesCollectionView { return filteredLeagues.count }
        else { return viewModel.matches.count }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == leaguesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LeagueCell.identifier,
                for: indexPath
            ) as? LeagueCell else {
                return UICollectionViewCell()
            }
            
            let league = filteredLeagues[indexPath.item]
            cell.configure(with: league.title)
            cell.contentView.backgroundColor = league.key == selectedLeague?.key ? .systemGreen : .secondarySystemBackground
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MatchCell.identifier,
                for: indexPath
            ) as? MatchCell else {
                return UICollectionViewCell()
            }
            
            let match = viewModel.matches[indexPath.item]
            cell.configure(with: match)
            cell.delegate = self
            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == leaguesCollectionView {
            selectedLeague = filteredLeagues[indexPath.item]
            leaguesCollectionView.reloadData()
            guard let key = selectedLeague?.key else { return }
            viewModel.fetchMatches(leagueKey: key)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == leaguesCollectionView {
            let league = filteredLeagues[indexPath.item]
            let width = league.title.size(withAttributes: [.font: Typography.leagueTitleFont]).width + Layout.leagueCellHorizontalPadding
            return CGSize(width: width, height: Layout.leagueCellHeight)
        } else {
            return CGSize(width: collectionView.frame.width, height: Layout.matchCellHeight)
        }
    }
}

// MARK: - BulletinViewProtocol

extension BulletinViewController: BulletinViewProtocol {

    func showLoading(_ show: Bool) {
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: UI.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.errorAlertButtonTitle, style: .default))
        present(alert, animated: true)
    }

    func showLeagues(_ leagues: [League]) {
        self.filteredLeagues = leagues
        self.selectedLeague = leagues.first
        leaguesCollectionView.reloadData()
        if let key = selectedLeague?.key {
            viewModel.fetchMatches(leagueKey: key)
        }
    }

    func showMatches() {
        matchesCollectionView.reloadData()
    }
}

// MARK: - Search

extension BulletinViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredLeagues = viewModel.leagues
            leaguesCollectionView.reloadData()
            return
        }
        filteredLeagues = viewModel.leagues.filter { $0.title.lowercased().contains(text.lowercased()) }
        leaguesCollectionView.reloadData()
    }
}

// MARK: - MatchCellDelegate

extension BulletinViewController: MatchCellDelegate {
    func matchCell(_ cell: MatchCell, didSelectBet bet: MatchBet) {
        viewModel.selectBet(bet)
        matchesCollectionView.reloadData()
    }

}
