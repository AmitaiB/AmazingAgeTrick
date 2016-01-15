//
//  ABCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/7/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

//FIXME: ReplayButton not showing. After that, + 15min to make the navigation bars pretty, and we submit to the app store.

import UIKit
import FlatUIColors

let standardCardRect = CGRectInset(UIScreen.mainScreen().bounds, 25, 25)

class ABCardView: UIView {
    
    override init(frame: CGRect = standardCardRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        ///TODO: Make each collectionview insibile until the vote of the view in front of it.
        backgroundColor = UIColor(rgba: "#4A4F70")
//        backgroundColor = UIColor.clearColor()
        setupViewShadow(layer)
        layer.cornerRadius = 10.0
        
        //CLEAN: Never gets called, I think...
        if let sView = superview {
            frame = CGRectInset(sView.bounds, 25, 25)
        }
    }
    
    /**
    CLEAN: Not needed anymore
    */
    /**
    func setupNaturalLookRotation() {
        ///        -5° < x < 5° (by getting a random # from 0 to 10, subtracting 5)
        let randomDegree:Double = Double(Int(arc4random_uniform(UInt32(10))) - 5)
        self.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(randomDegree)))
    }
    */
}

//MARK: === ABTrickCardView ===

class ABTrickCardView : ABCardView {
    private let cardModel:CardID
    var cardCollectionView = AATCollectionView()
    
    init(forCardModel model:CardID) {
        cardModel = model
        super.init(frame: standardCardRect)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        cardModel = CardID.Card1
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        
        cardCollectionView = AATCollectionView(forCardModel: cardModel)
        cardCollectionView.frame = CGRectInset(bounds, 12, 12)
        addSubview(cardCollectionView)
    }
}

/**
private func setupViewShadow(layer:CALayer) {
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.25
    layer.shadowOffset = CGSizeMake(0, 1.5)
    layer.shadowRadius = 4.0
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.mainScreen().scale
}
*/

