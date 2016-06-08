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
    
    // Instantiates an empty Form dictionary
    static var formDict = Complications.getEmptyDict(Complications.data) as! [String : Form]
    
    // When called, creates all forms for complications, and adds them to listOfForms
    static func createForms() {
        
        
        // ---------------------- Arrhythmia form ---------------------- //
        let arrForm = Form()
        
        arrForm +++ Section("Dates and times")
            
            <<< DateTimeInlineRow() {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            <<< SwitchRow("Therapies present at discharge?") {
                $0.title = $0.tag
                $0.value = false
            }
            
            <<< DateTimeInlineRow("Stop Date") {
                $0.title = "Stop date/time"
                $0.value = NSDate()
                $0.hidden = .Function(["Therapies present at discharge?"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowByTag("Therapies present at discharge?")
                    return row.value ?? false == false
                })
            }
        
            +++ Section("Details")
            
            <<< AlertRow<String>() {
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
        
            <<< AlertRow<String>() {
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
        
        
        // ---------------------- CPR form ---------------------- //
        let cprForm = Form()
        
        cprForm +++ Section("Definition")
 
            <<< AlertRow<String>() {
                $0.title = "Definition"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Yee dis is the definition hoajoweif jaowifjoawefj oaiwfj a foiwje ojoafj oafwj ofwa ofjoia fjow foajf ofo owi fjmie"
            } .onChange { row in
                        row.value = "Press to view"
            }
            
            +++ Section("Dates and times")
            
            <<< DateTimeInlineRow() {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }

            <<< DateTimeInlineRow() {
                $0.title = "End date/time"
                $0.value = NSDate()
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>() {
                $0.title = "CPR Outcome"
                $0.selectorTitle = "CPR Outcome"
                $0.options = ["ROSC", "ECMO", "DEATH"]
                $0.value = "Enter"
            }
        
            <<< AlertRow<String>() {
                $0.title = "Hypothermia protocol"
                $0.selectorTitle = "Hypothermia protocol (<34 degrees)?\n\nNo implies hypothermia"
                $0.options = ["Yes", "No"]
                $0.value = "Enter"
            }
        
        
        // When done, add all forms to dictionary
        formDict["cprlog"] = cprForm
        formDict["arrhythmialog"] = arrForm
    }
    
}
