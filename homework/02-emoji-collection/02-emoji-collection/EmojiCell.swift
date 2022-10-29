//
//  EmojiCell.swift
//  02-emoji-collection
//
//  Created by Vladislavs on 25/10/2022.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emojiLabel.frame = contentView.bounds
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    func configure(emoji: String) {
        emojiLabel.text = emoji
    }
}
