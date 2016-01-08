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
4b) make swiping rotate to the next card -
5) keep a **visual** tally of the votes.
6) Stop when all 6 cards have votes.
7) Present the result, wow the user, offer to play again

make the cards rotate a bit, randomly, so that you can see them when they are stacked one atop the other.

- parameter animated: <#animated description#>
*/

import UIKit
import FlatUIColors
import ZLSwipeableViewSwift
import ReactiveUI

class AATrickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum ButtonCellRow:Int {
        case YesButton = 30
        case NoButton  = 31
    }
    
    typealias NumInfo = Int
    
    // Properties
    let cardCellReuseID:String = "cellReuseID"
    let numCols = 4
    let numRows = 8

    // Views
    var swipeableView:ZLSwipeableView!
    
    // Objects
    // Model
    let deck = AATDeckModel.sharedDeck
    
    // Business Logic
    var voteTally = [Int:Bool]()
    
    
    //MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)
        view.clipsToBounds = true

        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        swipeableView.didStart = {view, location in
            print("Did START swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("SWIPING at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did END swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did SWIPE view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did CANCEL swiping view")
        }
        
        swipeableView.frame = view.bounds
        
        /**
        for cardModel in deck.randomOrderInstance {
            produceCardView(cardModel)
        }
        */
        //End ViewDidLoad()
    }

    func nextCardView()->UIView? {
        
    }
    
    //MARK: Setup helper functions
    func produceCardView(cardModel:CardID)->ABSwipeableCardView {
        let collectionView = getCollectionView(cardModel)

        // CardView
        let cardView = ABSwipeableCardView(superView: view)
        cardView.backgroundColor = FlatUIColors.randomFlatColor()
        cardView.addSubview(collectionView)
        collectionView.frame = CGRectInset(cardView.bounds, 12, 12)
        
        return cardView
    }
    
    func getCollectionView(cardModel:CardID)->UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.sectionInset            = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.estimatedItemSize       = CGSizeMake(30, 30)
        
        let collectionView = AATCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.cardModel  = cardModel
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:cardCellReuseID)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardCellReuseID, forIndexPath: indexPath)

        if let myCollectionView = collectionView as? AATCollectionView {
            configureCell(cell, forIndexPath: indexPath, accordingToCardModel: myCollectionView.cardModel)
        }
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
        collectionView.superview?.backgroundColor = cell?.backgroundColor
    }
    
    // change background color back when user releases touch
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = FlatUIColors.pairedColorForColor(cell?.backgroundColor)
    }
    
    
    // MARK: == Private helper methods ==
    func configureCell(cell:UICollectionViewCell, forIndexPath indexPath:NSIndexPath, accordingToCardModel cardModel:CardID) {
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
            label.text = numberForIndexPath(indexPath, withCardModel: cardModel)
            cell.backgroundColor = FlatUIColors.orderedFlatColor(indexPath.row * 2 % 20)
            
            ///TODO: Make colors pretty!
            //            cell.backgroundColor = FlatUIColors.randomFlatColor()
        }
        
        
    }
    
    func numberForIndexPath(indexPath:NSIndexPath, withCardModel cardModel:CardID)->String {
        // Pad the array with zeros
        var paddedCardInfo = cardModel.cardInfoArray()
        while paddedCardInfo.count < (numCols * numRows) {
            paddedCardInfo.append(NumInfo.allZeros)
        }
        
        // Interpret data into proper string.
        if paddedCardInfo[indexPath.row] == NumInfo.allZeros {  return ""  }
        else {  return String(paddedCardInfo[indexPath.row])  }
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
    
    
    func vote(vote:Bool) {
        //TODO: Vote functionality here.
        print(voteTally)
    }
    
    //ViewController Ends here
}

// MARK: - === AATCollectionView class ===
class AATCollectionView : UICollectionView {
    var cardModel:CardID = CardID.Card1
}

