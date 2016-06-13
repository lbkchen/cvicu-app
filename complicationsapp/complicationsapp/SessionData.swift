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
    var targetAction : String? // may be unnecessary, duplicate in NetworkHandler
    var postObject : [String : String] = [:]
    var confirmObject : [String : String] = [:]
    var postKeys : [String] {
        get {
            var result = [String]()
            for key in confirmObject.keys {
                result.append(key)
            }
            return result
        }
    }
    var forms : ComplicationForms?
    
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    func addData(key: String, value: String) {
        postObject[key] = value
    }
    
    func addData(dict: [String : String]) {
        for key in dict.keys {
            postObject[key] = dict[key]!
        }
    }
    
    func addData(dict: [String : String], toAdd: [String : String]) -> [String : String] {
        var dict = dict
        for key in toAdd.keys {
            dict[key] = toAdd[key]!
        }
        return dict
    }

    // day and time must be already added to postObject before this function is called
    func finalizeShort() {
        
        // combine values for day and time into "date_1", and remove the constituent keys
        let date = "\(postObject["day"]!) \(postObject["time"]!)"
        postObject["date_1"] = date
        postObject.removeValueForKey("day")
        postObject.removeValueForKey("time")
        
        // add the current time as a variable "date"
        recordCurrentTime()
    }
    
    // Another finalize function that sets postObject to equal confirmObject and then post
    func finalizeLong() {
        SessionData.sharedInstance.postObject = SessionData.sharedInstance.confirmObject
        recordCurrentTime()
    }
    
    // posts HTTP request to server with action addLog
    func postToServer() {
        let url = "http://localhost:3000"
        let net = NetworkHandler(url: url, targetAction: "addLog", args: self.postObject)
        net.postToServer()
    }
    
    // logs the patient's MRN
    func recordMRN() {
        postObject["FIN"] = String(self.MRN!)
    }
    
    // logs the current time
    func recordCurrentTime() {
        let current = NSDate()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let currentString = dateFormatter.stringFromDate(current)
        postObject["date"] = currentString
    }
    
    // for debugging
    func printData() {
        print(self.postObject)
    }

}