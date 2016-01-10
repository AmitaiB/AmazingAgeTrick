//
//  AATCardModel.swift
//  AmazingAgeGuesser
//
//  Created by Amitai Blickstein on 12/20/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

/**
Using enums with methods: VERY SWIFT! 👍
*/
import UIKit

//MARK: === CardID enum ===
/// CardID contains the 6 possible card values, and some convenience accessors.
enum CardID:Int {
    case Card1 = 1, Card2 = 2, Card3 = 4, Card4 = 8, Card5 = 16, Card6 = 32
    
    static let allValues = [Card1, Card2, Card3, Card4, Card5, Card6]
    
    func cardInfoArray()->[Int] {
        switch self {
        
        case .Card1: return [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59]
        case .Card2: return [2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,35,38,39,42,43,46,47,50,51,54,55,58,59]
        case .Card3: return [4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31,36,37,38,39,44,45,46,47,52,53,54,55,60]
        case .Card4: return [8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,40,41,42,43,44,45,46,47,56,57,58,59,60]
        case .Card5: return [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,48,49,50,51,52,53,54,55,56,57,58,59,60]
        case .Card6: return [32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60]
        
        }
    }

//    Doesn't seem to work

//        func cardTextForIndexPath(indexPath:NSIndexPath)->String {
//        if indexPath.row >= cardInfoArray().count {return ""}
//
//        let cardInfo = cardInfoArray()
//        return String(cardInfo[indexPath.row])
//    }
}

//MARK: - === AATDeckModel class ===
/// Models the deck of 6 cards, including what order it is in.
class AATDeckModel: NSObject {
    let randomOrderInstance = CardID.allValues.shuffle()
    
    static let sharedDeck = AATDeckModel()
    private override init() {}
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
