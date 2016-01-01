//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

class AATrickViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellReuseID:String = "cellReuseID"
    
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
        cardView.backgroundColor = FlatUIColors.randomFlatColor()
        let collectionView = getCollectionView()
        cardView.addSubview(collectionView)
        collectionView.frame = CGRectInset(cardView.bounds, 20, 20)
        return cardView
    }
    
    func getCollectionView()->UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.estimatedItemSize = CGSizeMake(30, 30)
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:cellReuseID)
        collectionView.backgroundColor = FlatUIColors.randomFlatColor()
        return collectionView
    }
    
    //TODO: Refactor with the new extensions
    
    // MARK: === UICollectionView dataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseID, forIndexPath: indexPath)
        cell.backgroundColor = FlatUIColors.randomFlatColor()
        return cell
    }
}

extension FlatUIColors {
    public static func randomFlatColor()->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
}

