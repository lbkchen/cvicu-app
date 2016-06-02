//
//  ComplicationHistoryCollectionView.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/1/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class ComplicationHistoryCollectionView : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    @IBOutlet weak var historyLabel: UILabel!
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return complications.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCellWithReuseIdentifier("history", forIndexPath: indexPath) as! ComplicationHistoryCollectionViewCell
        
        cell.historyLabel.text = complications[indexPath.row]
        
        return cell
    }
    
}
