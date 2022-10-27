//
//  Game.swift
//  Blackjack
//
//  Created by Vladislavs on 27/10/2022.
//

import Foundation

class Game {
    
    private var deck: Deck
    
    private var player: Player
    private var dealer: Dealer
    
    init() {
        self.deck = Deck()
        
        self.player = Player()
        self.dealer = Dealer()
        
        self.dealCards()
    }
    
    func start() {
        self.deck = Deck()
        
        self.player = Player()
        self.dealer = Dealer()
        
        self.dealCards()
    }
    
    func dealCards() {
        self.player.takeCard(card: self.deck.getCard())
        self.dealer.takeCard(card: self.deck.getCard())

        self.player.takeCard(card: self.deck.getCard())
        self.dealer.takeCard(card: self.deck.getCard())
    }
    
    func isOver() -> Bool {
        return self.getPlayer().isPlaying() == false
    }
    
    func getDeck() -> Deck {
        return self.deck
    }
    
    func getPlayer() -> Player {
        return self.player
    }
    
    func getDealer() -> Dealer {
        return self.dealer
    }
    
    func getResult() -> String {
        if (player.getScore() == 21) {
            return "BlackJack!"
        }
        
        if (player.getScore() > 21) {
            return "Player busts!"
        }
        
        if (dealer.getScore() > 21) {
            return "Dealer busts!"
        }
        
        if (player.getScore() == dealer.getScore()) {
            return "Push... No winner."
        }
        
        if (player.getScore() > dealer.getScore()) {
            return "Player wins!"
        }
        
        return "Dealer wins!"
    }
}
