//
//  CompCollectionViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/25/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class CompCollectionViewController: UICollectionViewController {
    
    var complications = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        complications = ["Cardiopulmonary resuscitation",
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
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return complications.count
    }
}
