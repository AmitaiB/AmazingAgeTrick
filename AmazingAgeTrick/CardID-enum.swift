//
//  CardID-enum.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/13/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

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
    
    func altColorForCardID()->UIColor {
        switch self {
            
        case .Card1: return UIColor(red:0.74, green:0.16, blue:0.16, alpha:1)
        case .Card2: return UIColor(red:0.13, green:0.52, blue:0.85, alpha:1)
        case .Card3: return UIColor(red:0.96, green:0.95, blue:0.16, alpha:1)
        case .Card4: return UIColor(red:0.37, green:0.63, blue:0.21, alpha:1)
        case .Card5: return UIColor(red:0.77, green:0.41, blue:0.14, alpha:1)
        case .Card6: return UIColor(red:0.45, green:0.13, blue:0.49, alpha:1)
            
        }
    }
    
    func cellImageForCardID()->UIImage? {
        switch self {
            
        case .Card1: return UIImage(named: "Oval 24-red")
        case .Card2: return UIImage(named: "Oval 24-orange")
        case .Card3: return UIImage(named: "Oval 24-green")
        case .Card4: return UIImage(named: "Oval 24-blue")
        case .Card5: return UIImage(named: "Oval 24-violet")
        case .Card6: return UIImage(named: "Oval 24-midnight")
        }
    }
}
