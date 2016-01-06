//
//  AATCardModel.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/5/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//
/**
Abstract: This model is meant to be the immediate dataSource for the collectionView
displayed by each cardView. the requirements are thus:
1) It can be initialized with either a CardID or [Int] of card info,
2) It implements the dataSource functions/methods.

*/
import UIKit

let cardCellReuseID:String = "cellReuseID"

let numCols = 4
let numRows = 8

enum ButtonCellRow:Int {
    case YesButton = 30
    case NoButton  = 31
}

enum NumInfo:Int {case noNumber}


class AATCardModel: NSObject, UICollectionViewDataSource {

    var cardInfo:[Int]
    
    init(cardInfo:[Int]) {
        self.cardInfo = cardInfo
        super.init()
    }
    
    // MARK: === UICollectionView DataSource ===
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCols * numRows
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cardCellReuseID, forIndexPath: indexPath)
        configureCell(cell, forIndexPath: indexPath)
        return cell
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

    
}
