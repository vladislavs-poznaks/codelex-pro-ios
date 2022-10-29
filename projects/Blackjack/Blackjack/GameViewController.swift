//
//  ViewController.swift
//  Blackjack
//
//  Created by Vladislavs on 26/10/2022.
//

import UIKit

class GameViewController: UIViewController {
    
    private let game = Game()
    
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
    
    private let dealerHandCollectionView = UICollectionView(
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
        	
        let playerHandBounds = CGRect(x: 0, y: 300, width: view.bounds.width, height: 100)
        playerHandCollectionView.frame = playerHandBounds
        
        let dealerHandBounds = CGRect(x: 0, y: 150, width: view.bounds.width, height: 100)
        dealerHandCollectionView.frame = dealerHandBounds
    }
    
    func refresh() {
        if (game.getPlayer().isPlaying() == false) {
            while game.getDealer().isPlaying(), game.getDealer().getScore() < game.getPlayer().getScore(), game.getPlayer().getScore() < 21 {
                game.getDealer().takeCard(card: game.getDeck().getCard())
            }
            
            resultLabel.text = game.getResult()
        }
    
        dealerHandCollectionView.reloadData()
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
        view.backgroundColor = .lightGray
        
        dealerHandCollectionView.delegate = self
        dealerHandCollectionView.dataSource = self
        
        playerHandCollectionView.delegate = self
        playerHandCollectionView.dataSource = self
        
        dealerHandCollectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        playerHandCollectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        
        view.addSubview(dealerHandCollectionView)
        view.addSubview(playerHandCollectionView)
        
        view.addSubview(hitButton)
        view.addSubview(standButton)
        
        view.addSubview(resultLabel)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            hitButton.widthAnchor.constraint(equalToConstant: 150),
            hitButton.heightAnchor.constraint(equalToConstant: 50),
            
            standButton.widthAnchor.constraint(equalToConstant: 150),
            standButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.widthAnchor.constraint(equalToConstant: 150),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            hitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            hitButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            standButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            standButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: resetButton.topAnchor, constant: -50),
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
            var count: CGFloat = 1
        
            if (collectionView == playerHandCollectionView) {
                count = CGFloat(game.getPlayer().getHand().count)
            }
            
            if (collectionView == dealerHandCollectionView) {	
                count = CGFloat(game.getDealer().getHand().count)
            }
                    	
            return CGSize(width: (view.frame.size.width / count) - count, height: collectionView.frame.size.height)
        }
        
        // 3 items in the row so 1 * 3 for each cell
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        // Padding of the whole collection view
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        // Space between rows
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
}

extension GameViewController: UICollectionViewDelegate {
    // TODO: What should be in delegate?!
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dealerHandCollectionView {
            return self.game.getDealer().getHand().count
        }
        if collectionView == playerHandCollectionView {
            return self.game.getPlayer().getHand().count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dealerHandCollectionView, let cell = dealerHandCollectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell {
            var imageName: String = game.getDealer().getHandNames()[indexPath.row]
            
            if indexPath.row == 0, game.getPlayer().isPlaying() {
                imageName = "00"
            }

            cell.configure(cardImage: imageName)
            
            return cell
        }
        
        if collectionView == playerHandCollectionView, let cell = playerHandCollectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell {
            cell.configure(cardImage: game.getPlayer().getHandNames()[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
