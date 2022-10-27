//
//  Dealer.swift
//  Blackjack
//
//  Created by Vladislavs on 27/10/2022.
//

import Foundation

class Dealer: Player {
    
    override func isPlaying() -> Bool {
        return self.getScore() < 17
    }
}
