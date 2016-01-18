//
//  ABTrickCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/17/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

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
