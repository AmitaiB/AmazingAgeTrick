//
//  CreditsViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/10/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var creditsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        creditsTextView.text = "Acknowledgements\n#Icons were provided by Icons8 (https://icons8.com/) in return for providing this message.\n\n#ZLSwipeableViewSwift and ReactiveUI is under the MIT License by Zhixuan Lai of LA, both available through the Cocoapods project (www.cocoapods.org).\n\n"
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
