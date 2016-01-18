//
//  ABCardView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/7/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

//FIXME: ReplayButton not showing. After that, + 15min to make the navigation bars pretty, and we submit to the app store.

import UIKit
import FlatUIColors

let standardCardRect = CGRectInset(UIScreen.mainScreen().bounds, 25, 25)

class ABCardView: UIView {
    
    override init(frame: CGRect = standardCardRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        ///TODO: Make each collectionview insibile until the vote of the view in front of it.
        backgroundColor = colorForCardBack()
//        backgroundColor = UIColor.clearColor()
        setupViewShadow(layer)
        layer.cornerRadius = 10.0
        
        //CLEAN: Never gets called, I think...
        if let sView = superview {
            frame = CGRectInset(sView.bounds, 25, 25)
        }
    }
    
    func colorForCardBack()->UIColor {
        return UIColor.init(rgba: "#4A4F70", defaultColor: UIColor.darkGrayColor())
    }
}





