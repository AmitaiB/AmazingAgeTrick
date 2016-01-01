//
//  AAGCardModel.swift
//  AmazingAgeGuesser
//
//  Created by Amitai Blickstein on 12/20/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class AATDeckModel: NSObject {
    static let sharedDeck = AATDeckModel()
    private override init() {}
    
    private let cards = [
        [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59],
        [2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,35,38,39,42,43,46,47,50,51,54,55,58,59],
        [4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31,36,37,38,39,44,45,46,47,52,53,54,55,60],
        [8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,40,41,42,43,44,45,46,47,56,57,58,59],
        [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,48,49,50,51,52,53,54,55,56,57,58,59,60],
        [32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60]]
    
    private var deck:[[Int]] = [[0]]
    
    var topCard:[Int]?
    
    // MARK: Query Deck methods
    func isFull() ->Bool {
        return deck.count == cards.count
    }
    
    func isEmpty()->Bool {
        return deck.isEmpty
    }
    
    func cardsInDeck()->Int {
        return deck.count
    }
    
    
    func peekAtRandomCard()->[Int] {
        let randomIndex = Int(arc4random_uniform(UInt32(cards.endIndex)))
        return cards[randomIndex]
    }
    
    // MARK: Manipulate Deck methods
    
    func resetDeck() {
        deck = cards
    }
    
    func drawCardFromDeck()->[Int] {
        if deck.count == 0 {return [-1]}
        
        let randomIndex = Int(arc4random_uniform(UInt32(deck.endIndex)))
        topCard = deck[randomIndex]
        deck.removeAtIndex(randomIndex)
        return topCard!
    }
}
