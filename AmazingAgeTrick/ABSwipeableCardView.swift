//
//  ABSwipeableCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit


class ABSwipeableCardView: UIView {
    
    
    var cardInfoKey:Int?
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originalPoint: CGPoint!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(superView: UIView) {
        let cardRect = CGRectInset(superView.frame, 40, 40)
        self.init(frame: cardRect)
        superView.addSubview(self)
    }
    
    //MARK: Private setup methods
    func setup() {
        setupCardStyle()
        setupGestureRecognizer()
        setupNaturalLookRotation()
    }
    
    func setupCardStyle() {
        // Color
        backgroundColor = UIColor.lightGrayColor()
        
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
    
    func setupGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("swiped:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    //MARK: Transforms
    
    func setupNaturalLookRotation() {
//        -5° < x < 5°
        let randomDegree:Double = Double(Int(arc4random_uniform(UInt32(10))) - 5)
        self.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(randomDegree)))
    }
    
    func swiped(gestureRecognizer: UIPanGestureRecognizer) {
        print("Swiped!", terminator: "")
        
        let 𝛥x:CGFloat = gestureRecognizer.translationInView(self).x
        let 𝛥y:CGFloat = gestureRecognizer.translationInView(self).y
        let screenWidth  :CGFloat = UIScreen.mainScreen().nativeBounds.width
        
        switch(gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            
        case UIGestureRecognizerState.Changed:
            let rotationStrength:CGFloat = min((𝛥x/screenWidth), 1)
            let rotationAngle:CGFloat = (2.0 * CGFloat(M_PI) * CGFloat(rotationStrength) / 16.0)
            let scaleStrenght:CGFloat = 1.0 - CGFloat(fabs(Float(rotationStrength))) / 4.0
            let scale:CGFloat = max(scaleStrenght, 0.93)
            
            self.center = CGPoint(x: self.originalPoint.x + 𝛥x, y: self.originalPoint.y + 𝛥y)
            let transform:CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform:CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            self.transform = scaleTransform
            
        case UIGestureRecognizerState.Ended:
            self.resetViewPositionAndTransformations()
            // TODO: Logic here.
            
        default:
            print("error default statement", terminator: "")
            
        }
    }
    
    func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.center = self.originalPoint
            self.transform = CGAffineTransformMakeRotation(0)
        }
    }
    
    //MARK: Private helper methods
    //    0 <= x < 2π
    func DegreesToRadians (value:Double) -> Double {
        var convertedValue = (value * M_PI / 180.0) % (2 * M_PI)
        convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 2 * M_PI
        return convertedValue
    }

    //    0 <= x < 360°
    func RadiansToDegrees (value:Double) -> Double {
        var convertedValue = (value * 180.0 / M_PI) % 360
        convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 360
        convertedValue = convertedValue == 360 ? 0 : convertedValue
        return convertedValue
    }
}
