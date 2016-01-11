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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canDisplayBannerAds = true
        originalContentView.backgroundColor = FlatUIColors.cloudsColor()
        setupTextView()
        setupStartButton()
    }
    
    
    func setupTextView() {
        instructionsTextView.backgroundColor = FlatUIColors.midnightBlueColor()
        instructionsTextView.textColor = FlatUIColors.silverColor()
        setupViewShadow(instructionsTextView.layer)
        instructionsTextView.layer.borderWidth = 7
        instructionsTextView.layer.borderColor = FlatUIColors.asbestosColor().CGColor
        instructionsTextView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        instructionsTextView.text = "Amazing Age Trick - Instructions\n\t1) For each card, select YES if your age is there, or NO otherwise.\n\t2) Then...that\'s it."
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
}

