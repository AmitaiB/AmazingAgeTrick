//
//  AATCollectionView.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/13/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit
import FlatUIColors

let AATCellReuseID:String = "cellReuseID"

//MARK: === AATCollectionView ===
class AATCollectionView: UICollectionView {

    var cardModel:CardID = CardID.Card1
    
    init(forCardModel model:CardID) {
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        cardModel = model
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        backgroundColor = UIColor.clearColor()
        allowsSelection = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.sectionInset            = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.estimatedItemSize       = CGSizeMake(30, 30)

        setCollectionViewLayout(layout, animated: false)
        
        registerClass(AATCollectionViewCell.self, forCellWithReuseIdentifier: AATCellReuseID)
    }
}


//MARK: === AATCollectionViewCell ===
class AATCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    var label = UILabel()
    var cardModel = CardID.Card1 {
        didSet {
            setup()
        }
    }
    
    
    func setup() {
        setupImageView()
        setupNumberLabel()
    }
    
    func setupImageView() {
        imageView.frame = contentView.bounds
        imageView.contentMode = .ScaleAspectFit
        imageView.image = cardModel.cellImageForCardID()
        
        backgroundColor = UIColor.clearColor()
        contentView.autoresizesSubviews = true
        contentView.addSubview(imageView)
        
    }
    
    func setupNumberLabel() {
        label.frame = contentView.bounds
        label.textAlignment = .Center
        label.textColor = FlatUIColors.cloudsColor()
        label.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        label.backgroundColor = UIColor.clearColor()
        imageView.addSubview(label)
        
    }
    
}

