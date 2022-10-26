//
//  CreateWordViewController.swift
//  01-word-randomizer
//
//  Created by Vladislavs on 22/10/2022.
//

import UIKit

protocol CreateWordViewControllerDelegate: AnyObject {
    func isWordAvailable(_ word: String) -> Bool
    func wordSubmitted(_ word: String) -> Void
}

class CreateWordViewController: UIViewController {
    
    weak var delegate: CreateWordViewControllerDelegate?
    
    lazy var wordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "random"
        textField.keyboardType = .alphabet
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(wordTextFieldChanged), for: .editingChanged)
        
        return textField
    }()
    
    lazy var storeWordButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(storeWordButtonTapped), for: .touchUpInside)

        
        return button
    }()
    
    lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()	
                
        initView()
    }
    
    func initView() {
        view.backgroundColor = .white
        
        view.addSubview(wordTextField)
        view.addSubview(storeWordButton)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            wordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            storeWordButton.widthAnchor.constraint(equalToConstant: 150),
            storeWordButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            storeWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            storeWordButton.centerYAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 50),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: storeWordButton.centerYAnchor, constant: 50),
        ])
    }
    
    @objc
    func wordTextFieldChanged(_ sender: UITextField) {
        if let text = sender.text {
            print("On change: ", text)
            // TODO: Add validation
//            if let isAvailable = self.delegate?.isWordAvailable(text) {
//                self.storeWordButton.isEnabled = true
//            } else {
//                self.storeWordButton.isEnabled = false
//            }
        }
    }
    
    @objc
    func storeWordButtonTapped() {
        if let text = wordTextField.text {
            self.delegate?.wordSubmitted(text)
            dismiss(animated: true)
        }
    }
    
    
    @objc
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
