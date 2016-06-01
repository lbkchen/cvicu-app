//
//  ComplicationHistoryCollectionViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/1/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class ComplicationHistoryCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPadding) / numberOfColumns
//    let layout = collectionViewLayout as! UICollectionViewFlowLayout
//    layout.itemSize = CGSizeMake(width, 2 * width)
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("history", forIndexPath: indexPath)
        
        
        return cell
    }
}