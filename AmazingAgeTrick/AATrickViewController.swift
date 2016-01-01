//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

class AATrickViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellReuseID:String = "cellReuseID"
    let footerReuseID:String = "footerReuseID"
    var switcher:UISwitch = UISwitch()

    private let numCols = 4
    private let numRows = 8
    let deck = AATDeckModel.sharedDeck

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck.resetDeck()
        var card1 = produceCardView()
        


        /**
        TODO NEXT: 
        ✅1) add a collectionView to a card so that it's visible.
        ✅2) make the collectionView present the cardInfo.
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
        let collectionView = getCollectionView()
        let voteSwitch = getVoteSwitch()
        
        cardView.backgroundColor = FlatUIColors.randomFlatColor()
        cardView.addSubview(collectionView)
        cardView.addSubview(voteSwitch)
        
//        collectionView.frame = CGRectInset(cardView.bounds, 15, 15)
        
        // Autolayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.removeConstraints(collectionView.constraints)
        voteSwitch.translatesAutoresizingMaskIntoConstraints = false
        voteSwitch.removeConstraints(voteSwitch.constraints)

        
        collectionView.leadingAnchor.constraintEqualToAnchor(cardView.leadingAnchor, constant: 10).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(cardView.trailingAnchor, constant: -10).active = true
        collectionView.topAnchor.constraintEqualToAnchor(cardView.topAnchor, constant: 10).active = true
        
        collectionView.bottomAnchor.constraintEqualToAnchor(voteSwitch.topAnchor, constant: -10).active = true
        
        voteSwitch.leadingAnchor.constraintEqualToAnchor(cardView.leadingAnchor).active = true
        voteSwitch.trailingAnchor.constraintEqualToAnchor(cardView.trailingAnchor).active = true
        voteSwitch.bottomAnchor.constraintEqualToAnchor(cardView.bottomAnchor, constant: -10).active = true
        voteSwitch.heightAnchor.constraintEqualToConstant(voteSwitch.intrinsicContentSize().height).active = true
        
        drawNewCardForNewCardView()
        return cardView
    }
    
    func drawNewCardForNewCardView() {
        deck.drawCardFromDeck()
    }
    
    func getVoteSwitch()->IGSwitch {
        let voteSwitch = IGSwitch()
        voteSwitch.titleLeft = "Age NOT Here"
        voteSwitch.titleRight = "YES, It's Here!"
        return voteSwitch
    }
    
    func getCollectionView()->UICollectionView {
        // Layout setup
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.estimatedItemSize = CGSizeMake(30, 30)
        
        // CollectionView setup
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:cellReuseID)
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseID)
        
        collectionView.backgroundColor = FlatUIColors.randomFlatColor()
        
        
        return collectionView
    }
    
    // MARK: === UICollectionView DataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCols * numRows
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseID, forIndexPath: indexPath)
        cell.backgroundColor = FlatUIColors.randomFlatColor()
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        if kind != UICollectionElementKindSectionFooter {return UICollectionReusableView()}
//        var footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseID, forIndexPath: indexPath)
////            [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        
//        
//    }
    
    
    // MARK: === UICollectionViewDelegateFlowLayout ===
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSizeMake(30, 30)}
        
        let xTotalWhitespace = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * CGFloat(numCols - 1)
        let yTotalWhitespace = layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing * CGFloat(numRows - 1)
        
        let availableWidth  = Int(collectionView.bounds.width  - xTotalWhitespace)
        let availableHeight = Int(collectionView.bounds.height - yTotalWhitespace)
        
        let itemHeight = availableHeight / numRows
        let itemWidth  = availableWidth / numCols
        let itemSize = CGSizeMake(CGFloat(itemWidth), CGFloat(itemHeight))
        //        let itemSquareDimension = min(itemWidth, itemHeight)
        //        let itemSize = CGSizeMake(CGFloat(itemSquareDimension), CGFloat(itemSquareDimension))
        
        return itemSize
    }
    
    // MARK: == Private helper methods ==
    func configureCell(cell:UICollectionViewCell, forIndexPath indexPath:NSIndexPath) {
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "transparent-black-circle-medium")
        
        cell.contentView.autoresizesSubviews = true
        cell.contentView.addSubview(imageView)
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.backgroundColor = UIColor.clearColor()
        label.text = numberForIndexPath(indexPath)
        label.textAlignment = .Center
        imageView.addSubview(label)
    }
    
    func numberForIndexPath(indexPath:NSIndexPath)->String {
        guard let topCardCount = deck.topCard?.count else {return "Err1"}
        guard let topCard = deck.topCard else {return "Err2"}

        if indexPath.row >= topCardCount {return "//"}
        return String(topCard[indexPath.row])
    }
    
    //ViewController Ends here
}

extension FlatUIColors {
    public static func randomFlatColor()->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
}

