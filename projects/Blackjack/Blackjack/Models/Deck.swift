//
//  Deck.swift
//  Blackjack
//
//  Created by Vladislavs on 26/10/2022.
//

import Foundation

class Deck {
    
    private var cards: [Card] = []
    
    init() {
        let suits: [String] = [
            "S", "D", "H", "C"
        ]
        
        let values: [String] = [
            "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"
        ]
        
        self.cards = []
        
        for suit in suits {
            for value in values {
                self.cards.append(Card(suit: suit, value: value))
            }
        }
        
        self.cards.shuffle()
    }
    
    func getCard() -> Card {
        if self.cards.isEmpty {
            // TODO: Recreate deck or smth
        }
        
        return self.cards.removeLast();
    }
}
