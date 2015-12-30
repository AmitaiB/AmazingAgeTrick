//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors
import performSelector_swift

class AATrickViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let card1 = produceCardView()

        /**
        TODO NEXT: 
        1) add a collectionView to a card so that it's visible.
        2) make the collectionView present the cardInfo.
        3) add a voting mechanism
        4) make swiping rotate to the next card
        5) keep a tally of the votes.
        6) Stop when all 6 cards have votes.
        7) Present the result, wow the user, offer to play again
        
        make the cards rotate a bit, randomly, so that you can see them when they are stacked one atop the other.
        
        - parameter animated: <#animated description#>
        */
        
        // Do any additional setup after loading the view.
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.setToolbarHidden(false, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func produceCardView()->ABSwipeableCardView {
        let cardView = ABSwipeableCardView(superView: view)
        cardView.backgroundColor = randomFlatColor()
        return cardView
    }
    
    func randomFlatColor()->UIColor {
        let colors:[String] = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.endIndex)))
        let sanitizedColorString = colors[randomIndex].stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "\(sanitizedColorString)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
