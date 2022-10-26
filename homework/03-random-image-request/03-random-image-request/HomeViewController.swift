//
//  ViewController.swift
//  03-random-image-request
//
//  Created by Vladislavs on 25/10/2022.
//

import UIKit

class CacheService {
    static let cache = NSCache<NSString, UIImage>()
}

class HomeViewController: UIViewController {
    
    private let imageUrls: [String] = [
        "https://images.unsplash.com/photo-1569135579442-d37b7a0ea74e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1588&q=80",
        "https://images.unsplash.com/photo-1570657853296-2ac45dfd3db0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1587&q=80",
        "https://images.unsplash.com/photo-1575321539738-12cdc5ee584e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1587&q=80",
    ]
    
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private lazy var imageRandomizeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Randomize", for: .normal)
        button.setTitle("Loading...", for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(imageRandomizeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        randomize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImageView.frame = view.bounds
    }
    
    func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(imageRandomizeButton)
        
        NSLayoutConstraint.activate([
            imageRandomizeButton.widthAnchor.constraint(equalToConstant: 150),
            imageRandomizeButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageRandomizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageRandomizeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func randomize() {
        fetchImage(getRandomImageUrl())
    }
    
    func getRandomImageUrl() -> String {
        return imageUrls[.random(in: 0...(imageUrls.count - 1))]
    }
    
    func fetchImage(_ imageUrl: String) {
        self.disableImageRandomizeButton()
	
        let key = imageUrl.toBase64() as NSString
        
        if let image = CacheService.cache.object(forKey: key) {
            self.setBackgroundImage(image)
            return;
        }
        
        guard let url = URL(string: imageUrl) else { return }

        utilityQueue.async {
            let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    self.enableImageRandomizeButton()
                    return
                }
                
                // Setting image should be in main thread
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    
                    CacheService.cache.setObject(image, forKey: key)
                    
                    self.setBackgroundImage(image)
                }
            }
            
            // Nobody in iOS world didn't know why we need to start the task implisitly like this
            dataTask.resume()
        }
    }
    
    func setBackgroundImage(_ image: UIImage) {
        self.backgroundImageView.image = image
        
        self.enableImageRandomizeButton()
    }
    
    func enableImageRandomizeButton()  {
        self.imageRandomizeButton.isEnabled = true
    }
    
    func disableImageRandomizeButton()  {
        self.imageRandomizeButton.isEnabled = false
    }

    @objc
    func imageRandomizeButtonTapped() {
        randomize()
    }
}

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
