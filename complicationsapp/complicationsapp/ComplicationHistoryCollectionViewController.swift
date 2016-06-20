//
//  ComplicationHistoryCollectionViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/1/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class ComplicationHistoryCollectionViewController : UICollectionViewController {
    
    var complication : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional
//        let width = (CGRectGetWidth(collectionView!.frame))
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSizeMake(width, width / 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sizes cells to full width and 1/3 height of container
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.92, height: self.view.frame.width / 3)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let logs = SessionData.sharedInstance.patientLogs!
        return logs[self.complication!]!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("history", forIndexPath: indexPath) as! ComplicationHistoryCollectionViewCell
        cell.layer.cornerRadius = 5
//        cell.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 0)
        
        let dates = SessionData.sharedInstance.patientLogs![self.complication!]!
        cell.timeLabel.text = dates[getReverseIndex(indexPath.row, size: dates.count)]
//        cell.timeLabel.text = Complications.complications[indexPath.row]
        
//        let cellView = UIView(frame: cell.bounds)
//        cellView.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 1)
//        cell.addSubview(cellView)
        
        return cell
    }
    
    // MARK: - Helper functions
    func getReverseIndex(index : Int, size : Int) -> Int {
        return size - index - 1
    }
}