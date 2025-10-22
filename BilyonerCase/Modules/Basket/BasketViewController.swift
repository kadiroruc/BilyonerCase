//
//  BasketViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import UIKit

protocol BasketViewProtocol: AnyObject {
    func showBets()
}

class BasketViewController: UIViewController {
    
    private let viewModel: BasketViewModelProtocol
    
    private let betsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        let betsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        betsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        betsCollectionView.backgroundColor = .clear
        return betsCollectionView
    }()
    
    // MARK: - Init
    
    init(viewModel: BasketViewModelProtocol, bulletinVM: BulletinViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
        self.viewModel.bind(to: bulletinVM)
    }

    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollections()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        [betsCollectionView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            betsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            betsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            betsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            betsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setupCollections() {
        betsCollectionView.delegate = self
        betsCollectionView.dataSource = self
        betsCollectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.identifier)
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
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
}


// MARK: - BasketViewProtocol

extension BasketViewController: BasketViewProtocol {
    func showBets() {
        betsCollectionView.reloadData()
    }
    
}
