//
//  CFormViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/7/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Eureka

class CFormViewController: FormViewController {
    
    // Value is set in prepareForSegue from ComplicationsCollectionViewController
    var formName : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let forms = ComplicationForms(vc: self)
        form = forms.formDict[formName!]!
        form +++ Section("Submit")

            <<< ButtonRow() {
                $0.title = "Submit log"
                $0.presentationMode = .SegueName(segueName: "toConfirmation", completionCallback: nil)
            }.onCellSelection { _, _ in
                forms.extractDataAndCleanForms()
            }
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

}
