//
//  TimeViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/6/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.timeZone = NSTimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "HH:mm"
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
    
    // Mark: - Submitting to database
    
    @IBAction func submitLog(sender: UIButton) {
        recordTime()
        SessionData.sharedInstance.finalizeShort()
        SessionData.sharedInstance.postToServer()
    }
    
    // Mark: - Helper functions
    func recordTime() {
        SessionData.sharedInstance.addData("time", value: getCurrentTimeString())
    }
    
    func getCurrentTimeString() -> String {
        return dateFormatter.stringFromDate(timePicker.date)
    }
}
