//
//  ConfirmationViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/9/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    static let defaultText = "Confirm submission for patient #"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load child collection view controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("confirmation") as! ConfirmationCollectionViewController
        self.addChildViewController(vc)
        
        let container = self.view.viewWithTag(42)!
        container.addSubview(vc.view)
        vc.view.frame = container.bounds
        vc.didMoveToParentViewController(self)
        
        // Set label to patient MRN number
        resetMRNLabel()
        let MRN = SessionData.sharedInstance.MRN!
        confirmLabel.text = confirmLabel.text! + MRN + "?"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - CollectionView setup
    
    // MARK: - Data submission
    @IBAction func submitLog(sender: UIButton) {
        SessionData.sharedInstance.finalizeLong()
        SessionData.sharedInstance.postToServer()
    }
    
    // MARK: - Helper functions
    func resetMRNLabel() {
        confirmLabel.text = ConfirmationViewController.defaultText
    }
}
