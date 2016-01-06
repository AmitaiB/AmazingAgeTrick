//
//  String+Extensions.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/30/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation

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
}