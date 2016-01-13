//
//  ABCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/7/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class ABCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    func setup() {
//        setupNaturalLookRotation() ???:Does this help, or does ZLSwipeableView take care of the natural look by itself?
        
        frame = CGRectInset(superView?.bounds, 25, 25)

        
        // Color
//        backgroundColor = UIColor.lightGrayColor()
        backgroundColor = UIColor(rgba: "#4A4F70")
        
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0
    }
    
    
    func setupNaturalLookRotation() {
        ///        -5° < x < 5° (by getting a random # from 0 to 10, subtracting 5)
        let randomDegree:Double = Double(Int(arc4random_uniform(UInt32(10))) - 5)
        self.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(randomDegree)))
    }
    
    func setupInsetCollectionView () {
        
    }
}

//MARK: === ABTrickCardView ===

class ABTrickCardView : ABCardView {
    private let cardModel:CardID
    var cardCollectionView:UICollectionView!
    
    init(forCardModel model:CardID) {
        print("the cardview cardRect is: \(cardRect)")
        cardModel = model
        super.init(frame:cardRect)
    }
    
    func setup() {

        
        cardCollectionView = AATCollectionView(forCardModel: cardModel)
        cardCollectionView.frame = CGRectInset(cardView.bounds, 12, 12)
        self.addSubview(cardCollectionView)
    }
}

//MARK: === ABResultsCardView === 

class ABResultsCardView :ABCardView {
    private let commonInset = 20
    var replayButton:UIButton
    weak var delegate:ABReplayButtonDelegate?
    
    init() {
        
    }
    
    func setup () {
        
    }
    
    func setupResultsLabel() {
        
    }
    
    func setupReplayButton() {
        replayButton = UIButton(type: .Custom)
        self.addSubview(replayButton)
        replayButton.imageView?.contentMode = .ScaleAspectFit
        replayButton.setImage(UIImage(named: "RePlay Button-red"), forState: .Normal)
        setupViewShadow(replayButton.layer)
        replayButton.addTarget(delegate, action: Selector("replayButtonTapped:"), forControlEvents: .TouchUpInside)
    }
    
    
    func configureViewWithAutolayout(view:UIView, anchoredTo orientation:ABAnchorDirection) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.removeConstraints(view.constraints)
        
        view.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: commonInset).active = true
        view.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -commonInset).active = true
        
        switch orientation {
        case .top:
            view.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: commonInset).active = true
        case .bottom:
            view.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -commonInset).active = true
        }
    }
    enum ABAnchorDirection: String { case top, bottom }
}

protocol ABReplayButtonDelegate {
    func replayButtonTapped(sender: UIButton!)
}


