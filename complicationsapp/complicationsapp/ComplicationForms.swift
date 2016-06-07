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
    var listOfForms = [Form]()
    
    // When called, creates all forms for complications, and adds them to listOfForms
    func createForms() {
        
        // Create a new Form object
        var cprForm = Form()
        
        // Add rows and sections and whatever to form
        cprForm +++ Section("Custom Cells")
            <<< LabelRow() {
                $0.title = "yes"
                $0.value = "no"
        }
        
        // When done, add this form to listOfForms
        listOfForms.append(cprForm)
    }
    
}
