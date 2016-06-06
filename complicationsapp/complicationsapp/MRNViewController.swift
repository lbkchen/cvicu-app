//
//  MRNViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/24/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit

class MRNViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var MRNValue: UILabel!
    
    let defaultMRNValue : String = "0"
    var currentlyTyping : Bool = false
    
    @IBAction func appendDigit(sender: SimpleKeypadButton) {
        let digit = sender.currentTitle!
        
        if (currentlyTyping) {
            MRNValue.text = MRNValue.text! + digit
        } else {
            MRNValue.text = digit
            currentlyTyping = true
        }
    }
    
    @IBAction func clearValue(sender: SimpleKeypadButton) {
        MRNValue.text = defaultMRNValue
        currentlyTyping = false
    }
    
    @IBAction func submitValue(sender: SimpleKeypadButton) {
        // Set SessionData MRN
        SessionData.sharedInstance.MRN = Int(MRNValue.text!)
        
        // Reset stored CHCVC cache
        Complications.resetCHCVC()
        
        // Connect to network and requestLogs
        let url = "http://localhost:3000"
        let args = ["FIN" : String(SessionData.sharedInstance.MRN!)]
        print(args)
        let net = NetworkHandler(url: url, targetAction: "requestLogs", args: args)
        net.postToServer()
        while (SessionData.sharedInstance.patientLogs == nil) {
            // Wait until data is retrieved: potentially dangerous if network fails
            // FIXME
        }
        
        // Segue to next screen after done
        self.performSegueWithIdentifier("submit", sender: self)
        
        // Confirm connection with patient MRN
        print("Connected to patient with MRN #\(SessionData.sharedInstance.MRN!)")
    }
    
    @IBAction func cancelToMRNViewController(segue:UIStoryboardSegue) {
        
    }
}

