//
//  d20Enums.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/7/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

enum d20HealthReturnType
{
    case FULL , LETHAL , AVAIL , SINGLE , DAMAGEDONE , NONLETHAL
}

enum d20ResistanceOperations : String
{
    case addition = "+" , subtraction = "-"
    case multiplication = "*" , division = "/" , mod = "%"
    
    static let numberOf : Int = 5
    
    func toString() -> String
    {
        return String(self.rawValue)
    }
    
    static func getValueFromInt(_ value : Int) -> d20ResistanceOperations
    {
        switch value {
        case 0:
            return d20ResistanceOperations.addition
        case 1:
            return d20ResistanceOperations.division
        case 2:
            return d20ResistanceOperations.subtraction
        case 3:
            return d20ResistanceOperations.mod
        case 4:
            return d20ResistanceOperations.multiplication
        default:
            print("No operation for \(value) - d20ResistanceOperation.getValueFromInt")
            return d20ResistanceOperations.addition
        }
    }
}


enum d20TrackType
{
    case SEPARATE , BEFORE , AFTER
}

enum d20AttackType : String
{
    case DR = "DR", RESIST = "RESIST" , NONE = "NONE"
}
