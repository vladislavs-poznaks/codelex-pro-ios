//
//  ViewController.swift
//  Blackjack
//
//  Created by Vladislavs on 26/10/2022.
//

import UIKit

class GameViewController: UIViewController {
    
    private let game = Game()
    
    private var playerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Player hand"
        
        return label
    }()
    
    private var playerHandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var dealerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dealer hand"
        
        return label
    }()
    
    private var dealerHandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var hitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(hitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var standButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stand", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(standButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play again!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let playerHandCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerHandCollectionView.frame = view.bounds
    }
    
    func refresh() {
        if (game.getPlayer().isPlaying() == false) {
            while game.getDealer().isPlaying(), game.getDealer().getScore() < game.getPlayer().getScore(), game.getPlayer().getScore() < 21 {
                game.getDealer().takeCard(card: game.getDeck().getCard())
            }
            
            resultLabel.text = game.getResult()
        }
        
        dealerHandLabel.text = game.getDealer().getHandNames().joined(separator: " | ")
        playerHandLabel.text = game.getPlayer().getHandNames().joined(separator: " | ")
    
        playerHandCollectionView.reloadData()
        
        hitButton.isEnabled = game.getPlayer().isPlaying()
        hitButton.isHidden = game.getPlayer().isPlaying() == false
        
        standButton.isEnabled = game.getPlayer().isPlaying()
        standButton.isHidden = game.getPlayer().isPlaying() == false
        
        resultLabel.isHidden = game.getPlayer().isPlaying()
        
        resetButton.isEnabled = game.getPlayer().isPlaying() == false
        resetButton.isHidden = game.getPlayer().isPlaying()
    }

    func setupView() {
        
        playerHandCollectionView.delegate = self
        playerHandCollectionView.dataSource = self
        
        playerHandCollectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        
//        view.addSubview(playerHandCollectionView)
        
        view.addSubview(dealerLabel)
        view.addSubview(dealerHandLabel)
        
        view.addSubview(playerLabel)
        view.addSubview(playerHandLabel)
        
        view.addSubview(hitButton)
        view.addSubview(standButton)
        
        view.addSubview(resultLabel)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
//            playerHandCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            playerHandCollectionView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -500),
            
            dealerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dealerLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            dealerHandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dealerHandLabel.centerYAnchor.constraint(equalTo: dealerLabel.bottomAnchor, constant: 25),
            
            playerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            playerHandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerHandLabel.centerYAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 25),
            
            hitButton.widthAnchor.constraint(equalToConstant: 150),
            hitButton.heightAnchor.constraint(equalToConstant: 50),
            
            standButton.widthAnchor.constraint(equalToConstant: 150),
            standButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.widthAnchor.constraint(equalToConstant: 150),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            hitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            hitButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            standButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            standButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400),
        ])
    }
    
    @objc
    func hitButtonTapped() {
        game.getPlayer().takeCard(card: game.getDeck().getCard())
        
        refresh()
    }
    
    @objc
    func standButtonTapped() {
        game.getPlayer().endTurn()
        
        refresh()
    }
    
    @objc
    func resetButtonTapped() {
        self.game.start()
        
        refresh()
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // (view.frame.size.width / 3) - 3 <- subtrack by 3 it means for padding 1 between cells
        let count = CGFloat(game.getPlayer().getHand().count)
                
        return CGSize(width: (view.frame.size.width / count) - 3, height: (view.frame.size.width / count) - 3)
        }
        
        // 3 items in the row so 1 * 3 for each cell
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        // Padding of the whole collection view
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        }
        
        // Space between rows
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            3
        }
}

extension GameViewController: UICollectionViewDelegate {
    // TODO: What should be in delegate?!
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.game.getPlayer().getHand().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = playerHandCollectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell {
            cell.configure(cardImage: game.getPlayer().getHand()[indexPath.row].getName())
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
