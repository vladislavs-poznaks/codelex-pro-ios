//
//  ViewController.swift
//  01-word-randomizer
//
//  Created by Vladislavs on 21/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var words: [String] = [
        "xcode", "ios", "playground", "iPhone", "iPad", "device", "development", "code"
    ]
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        
        return label
    }()
    
    lazy var createWordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(createWordButtonTapped), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initWordLabelTap()
    }
    
    func initView() {
        view.addSubview(wordLabel)
        view.addSubview(createWordButton)
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            createWordButton.widthAnchor.constraint(equalToConstant: 150),
            createWordButton.heightAnchor.constraint(equalToConstant: 50),
            
            createWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createWordButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),

        ])
        
        randomize()
    }
    
    func initWordLabelTap() {
        let wordLabelTap = UITapGestureRecognizer(target: self, action: #selector(wordLabelTapped))
        wordLabel.isUserInteractionEnabled = true
        wordLabel.addGestureRecognizer(wordLabelTap)
    }
    
    func randomize() {
        wordLabel.text = words[.random(in: 0...(words.count - 1))]
    }
    
    @objc
    func wordLabelTapped() {
        randomize()
    }
    
    @objc
    func createWordButtonTapped() {
        let createWordViewController = CreateWordViewController()
        
        createWordViewController.delegate = self
        present(createWordViewController, animated: true)
    }
}

extension HomeViewController: CreateWordViewControllerDelegate {
    func isWordAvailable(_ word: String) -> Bool {
        // TODO: Improved validation
        print("Contains: ", self.words.contains(word))
        return self.words.contains(word) == false
    }
    
    func wordSubmitted(_ word: String) {
        self.words.append(word)
    }
}

