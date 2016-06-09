//
//  ComplicationForms.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/7/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Eureka

// Creates a variable to hold all the forms generated for each complication
class ComplicationForms {
    
    // Keeps a reference to the view controller being used to display
    var vc: FormViewController?
    
    
    // Instantiates an empty Form dictionary
    var formDict = [String : Form]()
    var nonsenseKeys = Complications.getEmptyDictArray(Complications.data)
    
    init(vc: FormViewController) {
        self.vc = vc
    }
    
    func createForm(logName: String) -> Form {
        var thisForm : Form
        switch logName {
            case "arrhythmialog":
                thisForm = createArr()
            case "cprlog":
                thisForm = createCPR()
            case "mcslog":
                thisForm = createMCS()
        default:
            thisForm = Form()
        }
        formDict[logName] = thisForm
        return thisForm
    }
    
    func createArr() -> Form {
        // ---------------------- Arrhythmia form ---------------------- //
        let arrForm = Form()
        arrForm +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            // Need to remove tag in form-processing
            <<< SwitchRow("Therapies present at discharge?") {
                $0.title = $0.tag
                $0.value = true
            }
            
            <<< DateTimeInlineRow("StopDate") {
                $0.title = "Stop date/time"
                $0.value = NSDate()
                $0.hidden = .Function(["Therapies present at discharge?"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowByTag("Therapies present at discharge?")
                    return row.value ?? false == true
                })
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("Type") {
                $0.title = "Type"
                $0.selectorTitle = "Which type of arrhythmia?"
                $0.options = [
                    "Atrial tachycardia",
                    "Ventricular tachycardia",
                    "Junctional tachycardia",
                    "Complete heart block",
                    "Second degree heart block",
                    "Sinus or junctional bradycardia"
                ]
                $0.value = "Enter"
                }.onChange { row in
                    print(row.value)
            }
            
            <<< AlertRow<String>("Therapy") {
                $0.title = "Therapy"
                $0.value = "Enter"
                $0.selectorTitle = "Which type of arrhythmia therapy?\n\nDefinition: Treatment with intravenous therapy (continuous infusion, bolus dosing, or electrolyte therapy)"
                $0.options = [
                    "Drug",
                    "Electrical Cardioversion/Defibrillation",
                    "Permanent Pacemaker / AICD",
                    "Temporary Pacemaker",
                    "Cooling < 35 degrees"
                ]
            }
        return arrForm
    }
    
    func createCPR() -> Form {
        // ---------------------- CPR form ---------------------- //
        let cprForm = Form()
        cprForm +++ Section("Dates and times")
            
            <<< LabelRow() {
                $0.title = "USE CODE SHEET FOR ACCURATE TIMES"
            }
            
            <<< DateTimeInlineRow("startDate") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            <<< DateTimeInlineRow("endDate") {
                $0.title = "End date/time"
                $0.value = NSDate()
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("outcome") {
                $0.title = "CPR Outcome"
                $0.selectorTitle = "CPR Outcome"
                $0.options = ["ROSC", "ECMO", "DEATH"]
                $0.value = "Enter"
            }
            
            <<< AlertRow<String>("Hypothermia") {
                $0.title = "Hypothermia protocol"
                $0.selectorTitle = "Hypothermia protocol (<34 degrees)?\n\nNo implies hypothermia"
                $0.options = ["Yes", "No"]
                $0.value = "Enter"
        }
        return cprForm
    }
    
    func createMCS() -> Form {
        // ---------------------- MCS form ---------------------- //
        let mcsForm = Form()
        mcsForm +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            <<< LabelRow() {
                $0.title = "(End date) Do not enter: to be adjudicated by Data Manager"
            }
            
            <<< DateTimeInlineRow("MCSE") {
                $0.title = "MCS end date/time"
                $0.value = nil
            }
            
            +++ Section("Details")
            
            <<< SwitchRow("In post-ope period") {
                $0.title = "In post-operative period?"
                $0.value = false
            }
            
            <<< AlertRow<String>("SupportType") {
                $0.title = "Support type"
                $0.value = "Enter"
                $0.selectorTitle = "Select support type"
                $0.options = ["VAD", "ECMO", "Both VAD and ECMO"]
            }
            
            <<< AlertRow<String>("Reason") {
                $0.title = "Primary reason"
                $0.value = "Enter"
                $0.selectorTitle = "Select primary reason for MCS"
                $0.options = [
                    "LCOS/Cardiac failure",
                    "Ventricular dysfunction",
                    "Hypoxemia",
                    "Hypercardic respiratory failure",
                    "Shunt occlusion",
                    "Arrhythmia",
                    "Bleeding",
                    "Multisystem organ failure"
                ]
            }
            
            <<< AlertRow<String>("ECPR") {
                $0.title = "ECPR"
                $0.value = "Enter"
                $0.selectorTitle = "Enter ECPR"
                $0.options = [
                    "Active CPR at cannulation",
                    "Active CPR within 2 hours of cannulation"
                ]
            }
            
            <<< SwitchRow("MCSS") {
                $0.title = "MCS present at start of CICU encounter?"
                $0.value = false
                }.onCellSelection { cell, row in
                    self.displayAlert("Full description", message: row.title!)
                }
        return mcsForm
    }
    // When called, creates all forms for complications, and adds them to listOfForms
    func createForms() {
        let arrForm = Form()
        let cprForm = Form()
        let mcsForm = Form()
        
        // ---------------------- Overall form setup ---------------------- //
        LabelRow.defaultCellUpdate = { cell, row in cell.textLabel?.textColor = .redColor()  }
        
        
        
        
        
        
        
        
        
        
        // When done, add all forms to dictionary
        formDict["cprlog"] = cprForm
        formDict["arrhythmialog"] = arrForm
        formDict["mcslog"] = mcsForm
    }
    
    func extractDataAndCleanForms() {
        // Add cleaning operation
        
//        let arrForm = formDict["arrhythmialog"]
//        var arrValues = arrForm!.values()
//        SessionData.sharedInstance.addData(convertAllValuesToString(arrValues))
        for key in formDict.keys {
            let form = formDict[key]
            // reset confirmObject to postObject
            let data = SessionData.sharedInstance
            data.confirmObject = data.postObject
            
            let toAdd = convertAllValuesToString(form!.values())
            data.confirmObject = data.addData(data.confirmObject, toAdd: toAdd)
//            SessionData.sharedInstance.addData(convertAllValuesToString(form!.values()))
        }
    }
    
    // MARK: - Helper functions
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.vc!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func convertAllValuesToString(dict: [String : Any?]) -> [String : String] {
        var result = [String : String]()
        for key in dict.keys {
            var thisValue = dict[key]!
            if (thisValue == nil) {
                result[key] = "null"
            } else {
                thisValue = thisValue!
            }
            
            if (thisValue is Int) {
                result[key] = String(thisValue)
            } else if (thisValue is Bool) {
                result[key] = (thisValue as! Bool == true) ? "YES" : "NO"
            } else if (thisValue is NSDate) {
                let df = NSDateFormatter()
                df.timeZone = NSTimeZone(abbreviation: "PST")
                df.dateFormat = "MM/dd/yyyy HH:mm"
                result[key] = df.stringFromDate(thisValue as! NSDate)
            } else if (thisValue is String?) {
                result[key] = (thisValue as! String?)!
            }
        }
        return result
    }
    
}
