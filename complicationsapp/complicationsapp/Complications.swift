//
//  Complications.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/25/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation

class Complications {
    
    // The data in this class is not actually connected to the data 
    // from database.js, which extracts from the MySQL server, since
    // there are extra labels here. If the database is updated to 
    // modify some tables, these will need to be manually changed as
    // well
    
    static let complications = [
        "Cardiopulmonary resuscitation",
        "Unplanned return to CICU (<48 hours)",
        "Unplanned readmission to the hospital within 30 days",
        "Arrhythmia",
        "Mechanical circulatory support during CICU encounter",
        "Low Cardiac Output Syndrome",
        "Pericardial effusion requiring drainage",
        "Pulmonary hypertension",
        "Pulmonary vein obstruction",
        "Systemic vein obstruction",
        "RESPIRATORY",
        "Listed for heart transplant during CICU encounter",
        "Reoperation for bleeding",
        "ORGAN DYSFUNCTION",
        "Delayed Sternal Closure",
        "Intraoperative death or intraprocedural death",
        "Infections",
        "Unplanned operation/procedure"
    ].sort()
    
    static let data = [
        "arrhythmialog" : "Arrhythmia",
        "cprlog" : "Cardiopulmonary resuscitation",
        "dsclog" : "Delayed Sternal Closure",
        "ididlog" : "Intraoperative death or intraprocedural death",
        "infeclog" : "Infections",
        "lcoslog" : "Low Cardiac Output Syndrome",
        "lhtlog" : "Listed for heart transplant during CICU encounter",
        "mcslog" : "Mechanical circulatory support during CICU encounter",
        "odlog" : "ORGAN DYSFUNCTION",
        "perdlog" : "Pericardial effusion requiring drainage",
        "phlog" : "Pulmonary hypertension",
        "pvolog" : "Pulmonary vein obstruction",
        "rblog" : "Reoperation for bleeding",
        "reslog" : "RESPIRATORY",
        "svolog" : "Systemic vein obstruction",
        "uoplog" : "Unplanned operation/procedure",
        "urcclog" : "Unplanned return to CICU (<48 hours)",
        "urhlog" : "Unplanned readmission to the hospital within 30 days"
    ]
    
    static let dataB = Complications.reverseKeyValue(data)
    
    static var chcvcDict = Complications.getEmptyDict(data)
    
    // args must be a one to one mapping
    static func reverseKeyValue(args: [String : String]) -> [String : String] {
        var result = [String : String]()
        for (key, value) in args {
            result[value] = key
        }
        return result
    }
    
    static func getEmptyDict(dict: [String : String]) -> [String : AnyObject?] {
        var result = [String : AnyObject?]()
        for key in dict.keys {
            result[key] = nil
        }
        return result
    }
    
    static func resetCHCVC() {
        chcvcDict = Complications.getEmptyDict(data)
    }
}