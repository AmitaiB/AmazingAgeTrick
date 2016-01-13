//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//
/**
NEXT: extract the cardvalue from the indexpath or something, so that when we vote, we get a tally.

Extension on ABCardView to return a CardID
TrickVC records tally in a dictionary


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
import STRatingControl
import UIColor_Hex_Swift
import iAd

class AATrickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ABReplayButtonDelegate {
    ///numRows * numCols - (1 || 2)  :)
    enum ButtonCellRow:Int {
        case YesButton = 30
        case NoButton  = 31
    }
    
    typealias NumInfo = Int
    
    // Views
    var cardViews = [UIView]()
    var swipeableView:ZLSwipeableView = ZLSwipeableView()
    var resultsCard:ABResultsCardView = ABResultsCardView(forResults: nil)

    // Card Properties
    var possibleResults = Set(1...60)
    let numCols = 4
    let numRows = 8
    
    // Model
    let deck = AATDeckModel.sharedDeck
    
    // Business Logic
    var voteRecord = [CardID:Bool]()
    
    //MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
//            return self.nextCardView()
            return self.cardViews.popLast()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View heirarchy
        view.clipsToBounds = true
        view.addSubview(resultsCard)
        view.addSubview(swipeableView)
        
        setupSwipeView()
        
        //End ViewDidLoad()
    }
    
    //MARK: Private lifecycle methods
    
    func setupSwipeView() {
        swipeableView.numberOfHistoryItem = UInt.max
        swipingAllowed(false) ///Swiping locked until YES/NO recorded
        swipeableView.frame = view.bounds
        swipeableView.numberOfActiveView = UInt(CardID.allValues.count) // Should = 6.
        
        for cardModel in deck.randomOrderInstance {
//            let newCardView = produceCardView(cardModel)
            let newCardView = ABTrickCardView(forCardModel: cardModel)
            cardViews.append(newCardView)
        }
        
        
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
            self.swipingAllowed(false)
        }
        swipeableView.didCancel = {view in
            print("Did CANCEL swiping view")
        }
    }

    /*
     CLEAN: No longer called. If works, delete.
     */
    func nextCardView()->UIView? {
        return cardViews.popLast()
    }
    
    func swipingAllowed(hasPermission: Bool) {
        if hasPermission { swipeableView.allowedDirection = .Horizontal }
        else { swipeableView.allowedDirection = .None }
    }

    /*
    func produceCardView(cardModel:CardID)->ABCardView {
        let collectionView = getCollectionView(cardModel)
    
        // CardView
        let cardRect = CGRectInset(swipeableView.bounds, 25, 25)
        let cardView = ABCardView(frame: cardRect)
        cardView.backgroundColor = UIColor.blackColor()
        cardView.addSubview(collectionView)
        collectionView.frame = CGRectInset(cardView.bounds, 12, 12)
    
        return cardView
    }
    */

