//
//  AATCardModel.swift
//  AmazingAgeGuesser
//
//  Created by Amitai Blickstein on 12/20/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//
import UIKit

enum CardID:Int {
    case Card1 = 1
    case Card2 = 2
    case Card3 = 4
    case Card4 = 8
    case Card5 = 16
    case Card6 = 32
}

class AATDeckModel: NSObject {
    static let sharedDeck = AATDeckModel()
    private override init() {}
    
    let cards:[CardID:[Int]] = [
        CardID.Card1:[1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59],
        CardID.Card2:[2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,35,38,39,42,43,46,47,50,51,54,55,58,59],
        CardID.Card3:[4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31,36,37,38,39,44,45,46,47,52,53,54,55,60],
        CardID.Card4:[8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,40,41,42,43,44,45,46,47,56,57,58,59,60],
        CardID.Card5:[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,48,49,50,51,52,53,54,55,56,57,58,59,60],
        CardID.Card6:[32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60]]
    
    private var deck       = [CardID]()
    private var drawnCards = [CardID]()
    
    
    
    // MARK: Query Deck methods
    func isFull() ->Bool {return drawnCards.isEmpty}
    
    func isEmpty()->Bool {return drawnCards.count == cards.count}
    
    func count()->Int {
        return cards.count - drawnCards.count
    }
    
    
    // MARK: Manipulate Deck methods
    
    func reset() {
        drawnCards.removeAll()
    }
    
    
    /**
    Monitors hand for duplicate drawn cards from pool of possible cards.
    
    - returns: CardID of the drawn card, to retrieve cardInfo from the cards dictionary.
    */
    
    func drawCard()->CardID {
        var possibleCards:[CardID] = Array(cards.keys)
        possibleCards.shuffle()
        
        var idx = 0
        let countBeforeDrawAttempt = drawnCards.count
        repeat {
            guard let possibleDrawnCard = possibleCards.popLast() else {break} ; idx += 1
            
            if neverDrewThisCard(possibleDrawnCard) {drawnCards.append(possibleDrawnCard)}
        } while drawnCards.count == countBeforeDrawAttempt
            && idx < 1000
        
        return drawnCards.last!
    }
    
    func neverDrewThisCard(cardKey:CardID)->Bool {
        return !drawnCards.contains(cardKey)
    }
}


//Fisher-Yates Shuffle, Uniform distribution in O(n)
//http://stackoverflow.com/a/24029847/4898050

private extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

private extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension CollectionType {
    func randomizeElements() -> [Generator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
