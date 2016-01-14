//
//  ABSwipeableCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
/**
My own implementation, tossed in favor of ZL
 
 */

class ABSwipeableCardView: UIView {
    //MARK: - Properties
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originalPoint: CGPoint?
    var originalFrame: CGRect?

    private var snapBehavior:UISnapBehavior!
    private var pushBehavior:UIPushBehavior!

    private var animator:UIDynamicAnimator?
    /// Why this???:
    private weak var swipeableView:ABSwipeableCardView?
    
    //MARK: Init Methods

    
     override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(superView: UIView) {
        let cardRect = CGRectInset(superView.frame, 20, 20)
        self.init(frame: cardRect)
        superView.addSubview(self)
        setUpAnimator()
    }
    
    //MARK: Setup's little helpers
    func setup() {
        setupCardStyle()
        setupPanGesture()
        setupNaturalLookRotation()
    }
    
    func setUpAnimator() {
        animator = UIDynamicAnimator(referenceView: self)
//        if let superCenter = superview?.center {
//            addSnapToPoint(superCenter)
//        }
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
    
    func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func addSnapToPoint(point: CGPoint) {
        guard let pointOfYesReturn = originalPoint else { return }
        snapBehavior = UISnapBehavior(item: self, snapToPoint: pointOfYesReturn)
        snapBehavior!.damping = 0.75
        
        animator!.addBehavior(snapBehavior)
        
//        if let myAnimator = animator {
//            myAnimator.addBehavior(snapBehavior)
//        }
    }
    
    
    // == Transforms ==
    
    func setupNaturalLookRotation() {
        ///        -5° < x < 5° (by getting a random # from 0 to 10, subtracting 5)
        let randomDegree:Double = Double(Int(arc4random_uniform(UInt32(10))) - 5)
        self.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(randomDegree)))
    }
    
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        // Old stuff
        print("Swiped!", terminator: "")
        let 𝛥x:CGFloat = gesture.translationInView(self).x
        let 𝛥y:CGFloat = gesture.translationInView(self).y
        let screenWidth  :CGFloat = UIScreen.mainScreen().nativeBounds.width
        
        // New stuff
        /*
        let location = gestureRecognizer.locationInView(self)
        let translation = gestureRecognizer.translationInView(self)
        let velocity = gestureRecognizer.velocityInView(self)
        
        let movement:Movement = Movement(location: location, translation: translation, velocity: velocity)
        */
        
        switch gesture.state {
        case .Began:
            originalPoint = center
//            originalPoint = self.convertPoint(center, toView: superview)
            originalFrame = frame
            
        case .Changed:
            let rotationStrength:CGFloat = min((𝛥x/screenWidth), 1)
            let rotationAngle:CGFloat = (2.0 * CGFloat(M_PI) * CGFloat(rotationStrength) / 16.0)
            let scaleStrenght:CGFloat = 1.0 - CGFloat(fabs(Float(rotationStrength))) / 4.0
            let scale:CGFloat = max(scaleStrenght, 0.93)
            
            guard let originalPoint = originalPoint else { break }
            center = CGPoint(x: originalPoint.x + 𝛥x, y: originalPoint.y + 𝛥y)
            
            let myTransform:CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform:CGAffineTransform = CGAffineTransformScale(myTransform, scale, scale)
            transform = scaleTransform
            
            
        case .Ended:
            let smallerTarget = CGRectInset(originalFrame!, 65, 65)
            if !CGRectIntersectsRect(smallerTarget, frame) {
                print("Advance to the next view here!")
                ///Advance to the next view
            }
        
//            resetViewPositionAndTransformations()
//            resetCardView()
            
//            addSnapToPoint(originalPoint!)
            addSnapToPoint(CGPointZero)
        case .Cancelled:
//            resetViewPositionAndTransformations()
//            resetCardView()
            
            addSnapToPoint(CGPointZero)
            
        
        default:
            print("error default statement", terminator: "")
        
        }
    }
    
    func resetCardView() {
        guard let unwrappedPoint = originalPoint else { return }
        animator?.removeBehavior(snapBehavior)
        snapBehavior = UISnapBehavior(item: self, snapToPoint: unwrappedPoint)
    }
    
    func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2) { () -> Void in
            guard let originalPoint = self.originalPoint else { return }
            self.center = originalPoint
            self.transform = CGAffineTransformMakeRotation(0)
        }
        
    }
    
    func shouldSwipeAdvanceCards(movement: Movement)->Bool {
        let translation = movement.translation
        let velocity = movement.velocity
        let bounds  = self.bounds
        let minTranslationInPercent:CGFloat = 0.25 //custimizable
        let minVelocityInPointsPerSecond:CGFloat = 750
        
        func areTranslationAndVelocityInTheSameDirection()->Bool {
            return CGPoint.areInSameTheDirection(translation, p2: velocity)
        }
        
        func isTranslationLargeEnough() ->Bool {
            return abs(translation.x) > minTranslationInPercent * bounds.width ||
            abs(translation.y) > minTranslationInPercent * bounds.height
        }
        
        func isVelocityLargeEnough() -> Bool {
            return velocity.magnitude > minVelocityInPointsPerSecond
        }
        
        return areTranslationAndVelocityInTheSameDirection() && (isTranslationLargeEnough() || isVelocityLargeEnough())
    }
    
}
    
