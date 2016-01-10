//
//  Extensions.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/30/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

extension String
{
    var length: Int {
        get {return self.characters.count}
    }
    
    func contains(s: String) -> Bool
    {
        return (self.rangeOfString(s) != nil) ? true : false
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character {
        get {
            let index = startIndex.advancedBy(i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String
    {
        let chars = self.componentsSeparatedByString("")
        var substring:String = ""
        for idx in startIndex ..< length {
            substring += chars[idx]
        }
        
        return substring
    }
    
    func substringToIndex(intIndex:Int)->String {
        let index: String.Index = startIndex.advancedBy(intIndex)
        return substringToIndex(index)
    }

    func substringFromIndex(intIndex:Int)->String {
        let index: String.Index = startIndex.advancedBy(intIndex)
        return substringFromIndex(index)
    }

    
    func indexOf(target: String) -> Int
    {
        let range = self.rangeOfString(target)
        if let range = range {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
    
    private var vowels: [String]
        {
        get
        {
            return ["a", "e", "i", "o", "u"]
        }
    }
    
    private var consonants: [String]
        {
        get
        {
            return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
        }
    }
    
    func pluralize(count: Int) -> String
    {
        if count == 1 {
            return self
        } else {
            let lastChar = self.subString(self.length - 1, length: 1)
            let secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0...self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercaseString == "s" || (lastChar.lowercaseString == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0...self.length]
                suffix = "es"
            } else {
                prefix = self[0...self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercaseString ? suffix : suffix.uppercaseString)
        }
    }
    func toInt() -> Int?
    {
        let cleanString = self.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return Int(cleanString)
    }
    
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        let startRange = self.startIndex.advancedBy(startIndex)
        
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    /*
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
    var error: NSError?
    var exp = NSRegularExpression(pattern: regex, options: options)
    
    
    if let error = error {
    print(error.description)
    }
    var matchCount = exp.numberOfMatchesInString(self, options: nil, range: NSMakeRange(0, self.length))
    return matchCount > 0
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]
    {
    var error: NSError?
    var exp = NSRegularExpression(pattern: regex, options: options, error: &error)
    
    if let error = error {
    println(error.description)
    }
    var matches = exp.matchesInString(self, options: nil, range: NSMakeRange(0, self.length))
    return matches as [NSTextCheckingResult]
    }
    */
    

    }






//MARK: Private helper methods
///    0 <= x < 2π
func DegreesToRadians (value:Double) -> Double {
    var convertedValue = (value * M_PI / 180.0) % (2 * M_PI)
    convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 2 * M_PI
    return convertedValue
}

///    0 <= x < 360°
func RadiansToDegrees (value:Double) -> Double {
    var convertedValue = (value * 180.0 / M_PI) % 360
    convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 360
    convertedValue = convertedValue == 360 ? 0 : convertedValue
    return convertedValue
}


public struct Movement {
    let location: CGPoint
    let translation: CGPoint
    let velocity: CGPoint
}

extension CGPoint {
    
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    var normalized: CGPoint {
        return CGPoint(x: x / magnitude, y: y / magnitude)
    }
    
    var magnitude: CGFloat {
        return CGFloat(sqrtf(powf(Float(x), 2) + powf(Float(y), 2)))
    }
    
    static func areInSameTheDirection(p1: CGPoint, p2: CGPoint) -> Bool {
        
        func signNum(n: CGFloat) -> Int {
            return (n < 0.0) ? -1 : (n > 0.0) ? +1 : 0
        }
        
        return signNum(p1.x) == signNum(p2.x) && signNum(p1.y) == signNum(p2.y)
    }
}


