//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class AATrickViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cardView = ABSwipeableCardView()
        view.addSubview(cardView)
        cardView.backgroundColor = UIColor.blueColor()
        cardView.frame = CGRectInset(view.bounds, 20, 20)

        
        // Do any additional setup after loading the view.
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.setToolbarHidden(false, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
