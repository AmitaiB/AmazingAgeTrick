//
//  FlatUIColorsExtension.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/6/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation
import FlatUIColors

// MARK: - FlatUIColors Extension
extension FlatUIColors {
    public static func randomFlatColor()->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
    
    //For some reason, not included in the pod, though it is in the pallette: https://flatuicolors.com/
    public static func flatOrangeColor(alpha: CGFloat = 1.0) -> OSColor! {return UIColor(red: 243, green: 156, blue: 18, alpha: alpha)}
    
    public static func randomFlatColorPair()->(UIColor, UIColor) {
        let colorPairs:[(colorA:UIColor, colorB:UIColor)] =
        [(FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor()),
            (FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor()),
            (FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor()),
            (FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor()),
            (FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor()),
            (FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor()),
            (FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor()),
            (FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor()),
            (FlatUIColors.cloudsColor(), FlatUIColors.silverColor()),
            (FlatUIColors.concreteColor(), FlatUIColors.asbestosColor())
        ]
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colorPairs.count)))
        return colorPairs[randomIndex]
    }
    
    public static func orderedFlatColor(ordinal:Int)->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        return colors[ordinal]
    }
    
    public static func pairedColorForColor(color:UIColor)->UIColor {
        let colorPairs:[(colorA:UIColor, colorB:UIColor)] =
        [(FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor()),
            (FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor()),
            (FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor()),
            (FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor()),
            (FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor()),
            (FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor()),
            (FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor()),
            (FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor()),
            (FlatUIColors.cloudsColor(), FlatUIColors.silverColor()),
            (FlatUIColors.concreteColor(), FlatUIColors.asbestosColor())
        ]
        
        var complementaryColor:UIColor = UIColor.whiteColor()
        for colorPair in colorPairs {
            if color == colorPair.colorA {complementaryColor = colorPair.colorB}
            if color == colorPair.colorB {complementaryColor = colorPair.colorA}
        }
        return complementaryColor
    }
    
    
    
    public static func pairedColorForColor(color:UIColor?)->UIColor {
        guard let kosherColor = color else {return UIColor.whiteColor()}
        return FlatUIColors.pairedColorForColor(kosherColor)
    }
    
}
//Extension Ends

