//
//  Card.swift
//  Blackjack
//
//  Created by Vladislavs on 26/10/2022.
//

import Foundation

class Card {
    
    private let suit: String
    private let value: String
    
    init(suit: String, value: String) {
        self.suit = suit
        self.value = value
    }
    
    func getName() -> String {
        return "\(self.suit)\(self.value)"
    }
    
    func getValue() -> Int {
        switch self.value {
        case "A":
            return 11
        case "K", "Q", "J":
            return 10
        default:
            return Int(self.value)!
        }
    }
}
