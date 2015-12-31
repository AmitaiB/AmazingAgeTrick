//
//  UIColor+FlatUI_Swift.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/30/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

// Thanks to http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
extension UIColor {
    enum FlatUIColor:String {
        case turquoiseColor = "1ABC9C"
        case greenSeaColor = "16A085"
        case emerlandColor = "2ECC71"
        case nephritisColor = "27AE60"
        case peterRiverColor = "#3498DB"
        case belizeHoleColor = "2980B9"
        case amethystColor = "9B59B6"
        case wisteriaColor = "8E44AD"
        case wetAsphaltColor = "34495E"
        case midnightBlueColor = "2C3E50"
        case sunflowerColor = "F1C40F"
        case tangerineColor = "F39C12"
        case carrotColor = "E67E22"
        case pumpkinColor = "D35400"
        case alizarinColor = "E74C3C"
        case pomegranateColor = "C0392B"
        case cloudsColor = "ECF0F1"
        case silverColor = "BDC3C7"
        case concreteColor = "95A5A6"
        case asbestosColor = "7F8C8D"
    }
    
    func flatUIColor(color: FlatUIColor)->UIColor {
        return colorWithHexString(color.rawValue)
    }
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.length != 6) {
            return UIColor.grayColor()
        }
        
        var rString = cString.substringFromIndex(0).substringToIndex(2)
        var gString = cString.substringFromIndex(2).substringToIndex(2)
        var bString = cString.substringFromIndex(4).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner.localizedScannerWithString(rString).scanHexInt(&r)
        NSScanner.localizedScannerWithString(gString).scanHexInt(&g)
        NSScanner.localizedScannerWithString(bString).scanHexInt(&b)
        
        return UIColor(colorLiteralRed: Float(r) / Float(255.0), green: Float(g) / Float(255.0), blue: Float(b) / Float(255.0), alpha: 1)
    }
    
}


