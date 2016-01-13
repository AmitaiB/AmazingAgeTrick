//
//  ViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors
import iAd

class AATMainViewController: UIViewController {

    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var creditsSegueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canDisplayBannerAds = true
        originalContentView.backgroundColor = FlatUIColors.cloudsColor()
        setupTextView()
        setupStartButton()
//        createAutolayoutConstraints()
    }
    
    
    func setupTextView() {
        instructionsTextView.backgroundColor = FlatUIColors.midnightBlueColor()
        instructionsTextView.textColor = FlatUIColors.silverColor()
        setupViewShadow(instructionsTextView.layer)
        instructionsTextView.layer.borderWidth = 7
        instructionsTextView.layer.borderColor = FlatUIColors.asbestosColor().CGColor
        instructionsTextView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
//        instructionsTextView.text = " Amazing Age Trick - Instructions\n\n  1) For each card, select YES if your age appears on the card, or NO if it does not, or you just want to screw with the system because pranking soulless computers is what gets you up in the morning. Woo hoo.\n\n  2) Then...that\'s it."
        instructionsTextView.textContainer.lineBreakMode = .ByWordWrapping
        instructionsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setupStartButton() {
        startGameButton.backgroundColor = FlatUIColors.wisteriaColor()
        startGameButton.titleLabel?.textColor = FlatUIColors.peterRiverColor()
        startGameButton.layer.cornerRadius = 10.0
        setupViewShadow(startGameButton.layer)
    }
    
    func setupViewShadow(layer:CALayer) {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    func createAutolayoutConstraints() {
        let views = ["textV" : instructionsTextView, "startB" : startGameButton, "creditsB" : creditsSegueButton]
        for view in views.values { prepareForAutolayout(view) }
        
        let hTextViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textV]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let hStartButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[startB]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let hCreditsButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[creditsB]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let vAllViewsConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[textV]-100-[startB]-[creditsB]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(hTextViewConstraints + hStartButtonConstraints + hCreditsButtonConstraints + vAllViewsConstraints)
    }
    
    func prepareForAutolayout(view:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.removeConstraints(view.constraints)
    }
    
    
}


/**
UIColor+Hex, now Swift.
Convenience method for creating autoreleased color using RGBA hex string.

var strokeColor = UIColor(rgba: "#ffcc00").CGColor // Solid color

var fillColor = UIColor(rgba: "#ffcc00dd").CGColor // Color with alpha

var backgroundColor = UIColor(rgba: "#FFF") // Supports shorthand 3 character representation

var menuTextColor = UIColor(rgba: "#013E") // Supports shorthand 4 character representation (with alpha)

var hexString = UIColor.redColor().hexString(false) // "#FF0000"
*/

/*
363951 = Dark Blue1 for collectionViewCell background
303348 = Dark Blue2 (aka Darker Blue) "    "
F4F4F8 = Sublte Grey to contrast with white


*/