//
//  ViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

class AATMainViewController: UIViewController {

    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatUIColors.cloudsColor()
        setupTextView()
        setupStartButton()
    }
    
    
    func setupTextView() {
        instructionsTextView.backgroundColor = FlatUIColors.midnightBlueColor()
        instructionsTextView.textColor = FlatUIColors.silverColor()
        setupViewShadow(instructionsTextView.layer)
        instructionsTextView.layer.borderWidth = 7
        instructionsTextView.layer.borderColor = FlatUIColors.asbestosColor().CGColor
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

