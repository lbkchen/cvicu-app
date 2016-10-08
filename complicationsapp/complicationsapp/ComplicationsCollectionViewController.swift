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

        // setting width of cells according to number of columns
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPadding) / numberOfColumns
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, 2 * width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier == "toForm") {
            let destVC = segue.destinationViewController as! CFormViewController
            let compName = (sender as! UIButton).titleLabel!.text!
            destVC.navigationItem.title = compName
            destVC.formName = Complications.dataB[compName]!
        }
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func segue(sender: UIButton) {
        let complication = sender.titleLabel!.text!
        let table = Complications.dataB[complication]!
        SessionData.sharedInstance.addData("Table", value: table)
        if (Complications.oneStep.contains(complication)) {
            performSegueWithIdentifier("calendar", sender: sender)
        } else {
            performSegueWithIdentifier("toForm", sender: sender)
        }
    }
    
    @IBAction func cancelToComplicationsCollectionViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Complications.complications.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("complication", forIndexPath: indexPath) as! ComplicationsCollectionViewCell
    
        // Configure the cell
        cell.complicationLabel.text = Complications.complications[indexPath.row]
        cell.complicationLabel.adjustsFontSizeToFitWidth = true
        
        // Instantiate necessary child CollectionViewControllers and store them
        let logName = Complications.dataB[cell.complicationLabel.text!]!
        if (Complications.chcvcDict[logName] == nil) {
            let chcvc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryCollection") as! ComplicationHistoryCollectionViewController
            chcvc.complication = Complications.dataB[Complications.complications[indexPath.row]]
            Complications.chcvcDict[logName] = chcvc
            self.addChildViewController(chcvc)
        }
        
        // If this cell already has a CollectionViewController (probably wrong), remove it
        if (cell.chcvc != nil) {
            cell.viewWithTag(40)?.removeFromSuperview()
        }
        
        // Add the appropriate CollectionViewController to the right frame
        let subView = cell.viewWithTag(42)!
        let thisController = Complications.chcvcDict[logName] as! ComplicationHistoryCollectionViewController
//        thisController.view.frame = subView.frame
//        cell.addSubview(thisController.view)
        subView.addSubview(thisController.view)
        thisController.view.frame = subView.bounds
        thisController.view.tag = 40
        thisController.didMoveToParentViewController(self)
        cell.chcvc = thisController
        
        // Change button text (clear) to label text just to link action of pressing button
        let button = cell.viewWithTag(44)! as! UIButton
        button.titleLabel!.text = cell.complicationLabel.text!
        
        // Add the ComplicationHistoryCollectionViewController
//        if cell.chcvc == nil {
//            let chcvc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryCollection") as! ComplicationHistoryCollectionViewController
//            chcvc.complication = Complications.dataB[Complications.complications[indexPath.row]]
//            self.addChildViewController(chcvc)
//            let subView = cell.viewWithTag(42)!
//            chcvc.view.frame = subView.frame
//            cell.addSubview(chcvc.view)
//            chcvc.view.tag = 40
//            chcvc.didMoveToParentViewController(self)
//            cell.chcvc = chcvc
//        }
        
        // Return cell
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
