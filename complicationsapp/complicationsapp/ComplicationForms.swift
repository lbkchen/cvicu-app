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
    
    // Instantiates an empty Form array
    static var listOfForms = [Form]()
    static var formDict = Complications.getEmptyDict(Complications.data) as! [String : Form]
    
    // When called, creates all forms for complications, and adds them to listOfForms
    static func createForms() {
        
        // Create a new Form object
        let cprForm = Form()
        
        // Follow this format!
        // Add rows and sections and whatever to form
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
            
            <<< DateRow() {
                    $0.title = "Start Date"
                    $0.value = NSDate()
                }

            <<< DateRow() {
                    $0.title = "End Date"
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
        
        // When done, add this form to listOfForms
        listOfForms.append(cprForm)
        formDict["cprlog"] = cprForm
        
        
        // Arrhythmia form: ignore this for now
        let arrForm = Form()
        arrForm +++ Section()
            <<< AlertRow<String>() {
                $0.title = "Type"
                $0.selectorTitle = "Which type of arrhythmia"
                $0.options = ["Atrial tachycardia", "Ventricular tachycardia", "Junctional tachycardia", "Complete heart block", "Second degree heart block", "Sinus or junctional bradycardia"]
                $0.value = "Enter type"
                }.onChange { row in
                    print(row.value)
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purpleColor()
        }
    }
    
}
