//
//  Player.swift
//  Blackjack
//
//  Created by Vladislavs on 26/10/2022.
//

import Foundation

class Player {
    
    private var cards: [Card] = []
    private var playing: Bool = true
    
    func isPlaying() -> Bool {
        return self.playing && self.getScore() < 21
    }
    
    func getHand() -> [Card] {
        return self.cards
    }
    
    func getHandNames() -> [String] {
        return self.cards.map { $0.getName() }
    }
    
    func takeCard(card: Card) {
        if self.playing {
            self.cards.append(card)
        }
    }
    
    func endTurn() {
        self.playing = false
    }
    
    func getScore() -> Int {
        var score: Int = 0
        var aces: Int = self.cards.filter { $0.getValue() == 11 }.count
        
        for card in self.cards {
            score += card.getValue()
        }
        
        while score > 21 && aces > 0 {
            score -= 10
            aces -= 1
        }
        
        return score
    }
}
