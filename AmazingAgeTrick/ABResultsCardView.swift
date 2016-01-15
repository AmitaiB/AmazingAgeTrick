//
//  ABResultsCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/14/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

//MARK: === ABResultsCardView ===

class ABResultsCardView: ABCardView, ABReplayButtonView {
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
        ///        let labelRect = CGRectInset(bounds, 25, 25)??
        let labelRect = CGRectInset(self.bounds, 35, 125)
        resultsLabel = UILabel()
        self.addSubview(resultsLabel)
        resultsLabel.frame = labelRect
        resultsLabel.textAlignment = .Center
        resultsLabel.backgroundColor = FlatUIColors.turquoiseColor()
        
        resultsLabel.text = resultsLabelText()
    }
    
    func setupReplayButton() {
        self.addSubview(replayButton)
        replayButton.imageView?.contentMode = .ScaleAspectFit
        replayButton.setImage(UIImage(named: "RePlay Button-red"), forState: .Normal)
        setupViewShadow(replayButton.layer)
        replayButton.addTarget(self, action: Selector("reportReplayButtonWasTapped:"), forControlEvents: .TouchUpInside)
    }
    
    
    func reportReplayButtonWasTapped(sender:UIButton!) {
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
    
    
    func resultsLabelText()->String {
        guard let result = resultRecord else { let error = "Error in \(__FUNCTION__)"; print(error); return error }
        
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