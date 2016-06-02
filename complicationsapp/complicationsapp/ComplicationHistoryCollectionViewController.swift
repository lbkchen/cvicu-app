//
//  ComplicationHistoryCollectionViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/1/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class ComplicationHistoryCollectionViewController : UICollectionViewController {
    
    let complications = ["Cardiopulmonary resuscitation",
                         "Unplanned return to CICU (<48 hours)",
                         "Unplanned readmission to the hospital within 30 days",
                         "Arrhythmia",
                         "Mechanical circulatory support during CICU encounter",
                         "Low Cardiac Output Syndrome",
                         "Pericardial effusion requiring drainage",
                         "Pulmonary hypertension",
                         "Pulmonary vein obstruction",
                         "Systemic vein obstruction",
                         "RESPIRATORY",
                         "Listed for heart transplant during CICU encounter",
                         "Reoperation for bleeding",
                         "ORGAN DYSFUNCTION",
                         "Delayed Sternal Closure",
                         "Intraoperative death or intraprocedural death",
                         "Infections",
                         "Unplanned operation/procedure"].sort()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Additional
        let width = (CGRectGetWidth(collectionView!.frame))
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width / 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sizes cells to full width and 1/3 height of container
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width / 3)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("history", forIndexPath: indexPath) as! ComplicationHistoryCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 0)
        cell.timeLabel.text = complications[indexPath.row]
        
//        let cellView = UIView(frame: cell.bounds)
//        cellView.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 1)
//        cell.addSubview(cellView)
        
        return cell
    }
}