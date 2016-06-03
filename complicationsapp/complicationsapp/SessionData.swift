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
    var patientLogs : NSArray?
    var targetAction : String?
    var postObject : [String : String] = [:]
    
}