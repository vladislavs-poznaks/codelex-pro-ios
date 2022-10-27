//
//  CardCell.swift
//  Blackjack
//
//  Created by Vladislavs on 27/10/2022.
//

import UIKit

class CardCell: UICollectionViewCell {
    static let identifier = "CardCell"
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 100)
        
        cardImageView.frame = bounds
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    func configure(cardImage: String) {
        cardImageView.image = UIImage(named: cardImage)
    }
}
