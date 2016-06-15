//
//  NetworkHandler.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/27/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation

class NetworkHandler {
    let myURL : NSURL
    var targetAction : String
    var postString : String
    
    init(url: String, targetAction: String, args: [String : String]) {
        myURL = NSURL(string: url)!
        self.targetAction = targetAction
        postString = ""
        postString = "targetAction=\(targetAction)&" + convertDictionaryToHTTPString(args)
    }
    
    func postToServer() -> String {
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        var serverResponse : String?
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for fundamental networking error
            guard error == nil && data != nil else {
                print("error = \(error)")
                return
            }
            
            // Check for http errors
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            switch self.targetAction {
            case "checkFIN": break
            case "requestLogs":
                let responseArray = self.convertStringToArray(responseString! as String)
                let responseDict = self.convertLogArrayToDictionary(responseArray as! [NSDictionary])
                SessionData.sharedInstance.patientLogs = responseDict
                print(SessionData.sharedInstance.patientLogs)
            case "addLog":
                print("Added log to database with arguments \(SessionData.sharedInstance.postObject)")
            case "checkConflicts":
                serverResponse = NetworkHandler.joinBy(self.convertStringToArray(responseString as! String)!, sep: "\n")
            default: print("Invalid targetAction \(self.targetAction)")
            }
            
            serverResponse = serverResponse == nil ? String(responseString!) : serverResponse
            
//            // If request sent to check patient MRN in system
//            if (self.targetAction == "checkFIN") {
//                
//            }
//            
//            // If request sent to check patient logs
//            if (self.targetAction == "requestLogs") {
//                let responseArray = self.convertStringToArray(responseString! as String)
//                let responseDict = self.convertLogArrayToDictionary(responseArray as! [NSDictionary])
//                SessionData.sharedInstance.patientLogs = responseDict
//                print(SessionData.sharedInstance.patientLogs)
//            }
//            
//            // If request sent to add to logs
//            if (self.targetAction == "addLog") {
//                
//            }
            
        }
        task.resume()
        print("posted \(postString)")
        while (serverResponse == nil) {
            // wait until serverResponse is filled
        }
        return serverResponse!
        
    }
    
    func convertStringToArray(text: String) -> NSArray? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.MutableContainers, .AllowFragments, .MutableLeaves]) as? NSArray
                return json
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    // Note: None of the strings in args can have any spaces in them!
    func convertDictionaryToHTTPString(args: [String : String]) -> String {
        var resultString = ""
        for (key, value) in args {
            resultString += "\(key)=\(value)&"
        }
        return String(resultString.characters.dropLast())
    }
    
    // Converts the patient log (an array of objects) into a single dictionary
    func convertLogArrayToDictionary(patientLog: [NSDictionary]) -> [String : [String]] {
        var result = [String : [String]]()
        for comp in patientLog {
            result[comp["table"] as! String] = comp["dates"] as? [String]
        }
        return result
    }
    
    static func joinBy(arr : NSArray, sep : String) -> String {
        var result = ""
        for item in arr {
            result += "\(item) "
        }
        result = String(result.characters.dropLast().dropLast().dropLast().dropFirst().dropFirst())
        return result
    }
}