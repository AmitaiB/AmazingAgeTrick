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
        let list = Array(self)
        list.shuffle()
        return list
    }
}
