//
//  ViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors
///import iAd

class AATMainViewController: UIViewController {

    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var creditsSegueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///        self.canDisplayBannerAds = false
        originalContentView.backgroundColor = FlatUIColors.cloudsColor()
        setupTextView()
        setupStartButton()
        setupCreditsSegueButton()
    }
    
    func setupCreditsSegueButton() {
        
        creditsSegueButton.sizeToFit()
    }
    
    
    func setupTextView() {
        instructionsTextView.editable = true
        instructionsTextView.backgroundColor = FlatUIColors.midnightBlueColor()
        instructionsTextView.textColor = FlatUIColors.peterRiverColor()
        setupViewShadow(instructionsTextView.layer)
        instructionsTextView.layer.borderWidth = 2
        instructionsTextView.layer.borderColor = FlatUIColors.sunflowerColor().CGColor
        instructionsTextView.contentInset = UIEdgeInsets.init(top: -30, left: 10, bottom: 10, right: 10)
        instructionsTextView.text = "\n Amazing Age Trick\n Instructions\n\n Tap YES/NO if your age does/does not appear on the card, THEN SWIPE TO THE NEXT CARD! 😃"
        instructionsTextView.textContainer.lineBreakMode = .ByWordWrapping
        instructionsTextView.textContainerInset = UIEdgeInsets(top: -10, left: 3, bottom: 3, right: 3)
        instructionsTextView.editable = false
//        instructionsTextView.font = UIFont(descriptor: , size: <#T##CGFloat#>)
    }
    
    func setupStartButton() {
        startGameButton.backgroundColor = FlatUIColors.wisteriaColor()
        startGameButton.titleLabel?.textColor = FlatUIColors.peterRiverColor()
        startGameButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        startGameButton.layer.cornerRadius = 10.0
        setupViewShadow(startGameButton.layer)
    }
    /*
    func setupViewShadow(layer:CALayer) {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    */
    
    func createAutolayoutConstraints() {
        let views = ["textV" : instructionsTextView, "startB" : startGameButton, "creditsB" : creditsSegueButton]
        let metrics = ["creditsPadding" : creditsButtonPadding(creditsSegueButton)]
        for view in views.values { prepareForAutolayout(view) }
        
        let hTextViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textV]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let hStartButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[startB]-20-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let hCreditsButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-creditsPadding-[creditsB]-creditsPadding-|", options: .AlignAllCenterX, metrics: metrics, views: views)
        let vAllViewsConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[textV]-100-[startB]-[creditsB]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(hTextViewConstraints + hStartButtonConstraints + hCreditsButtonConstraints + vAllViewsConstraints)
    }
    
    func prepareForAutolayout(view:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.removeConstraints(view.constraints)
    }
    
    func creditsButtonPadding(button:UIButton)->NSNumber {
        let totalPadding = UIScreen.mainScreen().bounds.width - button.intrinsicContentSize().width
        let paddingNumber: NSNumber = Float(totalPadding) / 2.0
        return paddingNumber
    }
    
    
}


