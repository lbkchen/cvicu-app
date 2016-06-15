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
        
        // ----------------- Overall form setup ----------------- //
        let green = UIColor(red: 57/255, green: 189/255, blue: 92/255, alpha: 1)
        let red = UIColor(red: 230/255, green: 62/255, blue: 98/255, alpha: 1)
        LabelRow.defaultCellUpdate = { cell, row in cell.textLabel?.textColor = .redColor()  }
        SLabelRow.defaultCellUpdate = { cell, row in cell.textLabel?.textColor = row.value! == "YES" ? green : red}
        
        // ----------------- Create form ----------------- //
        let forms = ComplicationForms(vc: self)
        
        form = forms.createForm(formName!)
        form +++ Section("Submit")
            
            <<< ButtonRow() {
                $0.title = "Submit log"
                $0.presentationMode = .SegueName(segueName: "toConfirmation", completionCallback: nil)
            }.onCellSelection { _, _ in
                forms.extractDataAndCleanForms()
            }
        
////        For the future, when multiple submissions are allowed in one go
//        let forms : ComplicationForms?
//        // Do any additional setup after loading the view.
//        
//        // If first form
//        if (SessionData.sharedInstance.forms == nil) {
//            forms = ComplicationForms(vc: self)
//            SessionData.sharedInstance.forms = forms
//        } else {
//            forms = SessionData.sharedInstance.forms!
//        }
//        
//        // Haven't entered in this form yet
//        if (forms?.formDict[formName!] == nil) {
//            forms?.createForm(formName!)
//            
//            form = forms!.formDict[formName!]!
//            form +++ Section("Submit")
//                
//                <<< ButtonRow() {
//                    $0.title = "Submit log"
//                    $0.presentationMode = .SegueName(segueName: "toConfirmation", completionCallback: nil)
//                    }.onCellSelection { _, _ in
//                        forms!.extractDataAndCleanForms()
//            }
//        } else {
//            form = (forms?.formDict[formName!])!
//        }
        
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
