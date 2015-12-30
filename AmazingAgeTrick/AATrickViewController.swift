//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

class AATrickViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cardView = ABSwipeableCardView(superView: self.view)
        cardView.backgroundColor = UIColor.blueColor()


        // Do any additional setup after loading the view.
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.setToolbarHidden(false, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dealCard()->ABSwipeableCardView {
        let card = ABSwipeableCardView(superView: view)
        card.backgroundColor =
    }
    
    func randomFlatColor()->UIColor {
        let colors:[String] = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.endIndex)))
        let sanitizedColorString = colors[randomIndex].stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "\(sanitizedColorString)Color"
        return UIColor
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
