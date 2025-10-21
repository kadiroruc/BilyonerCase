//
//  HomeViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showLeagues(_ leagues: [League])
    func showMatches()
}


final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelProtocol
    private var filteredLeagues: [League] = []
    private var selectedLeague: League?

    private let leaguesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let leaguesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        leaguesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        leaguesCollectionView.showsHorizontalScrollIndicator = false
        leaguesCollectionView.backgroundColor = .clear
        return leaguesCollectionView
    }()

    private let matchesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        let matchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        matchesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        matchesCollectionView.backgroundColor = .clear
        return matchesCollectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Init

    init(viewModel: HomeViewModelProtocol) {
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
            leaguesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            leaguesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            leaguesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            leaguesCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            matchesCollectionView.topAnchor.constraint(equalTo: leaguesCollectionView.bottomAnchor, constant: 16),
            matchesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            matchesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        searchController.searchBar.placeholder = "Search League"
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == leaguesCollectionView { return filteredLeagues.count }
        else { return viewModel.matches.count }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == leaguesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeagueCell.identifier, for: indexPath) as! LeagueCell
            let league = filteredLeagues[indexPath.item]
            cell.configure(with: league.title)
            cell.contentView.backgroundColor = league.key == selectedLeague?.key ? .systemGreen : .secondarySystemBackground
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCell.identifier, for: indexPath) as! MatchCell
            let match = viewModel.matches[indexPath.item]
            cell.configure(with: match)
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
            let width = league.title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]).width + 32
            return CGSize(width: width, height: 44)
        } else {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
    }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {

    func showLoading(_ show: Bool) {
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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

extension HomeViewController: UISearchResultsUpdating {
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
