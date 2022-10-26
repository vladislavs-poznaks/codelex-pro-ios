//
//  ViewController.swift
//  02-emoji-collection
//
//  Created by Vladislavs on 25/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
        
    private var emojis: [String] = (0x1F601...0x1F64F)
        .choose(30)
        .map {String(UnicodeScalar($0) ?? "-")}
    
    
    private let emojiCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emojiCollectionView.frame = view.bounds
    }
    
    func setupView() {
        view.addSubview(emojiCollectionView)
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // (view.frame.size.width / 3) - 3 <- subtrack by 3 it means for padding 1 between cells
            return CGSize(width: (view.frame.size.width / 4) - 3, height: (view.frame.size.width / 4) - 3)
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

//extension HomeViewController: UICollectionViewDelegate {
//    // TODO: What should be in delegate?!
//}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell {
            cell.configure(emoji: emojis[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

