//
//  SessionData.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/1/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation

// Singleton class that keeps track of all post data 
// to be submitted in the current session
class SessionData {
    static let sharedInstance = SessionData()
    private init() {} // Prevents access
    
    var MRN : Int?
    var patientLogs : [String : [String]]?
    var targetAction : String?
    var postObject : [String : String] = [:]
    
    func addData(key: String, value: String) {
        postObject[key] = value
    }
    
    // day and time must be already added to postObject before this function is called
    func finalize() {
        let date = "\(postObject["day"]!) \(postObject["time"]!)"
        postObject["date"] = date
        postObject.removeValueForKey("day")
        postObject.removeValueForKey("time")
    }
    
    // for debugging
    func printData() {
        print(self.postObject)
    }
}