//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

/**
TODO: Refactor deck, load all at once.
*/

/**
TODO NEXT:
✅1) add a collectionView to a card so that it's visible.
✅2) make the collectionView present the cardInfo.
✅3) add a voting mechanism
✅4a) generate all 6 cards, piled atop one another,
✅ Curent Task: Modify produceCardView to take a CardID somewhere ===
✅4a.5) slightly rotated
4b) make swiping rotate to the next card
5) keep a **visual** tally of the votes.
6) Stop when all 6 cards have votes.
7) Present the result, wow the user, offer to play again

make the cards rotate a bit, randomly, so that you can see them when they are stacked one atop the other.

- parameter animated: <#animated description#>
*/

import UIKit
import FlatUIColors

class AATrickViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // Properties
    private let cellReuseID:String = "cellReuseID"
    private let numCols = 4
    private let numRows = 8

    // Objects
    //Model
    let deck = AATDeckModel.sharedDeck
    
    //Views
    var cardViews = [CardID:ABSwipeableCardView]()
    
    //Controller-Logic
    var voteTally = [Int:Bool]()
    private var currentCardKey:CardID?
    
    enum ButtonCellRow:Int {
        case YesButton = 30
        case NoButton  = 31
    }
    
    enum NumInfo:Int {case noNumber}
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        deck.reset()
        let randomizedCardKeys = Array(deck.cards.keys).randomizeElements()

        for aCardID in randomizedCardKeys {
            produceCardView(aCardID)
        }
        
        print("cardViews.count = \(cardViews.count)")
        
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Setup helper functions
    /**
    Produces a 'blank' cardView with a collectionView ready to be filled with data,
    adding it to the superView.
    
    - returns: ABSwipeableCardView
    */
    func produceCardView(cardKey:CardID)->ABSwipeableCardView {
        // CollectionView
        currentCardKey = cardKey
        let collectionView = getCollectionView(currentCardKey)

        // CardView
        let cardView = ABSwipeableCardView(superView: view)
        cardView.backgroundColor = FlatUIColors.randomFlatColor()
        cardView.addSubview(collectionView)
        collectionView.frame = CGRectInset(cardView.bounds, 12, 12)

        if let unwrappedCardKey = currentCardKey {
            cardViews[unwrappedCardKey] = cardView
        }
        
        return cardView
    }
    
    func getCollectionView(currentCardKey:CardID?)->UICollectionView {
        if currentCardKey == nil {return UICollectionView()}
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.sectionInset            = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.estimatedItemSize       = CGSizeMake(30, 30)
        
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:cellReuseID)
        collectionView.backgroundColor = FlatUIColors.randomFlatColor()
        collectionView.allowsSelection = true
        return collectionView
    }
    
    // MARK: === UICollectionView DataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCols * numRows
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseID, forIndexPath: indexPath)
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    //MARK: == UICollectionView Delegate ===
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == ButtonCellRow.YesButton.rawValue ||
            indexPath.row == ButtonCellRow.NoButton.rawValue {
            return true
        }
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue: vote(true)
        case ButtonCellRow.NoButton.rawValue : vote(false)
        default: break
        }
    }
    
    // change background color when user touches cell
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = FlatUIColors.pairedColorForColor(cell?.backgroundColor)
        setViewBackgroundColorToCell(cell)
    }
    
    // change background color back when user releases touch
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = FlatUIColors.pairedColorForColor(cell?.backgroundColor)
        setViewBackgroundColorToCell(cell) // <--Is this even necessary?
    }
    
    
    //MARK: Private helper functions
    func setViewBackgroundColorToCell(cell:UICollectionViewCell?) {
        guard let unwrappedCardKey = currentCardKey      else {  return  }
        guard let cardView = cardViews[unwrappedCardKey] else {  return  }
        cardView.backgroundColor = cell?.backgroundColor
    }
    
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
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        imageView.addSubview(label)
        
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue:
            label.text = "YES"
            cell.backgroundColor = FlatUIColors.emeraldColor()
        case ButtonCellRow.NoButton.rawValue:
            label.text = "NO"
            cell.backgroundColor = FlatUIColors.pomegranateColor()
        default:
            label.text = numberForIndexPath(indexPath)
            cell.backgroundColor = FlatUIColors.orderedFlatColor(indexPath.row * 2 % 20)
            
            ///TODO: Make colors pretty!
            //            cell.backgroundColor = FlatUIColors.randomFlatColor()
        }
        
        
    }
    
    func numberForIndexPath(indexPath:NSIndexPath)->String {
        guard let unwrappedCardKey = currentCardKey else {return ""}
        guard let currentCardInfo:[Int] = deck[unwrappedCardKey] else {return ""}
        
        var paddedCardInfo = currentCardInfo
        while paddedCardInfo.count < (numCols * numRows) {
            paddedCardInfo.append(NumInfo.noNumber.rawValue)
        }
        
        if paddedCardInfo[indexPath.row] == NumInfo.noNumber.rawValue {  return ""  }
        else {  return String(paddedCardInfo[indexPath.row])  }
    }
    
    
    func vote(vote:Bool) {
        //TODO: Vote functionality here.
        print(voteTally)
    }
    
    //ViewController Ends here
}



