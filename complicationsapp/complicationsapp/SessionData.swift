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
    
    var MRN : String?
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
    
    static func clearData() {
        let sd = SessionData.sharedInstance
        sd.MRN = nil
        sd.patientLogs = nil
        sd.targetAction = nil
        sd.postObject = [:]
        sd.confirmObject = [:]
        sd.forms = nil
    }

    // day and time must be already added to postObject before this function is called
    func finalizeShort() {
        
        // combine values for day and time into "date_1", and remove the constituent keys
        let date = "\(postObject["day"]!) \(postObject["time"]!)"
        postObject["date_1"] = date
        postObject.removeValueForKey("day")
        postObject.removeValueForKey("time")
        
        // change "MRN" from the gui to the "FIN" as used in the database
        changeMRNtoFIN()
        
        // add the current time as a variable "date"
        recordCurrentTime()
    }
    
    // Another finalize function that sets postObject to equal confirmObject and then post
    func finalizeLong() {
        SessionData.sharedInstance.postObject = SessionData.sharedInstance.confirmObject
        changeMRNtoFIN()
        recordCurrentTime()
    }
    
    // posts HTTP request to server with action addLog
    func postToServer() {
        let url = "http://localhost:3000"
//        let url = "http://10.19.242.127:3000"
        let net = NetworkHandler(url: url, targetAction: "addLog", args: self.postObject)
        net.postToServer()
    }
    
    // checks and returns any conflicting dates from the server
    func checkDateFromServer(dateString : String) -> String {
        let url = "http://localhost:3000"
//        let url = "http://10.19.242.127:3000"
        let args = [
            "Table" : postObject["Table"]!,
            "dateToCheck" : dateString,
            "FIN" : postObject["MRN"]!
        ]
        let net = NetworkHandler(url: url, targetAction: "checkConflicts", args: args)
        return net.postToServer()
    }
    
    // logs the patient's MRN
    func recordMRN() {
        postObject["MRN"] = self.MRN!
    }
    
    // returns the current time
    static func getCurrentTimeString() -> String {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        let current = NSDate()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        return dateFormatter.stringFromDate(current)
    }
    
    // logs the current time
    func recordCurrentTime() {
        postObject["date"] = SessionData.getCurrentTimeString()
    }
    
    // changes the label MRN to FIN (or Fin) just for logging purposes
    // if the database changes, this function should change / be removed
    func changeMRNtoFIN() {
        if (postObject.keys.contains("MRN")) {
            let replacement = postObject["Table"]! == "infeclog" ? "Fin" : "FIN"
            postObject[replacement] = postObject["MRN"]
            postObject.removeValueForKey("MRN")
        }
    }
    
    // for debugging
    func printData() {
        print(self.postObject)
    }

}