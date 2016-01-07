//
//  ABSwipeableCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
/**
 Gesture out, if triggered, then Animate out, [flip?], sendToBack, Animate back in.
 
 */

class ABSwipeableCardView: UIView {
    //MARK: - Properties
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originalPoint: CGPoint?
    var originalFrame: CGRect?

    private var snapBehavior:UISnapBehavior!
    private var pushBehavior:UIPushBehavior!

    private var animator:UIDynamicAnimator
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
    }
    
    //MARK: Setup's little helpers
    func setup() {
        setupCardStyle()
        setupPanGesture()
        setupNaturalLookRotation()
        animator = UIDynamicAnimator(referenceView: self)
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
    
    func snapViewToPoint(point: CGPoint) {
        guard let pointOfYesReturn = originalPoint else { return }
        snapBehavior = UISnapBehavior(item: self, snapToPoint: pointOfYesReturn)
        snapBehavior!.damping = 0.75
        animator.addBehavior(snapBehavior)
    }
    
    
    // == Transforms ==
    
    func setupNaturalLookRotation() {
        ///        -5° < x < 5° (by getting a random # from 0 to 10, subtracting 5)
        let randomDegree:Double = Double(Int(arc4random_uniform(UInt32(10))) - 5)
        self.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(randomDegree)))
    }
    
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        // Old stuff
        print("Swiped!", terminator: "")
        let 𝛥x:CGFloat = gestureRecognizer.translationInView(self).x
        let 𝛥y:CGFloat = gestureRecognizer.translationInView(self).y
        let screenWidth  :CGFloat = UIScreen.mainScreen().nativeBounds.width
        
        // New stuff
        let location = gestureRecognizer.locationInView(self)
        let translation = gestureRecognizer.translationInView(self)
        let velocity = gestureRecognizer.velocityInView(self)
        
        let movement:Movement = Movement(location: location, translation: translation, velocity: velocity)
        
        switch gestureRecognizer.state {
        case .Began:
            originalPoint = center
            originalFrame = frame
            
        case .Changed:
            let rotationStrength:CGFloat = min((𝛥x/screenWidth), 1)
            let rotationAngle:CGFloat = (2.0 * CGFloat(M_PI) * CGFloat(rotationStrength) / 16.0)
            let scaleStrenght:CGFloat = 1.0 - CGFloat(fabs(Float(rotationStrength))) / 4.0
            let scale:CGFloat = max(scaleStrenght, 0.93)
            
            guard let originalPoint = self.originalPoint else { break }
            center = CGPoint(x: originalPoint.x + 𝛥x, y: originalPoint.y + 𝛥y)
            let myTransform:CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform:CGAffineTransform = CGAffineTransformScale(myTransform, scale, scale)
            transform = scaleTransform
            
        case .Ended:
            if !CGRectIntersectsRect(originalFrame!, frame) {
                ///Advance to the next view
            }
        
        
        case .Cancelled:
            if let pointOfYesReturn = originalPoint {
                snapViewToPoint(pointOfYesReturn)
            }
//            resetViewPositionAndTransformationsInFront(orInBack: false)
            // TODO: Logic here.
            
        default:
            print("error default statement", terminator: "")
        
        }
    }
    
    
//    func snapView(point: CGPoint) {
//        snapBehavior = UISnapBehavior(item: self, snapToPoint: originalPoint)
//        snapBehavior!.damping = 0.75
//        animator.addBehavior(snapBehavior)
//    }
//    
//    func unsnapView() {
//        guard let snapBehavior = snapBehavior else { return }
//        animator.removeBehavior(snapBehavior)
//    }
    
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
    
    
    
    //MARK: Private helper methods
    ///    0 <= x < 2π
    func DegreesToRadians (value:Double) -> Double {
        var convertedValue = (value * M_PI / 180.0) % (2 * M_PI)
        convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 2 * M_PI
        return convertedValue
    }

    ///    0 <= x < 360°
    func RadiansToDegrees (value:Double) -> Double {
        var convertedValue = (value * 180.0 / M_PI) % 360
        convertedValue = convertedValue > 0 ? convertedValue : convertedValue + 360
        convertedValue = convertedValue == 360 ? 0 : convertedValue
        return convertedValue
    }
}

public struct Movement {
    let location: CGPoint
    let translation: CGPoint
    let velocity: CGPoint
}

extension CGPoint {
    
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    var normalized: CGPoint {
        return CGPoint(x: x / magnitude, y: y / magnitude)
    }
    
    var magnitude: CGFloat {
        return CGFloat(sqrtf(powf(Float(x), 2) + powf(Float(y), 2)))
    }
    
    static func areInSameTheDirection(p1: CGPoint, p2: CGPoint) -> Bool {
        
        func signNum(n: CGFloat) -> Int {
            return (n < 0.0) ? -1 : (n > 0.0) ? +1 : 0
        }
        
        return signNum(p1.x) == signNum(p2.x) && signNum(p1.y) == signNum(p2.y)
    }
    
}