// MARK: - FlatUIColors Extension
extension FlatUIColors {
    public static func randomFlatColor()->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
    
    //For some reason, not included in the pod, though it is in the pallette: https://flatuicolors.com/
    public static func flatOrangeColor(alpha: CGFloat = 1.0) -> OSColor! {return UIColor(red: 243, green: 156, blue: 18, alpha: alpha)}
    
    public static func randomFlatColorPair()->(UIColor, UIColor) {
        let colorPairs:[(colorA:UIColor, colorB:UIColor)] =
        [(FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor()),
            (FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor()),
            (FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor()),
            (FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor()),
            (FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor()),
            (FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor()),
            (FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor()),
            (FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor()),
            (FlatUIColors.cloudsColor(), FlatUIColors.silverColor()),
            (FlatUIColors.concreteColor(), FlatUIColors.asbestosColor())
        ]
        let randomIndex:Int = Int(arc4random_uniform(UInt32(colorPairs.count)))
        return colorPairs[randomIndex]
    }
    
    public static func orderedFlatColor(ordinal:Int)->UIColor {
        let colors = [FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor(), FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor(), FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor(), FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor(), FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor(), FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor(), FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor(), FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor(), FlatUIColors.cloudsColor(), FlatUIColors.silverColor(), FlatUIColors.concreteColor(), FlatUIColors.asbestosColor()]
        
        return colors[ordinal]
    }
    
    public static func pairedColorForColor(color:UIColor)->UIColor {
        let colorPairs:[(colorA:UIColor, colorB:UIColor)] =
        [(FlatUIColors.turquoiseColor(), FlatUIColors.greenSeaColor()),
            (FlatUIColors.emeraldColor(), FlatUIColors.nephritisColor()),
            (FlatUIColors.peterRiverColor(), FlatUIColors.belizeHoleColor()),
            (FlatUIColors.amethystColor(), FlatUIColors.wisteriaColor()),
            (FlatUIColors.wetAsphaltColor(), FlatUIColors.midnightBlueColor()),
            (FlatUIColors.sunflowerColor(), FlatUIColors.flatOrangeColor()),
            (FlatUIColors.carrotColor(), FlatUIColors.pumpkinColor()),
            (FlatUIColors.alizarinColor(), FlatUIColors.pomegranateColor()),
            (FlatUIColors.cloudsColor(), FlatUIColors.silverColor()),
            (FlatUIColors.concreteColor(), FlatUIColors.asbestosColor())
        ]
        
        var complementaryColor:UIColor = UIColor.whiteColor()
        for colorPair in colorPairs {
            if color == colorPair.colorA {complementaryColor = colorPair.colorB}
            if color == colorPair.colorB {complementaryColor = colorPair.colorA}
        }
        return complementaryColor
    }
   


    public static func pairedColorForColor(color:UIColor?)->UIColor {
        guard let kosherColor = color else {return UIColor.whiteColor()}
        return FlatUIColors.pairedColorForColor(kosherColor)
    }

    //Extension Ends
}


