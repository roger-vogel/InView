//
//  States.swift
//  InView
//
//  Created by Roger Vogel on 10/3/22.
//

import Foundation

struct StateDetails {
    
    var name = String()
    var abbrev = String()
}

struct States {
    
    static var us: [StateDetails] = [
    
        StateDetails(name: "Alabama", abbrev: "AL"),
        StateDetails(name: "Alaska", abbrev: "AK"),
        StateDetails(name: "Arizona", abbrev: "AZ"),
        StateDetails(name: "Arkansas", abbrev: "AR"),
        StateDetails(name: "California", abbrev: "CA"),
        StateDetails(name: "Colorado", abbrev: "CO"),
        StateDetails(name: "Connecticut", abbrev: "CT"),
        StateDetails(name: "Delaware", abbrev: "DE"),
        StateDetails(name: "District of Columbia", abbrev: "DC"),
        StateDetails(name: "Arkansas", abbrev: "AR"),
        StateDetails(name: "Florida", abbrev: "FL"),
        StateDetails(name: "Georgia", abbrev: "GA"),
        StateDetails(name: "Hawaii", abbrev: "HI"),
        StateDetails(name: "Idaho", abbrev: "ID"),
        StateDetails(name: "Illinois", abbrev: "IL"),
        StateDetails(name: "Indiana", abbrev: "ID"),
        StateDetails(name: "Iowa", abbrev: "IA"),
        StateDetails(name: "Kansas", abbrev: "KS"),
        StateDetails(name: "Kentucky", abbrev: "KY"),
        StateDetails(name: "Louisiana", abbrev: "LA"),
        StateDetails(name: "Maine", abbrev: "ME"),
        StateDetails(name: "Maryland", abbrev: "MD"),
        StateDetails(name: "Massachusetts", abbrev: "MA"),
        StateDetails(name: "Michigan", abbrev: "MI"),
        StateDetails(name: "Minnesota", abbrev: "MN"),
        StateDetails(name: "Mississippi", abbrev: "MS"),
        StateDetails(name: "Missouri", abbrev: "MO"),
        StateDetails(name: "Montana", abbrev: "MT"),
        StateDetails(name: "Michigan", abbrev: "MI"),
        StateDetails(name: "Nebraska", abbrev: "NE"),
        StateDetails(name: "Nevada", abbrev: "NV"),
        StateDetails(name: "New Hampshire", abbrev: "NH"),
        StateDetails(name: "New Jersey", abbrev: "NJ"),
        StateDetails(name: "New Mexico", abbrev: "NM"),
        StateDetails(name: "New York", abbrev: "NY"),
        StateDetails(name: "North Carolina", abbrev: "NC"),
        StateDetails(name: "North Dakota", abbrev: "ND"),
        StateDetails(name: "Ohio", abbrev: "OH"),
        StateDetails(name: "Oklahoma", abbrev: "OK"),
        StateDetails(name: "Oregon", abbrev: "OR"),
        StateDetails(name: "Pennsylvania", abbrev: "PA"),
        StateDetails(name: "Rhode Island", abbrev: "RI"),
        StateDetails(name: "South Carolina", abbrev: "SC"),
        StateDetails(name: "South Dakota", abbrev: "SD"),
        StateDetails(name: "Tennessee", abbrev: "TN"),
        StateDetails(name: "Texas", abbrev: "TX"),
        StateDetails(name: "Utah", abbrev: "UT"),
        StateDetails(name: "Vermont", abbrev: "VT"),
        StateDetails(name: "Virginia", abbrev: "VA"),
        StateDetails(name: "Washington", abbrev: "WA"),
        StateDetails(name: "West Virginia", abbrev: "WV"),
        StateDetails(name: "Wisconsin", abbrev: "WI"),
        StateDetails(name: "Wyoming", abbrev: "WY"),
        StateDetails(name: "American Samoa", abbrev: "AS"),
        StateDetails(name: "Guam", abbrev: "GU"),
        StateDetails(name: "Northern Mariana Islands", abbrev: "MP"),
        StateDetails(name: "Puerto Rico", abbrev: "PR"),
        StateDetails(name: "US Virgin Islands", abbrev: "VI"),
        StateDetails(name: "Alberta", abbrev: "AB"),
        StateDetails(name: "British Columbia", abbrev: "BC"),
        StateDetails(name: "Manitoba", abbrev: "MB"),
        StateDetails(name: "New Brunswick", abbrev: "NB"),
        StateDetails(name: "Newfoundland and Labrador", abbrev: "NL"),
        StateDetails(name: "Northwest Territories", abbrev: "NT"),
        StateDetails(name: "Nova Scotia", abbrev: "NS"),
        StateDetails(name: "Nunavut", abbrev: "NU"),
        StateDetails(name: "Ontario", abbrev: "ON"),
        StateDetails(name: "Prince Edward Island", abbrev: "PE"),
        StateDetails(name: "Quebec", abbrev: "QC"),
        StateDetails(name: "Saskatchewan", abbrev: "NS"),
        StateDetails(name: "Yukon", abbrev: "YT")
    ]
    
    static func abbrevToName(abbrev: String) -> String {
        
        let filtered = us.filter { $0.abbrev == abbrev }
        
        if !filtered.isEmpty {
           
            return (us.filter { $0.abbrev == abbrev }).first!.name
        }
       
        return ""
    }
    
    static func nameToAbbrev(name: String) -> String {
        
        let filtered = us.filter { $0.name == name }
        
        if !filtered.isEmpty {
           
            return (us.filter { $0.name == name }).first!.abbrev
        }
      
        return ""
    }
    
    static func isValidState(theState: String) -> Bool {
        
        guard theState != "" else { return true }
        
        for state in us {
            
            if state.name == theState || state.abbrev == theState { return true }
        }
        
        return false
    }
    
    static func getStateName(theState: String) -> String {
        
        guard theState != "" else { return "" }
        
        if theState.count > 2  { return theState }
        else { return abbrevToName(abbrev: theState) }
    }
    
    static func isStateName(theState: String) -> Bool {
        
        for state in us {
            
            if state.name == theState { return true }
        }
        
        return false
    }
}
