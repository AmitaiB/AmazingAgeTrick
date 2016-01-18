//
//  ABResultsCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/17/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

//MARK: === ABResultsCardView ===

class ABResultsCardView :ABCardView, ABReplayButtonView {
    private let commonInset:CGFloat = 20
    var replayButton:UIButton = UIButton(type: .Custom)
    var resultsLabel:UILabel = UILabel()
    var delegate:ABReplayButtonDelegate?
    var resultRecord:Int? {
        didSet {
            if resultRecord == nil    { hideSubviews(true)  }
            else { setupResultsLabel(); hideSubviews(false) }
        }
    }
    
    init(forResults results:Int?) {
        super.init(frame: standardCardRect)
        resultRecord = results
        setupResultsCardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setupResultsCardView () {
        super.setup()
        setupResultsLabel()
        setupReplayButton()
        hideSubviews(true)
    }
    
    func setupResultsLabel() {
        for view in self.subviews {
            if view is UILabel { view.removeFromSuperview() }
        }
        
        
        ///        let labelRect = CGRectInset(bounds, 25, 25)??
//        let labelRect = CGRectInset(self.bounds, 35, 125)
        resultsLabel = UILabel()
        self.addSubview(resultsLabel)
//        resultsLabel.frame = labelRect
        
        // Autolayout
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsLabel.removeConstraints(resultsLabel.constraints)
        resultsLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 25).active = true
        resultsLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 15).active = true
        resultsLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -15).active = true
        resultsLabel.heightAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: 1.0/3.0).active = true
        
        
        resultsLabel.textAlignment = .Center
        resultsLabel.backgroundColor = FlatUIColors.greenSeaColor()
        
        if let textToDisplay = resultsLabelText() {
            resultsLabel.text = textToDisplay
        }

        resultsLabel.layer.cornerRadius = 10 //??
    }
    
    func setupReplayButton() {
        self.addSubview(replayButton)
        replayButton.imageView?.contentMode = .ScaleAspectFit
        replayButton.setImage(UIImage(named: "RePlay Button-red"), forState: .Normal)
        setupViewShadow(replayButton.layer)
        replayButton.addTarget(self, action: Selector("reportReplayButtonWasTapped:"), forControlEvents: .TouchUpInside)
        
        // Autolayout
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        replayButton.removeConstraints(replayButton.constraints)
        replayButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -25).active = true
        replayButton.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 15).active = true
        replayButton.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -15).active = true
        replayButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        
        
        replayButton.showsTouchWhenHighlighted = true
        replayButton.adjustsImageWhenHighlighted = true
    }
    
    
    func reportReplayButtonWasTapped(sender:UIButton!) {
        print("\(__FUNCTION__)")
        delegate?.replayButtonTapped(sender)
    }
    
    
    private func hideSubviews(trueOrFalse:Bool) {
        for view in subviews { view.hidden = trueOrFalse }
    }
    
    //    func setAllSubviewsHiddenTo(trueOrFalse:Bool, forView superView:UIView) {
    //        for view in superView.subviews { view.hidden = trueOrFalse }
    //    }
    
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
    
    
    func resultsLabelText()->String? {
        guard let result = resultRecord else { return nil }
//            let error = "Error in \(__FUNCTION__)"; print(error); return error
//        }
        
        var resultToDisplay = String("You are \(result) years of age!\n\n\nPlay again?")
        
        if result < 0 || result > 60 {
            resultToDisplay = "You are either 0 years old (or less), or over 60 years old. Either way, stop drooling on my screen!\n\n\nPlay again, without cheating this time?\n\n\n\n\nAww, heck, cheat all you want, I don't care, I'm just a robot slave anyway."
        }
        return resultToDisplay
    }
}


protocol ABReplayButtonView {
    var replayButton:UIButton { get }
}

protocol ABReplayButtonDelegate {
    func replayButtonTapped(sender: UIButton!)
}

func setupViewShadow(layer:CALayer) {
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.25
    layer.shadowOffset = CGSizeMake(0, 1.5)
    layer.shadowRadius = 4.0
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.mainScreen().scale
}
