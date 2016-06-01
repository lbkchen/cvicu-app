//
//  ComplicationsCollectionViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/25/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ComplicationsCollectionViewController: UICollectionViewController {
    
    var complications = [String]()
    
    // padding of collection view controller is set to 10
    // leftAndRightPadding = (numberOfColumns + 1) * padding
    let numberOfColumns : CGFloat = 3.0
    let leftAndRightPadding : CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        
        // setting width of cells according to number of columns
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPadding) / numberOfColumns
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width)
        
        // Network testing
        let url = "http://localhost:3000"
        let postString = "targetAction=checkFIN&Table=arrhythmialog&FIN=234234"
        let net = NetworkHandler(url: url, postString: postString)
        print("starting to postToServer")
        net.postToServer()
        
        // Confirm connection with patient MRN
        print("Connected to patient with MRN #\(SessionData.sharedInstance.MRN!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return complications.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("complication", forIndexPath: indexPath) as! ComplicationsCollectionViewCell
    
        // Configure the cell
        cell.complicationLabel.text = complications[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
