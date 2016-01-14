//
//  AATrickViewController.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 12/29/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

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
            return self.cardViews.popLast()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View heirarchy
        view.clipsToBounds = true
        view.addSubview(resultsCard)
        resultsCard.delegate = self
        /**
        Debug only:
        */
//        resultsCard.backgroundColor = UIColor.orangeColor()
        resultsCard.backgroundColor = UIColor(rgba: "#4A4F70")

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
            let newCardView = ABTrickCardView(forCardModel: cardModel)
            newCardView.cardCollectionView.delegate = self
            newCardView.cardCollectionView.dataSource = self
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

    
    func swipingAllowed(hasPermission: Bool) {
        if hasPermission { swipeableView.allowedDirection = .Horizontal }
        else { swipeableView.allowedDirection = .None }
    }
    
    func replayButtonTapped(sender: UIButton!) {
        print("button tapped")
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
    
    
    // MARK: === UICollectionView DataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCols * numRows
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AATCellReuseID, forIndexPath: indexPath) as! AATCollectionViewCell
        let collectView = collectionView as! AATCollectionView
        let cardModel = collectView.cardModel
        cell.cardModel = cardModel
        
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue:
            cell.label.text = "YES"
            cell.imageView.removeFromSuperview()
            cell.addSubview(cell.label)
        case ButtonCellRow.NoButton.rawValue:
            cell.label.text = "NO"
            cell.imageView.removeFromSuperview()
            cell.addSubview(cell.label)
        default:
            if let number = numberForIndexPath(indexPath, withCardModel:collectView.cardModel) {
                cell.label.text = String(number)
            } else { cell.imageView.removeFromSuperview() }
        }
        return cell
    }
    
    
    //MARK: CollectionView helper methods
    func numberForIndexPath(indexPath:NSIndexPath, withCardModel cardModel:CardID)->Int? {
        let row = indexPath.row
        let arrayOfNums = cardModel.cardInfoArray()
        
        if row >= arrayOfNums.count { return nil }
        else { return arrayOfNums[row] }
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
    
    
    /**
     Effect: Border is a visual indicator of how one voted. CardView disappears in aesthetically pleasing way.
     Except for the last card, which would look odd.
     */
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case ButtonCellRow.YesButton.rawValue:
            collectionView.superview?.layer.borderColor = UIColor.greenColor().CGColor
            collectionView.superview?.layer.borderWidth = 5
        case ButtonCellRow.NoButton.rawValue :
            collectionView.superview?.layer.borderColor = UIColor.redColor().CGColor
            collectionView.superview?.layer.borderWidth = 5
        default:
            break
        }

        if swipeableView.activeViews().count > 1 {
            collectionView.superview?.backgroundColor = UIColor.clearColor()
        }
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
    
    
    func recordVote(vote:Bool, forCard myCardID:CardID) {

        voteRecord[myCardID] = vote
        print(voteRecord)
        self.swipingAllowed(true)

        ///...Then prepare the results, and display them on the View
        if voteRecord.keys.count >= CardID.allValues.count { tallyAgeAndDisplayResults() }
    }
    
    
    /**
     Should display controls on the resultsCardView
     */
    func tallyAgeAndDisplayResults() {
        var resultingAge = 0
        voteRecord.enumerate().forEach { (card: (index: Int, element: (CardID, Bool))) -> () in
            if card.element.1 {
                let cardAgeContribution = card.element.0.rawValue
                resultingAge += cardAgeContribution
            }
        }
//        resultsCard = ABResultsCardView(forResults: resultingAge)
        resultsCard.resultRecord = resultingAge
        view.bringSubviewToFront(resultsCard.replayButton)
    }
    
    
    /**
     Rewinds all the swipeViews, resets the votes (UI and voteRecord) to pre-voting, resets the resultsView
     */
    func resetGame() {
        swipeableView.discardViews() //Gets rid of the old resultsCardView
        resultsCard.resultRecord = nil
        repeat {
            swipeableView.rewind()
            swipeableView.topView()?.backgroundColor = UIColor.blackColor()
        } while swipeableView.history.count > 0

        voteRecord.removeAll()
    }
    
    //ViewController Ends here
}