/*
    func produceResultsView(withResults result:Int) -> ABCardView {
        let cardRect = CGRectInset(swipeableView.bounds, 25, 25)
        let cardView = ABCardView(frame: cardRect)
//        cardView.backgroundColor = UIColor.blackColor()
        cardView.backgroundColor = UIColor(rgba: "#4A4F70")
        let labelRect = CGRectInset(cardView.bounds, 25, 25)
        let resultsLabel = UILabel()
        cardView.addSubview(resultsLabel)
//        resultsLabel.frame = labelRect
        resultsLabel.textAlignment = .Center
        resultsLabel.backgroundColor = FlatUIColors.turquoiseColor()
        
        resultsLabel.text = resultsLabelText(forResult: result)
        
        let replayButton = UIButton(type: .Custom)
        cardView.addSubview(replayButton)
        replayButton.imageView?.contentMode = .ScaleAspectFit
        replayButton.setImage(UIImage(named: "RePlay Button-red"), forState: .Normal)
        setupViewShadow(replayButton.layer)
        replayButton.addTarget(self, action: Selector("replayButtonTapped:"), forControlEvents: .TouchUpInside)
        
        
        // Autolayout
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsLabel.removeConstraints(resultsLabel.constraints)
        
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        replayButton.removeConstraints(replayButton.constraints)
        
        let commonInset:CGFloat = 20
        
        resultsLabel.topAnchor.constraintEqualToAnchor(cardView.topAnchor, constant: commonInset).active = true
        resultsLabel.leadingAnchor.constraintEqualToAnchor(cardView.leadingAnchor, constant: commonInset).active = true
        resultsLabel.trailingAnchor.constraintEqualToAnchor(cardView.trailingAnchor, constant: -commonInset).active = true
        
//        resultsLabel.bottomAnchor.constraintEqualToAnchor(replayButton.topAnchor, constant: 20)
        
        replayButton.bottomAnchor.constraintEqualToAnchor(cardView.bottomAnchor, constant: -commonInset).active = true
        replayButton.leadingAnchor.constraintEqualToAnchor(cardView.leadingAnchor, constant: commonInset).active = true
        replayButton.trailingAnchor.constraintEqualToAnchor(cardView.trailingAnchor, constant: -commonInset).active = true
        
        return cardView
    }
    */
    
    func replayButtonTapped(sender: UIButton!) {
        print("button tapped")
//        view.setNeedsDisplay()
        resetGame()
    }
    
    func setupViewShadow(layer:CALayer) {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }

    //Not used...
    func invertShadow(layer:CALayer) {
        let normalShadowOffset = layer.shadowOffset
        let selectedShadowOffset = CGSizeMake(-normalShadowOffset.height, -normalShadowOffset.width)
        layer.shadowOffset = selectedShadowOffset
    }
    
    /*
    func getCollectionView(cardModel:CardID) -> UICollectionView {
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
//        collectionView.backgroundColor = FlatUIColors.randomFlatColor()
//        collectionView.backgroundColor = cardModel.altColorForCardID()
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.allowsSelection = true
        return collectionView
    }
    */
    
    
    // MARK: === UICollectionView DataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCols * numRows
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AATCellReuseID, forIndexPath: indexPath)

        if let myCollectionView = collectionView as? AATCollectionView {
            configureCell(cell, forIndexPath: indexPath)
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
    
    ///Get cardID from collectionView
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let myCollectionView = collectionView as? AATCollectionView else { print("Error in \(__FUNCTION__)"); return }
        
        let thisCardsID:CardID = myCollectionView.cardModel
       
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue : recordVote(true,  forCard: thisCardsID)
        case ButtonCellRow.NoButton.rawValue  : recordVote(false, forCard: thisCardsID)
        default: break
        }
    }
    
    // change background color when user touches cell
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        collectionView.superview?.backgroundColor = cell?.backgroundColor

        //        cell?.backgroundColor = FlatUIColors.pairedColorForColor(cell?.backgroundColor)
    }

    /*
    // change background color back when user releases touch
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = FlatUIColors.pairedColorForColor(cell?.backgroundColor)
    }
    */
    
    
    // MARK: == Private helper methods ==
    
    func configureCell(cell:UICollectionViewCell, forIndexPath indexPath:NSIndexPath) {
        guard let myCell = cell as? AATCollectionViewCell else { return }
        var label = myCell.label
        var imageView = myCell.imageView
        
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue:
            label.text = "YES"
            imageView.removeFromSuperview()
            cell.addSubview(label)
        case ButtonCellRow.NoButton.rawValue:
            label.text = "NO"
            imageView.removeFromSuperview()
            cell.addSubview(label)
        default:
            label.text = numberForIndexPath(indexPath, withCardModel: myCell.cardModel)
            if label.text == "" { imageView.removeFromSuperview() }
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
    
/*
    
    func configureCell(cell:UICollectionViewCell, forIndexPath indexPath:NSIndexPath, accordingToCardModel cardModel:CardID) {
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = cardModel.cellImageForCardID()
        
//        cell.layer.cornerRadius = imageView.frame.height / 2
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.autoresizesSubviews = true
        cell.contentView.addSubview(imageView)
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .Center
        label.textColor = FlatUIColors.cloudsColor()
        label.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        label.backgroundColor = UIColor.clearColor()
        imageView.addSubview(label)
        
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue:
            label.text = "YES"
            imageView.removeFromSuperview()
            cell.addSubview(label)
//            label.backgroundColor = FlatUIColors.emeraldColor()
//            cell.backgroundColor = FlatUIColors.emeraldColor()
        case ButtonCellRow.NoButton.rawValue:
            label.text = "NO"
            imageView.removeFromSuperview()
            cell.addSubview(label)
//            label.backgroundColor = UIColor.redColor()
//            cell.backgroundColor = UIColor.redColor()
        default:
            label.text = numberForIndexPath(indexPath, withCardModel: cardModel)
            if label.text == "" { imageView.removeFromSuperview() }
//            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(rgba: "#363951") : UIColor(rgba: "#303348")
//                FlatUIColors.orderedFlatColor(indexPath.row * 2 % 2)
            
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

    */
    
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
    
    
    func recordVote(vote:Bool, forCard myCardID:CardID) {
        ///TODO: Vote functionality here.
        voteRecord[myCardID] = vote
        print(voteRecord)
        self.swipingAllowed(true)
        
        if voteRecord.keys.count >= 6 {prepareResults(resultsCard)}
    }
    
    /**
     Should display controls on the resultsCardView
    */
    func prepareResults(var resultsCardView:ABCardView) {
        var resultingAge = 0
        voteRecord.enumerate().forEach { (card: (index: Int, element: (CardID, Bool))) -> () in
            if card.element.1 {
                let cardAgeContribution = card.element.0.rawValue
                resultingAge += cardAgeContribution
            }
        }
        print("I'd guess that your age is: \(resultingAge)!")

//        resultsCardView = produceResultsView(withResults: resultingAge)
        resultsCardView = ABResultsCardView(forResults: resultingAge)
        
//        cardViews.append(resultsCardView)
    }
    
    /**
     Rewinds all the swipeViews, resets the votes (UI and voteRecord) to pre-voting, resets the resultsView
     */
    func resetGame() {
        swipeableView.discardViews() //Gets rid of the old resultsCardView
        repeat {
            swipeableView.rewind()
            swipeableView.topView()?.backgroundColor = UIColor.blackColor()
        } while swipeableView.history.count > 0
        
        voteRecord.removeAll()
    }
    
    //ViewController Ends here
}