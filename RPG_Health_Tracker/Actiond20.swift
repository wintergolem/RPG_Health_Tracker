//
//  Damaged20.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/5/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class Action20
{
    //MARK: - Damage
    var damageType : DamageType = DamageType()
    var lethal : Bool = true
    var hitWithDR : Bool = false
    var attackType : d20AttackType = .NONE
    
    //MARK: - Universal
    var startingValue : Int //value entered by user
    var value : Int  //value after mods
    var modificationTracker : [String] = [""]
    var counter : Int    //number used to track order of events
    
    //MARK: - HealthTracks touched
    var undoWatchers : [() -> ()] = []
    
    
    //MARK: - Methods
    init( newValue : Int , counter : Int , damageType : DamageType)
    {
        startingValue = newValue
        value = startingValue
        self.counter = counter
        self.damageType = damageType
    }
    
    func toString() -> String
    {
        var returnString = ""
        modificationTracker.forEach { str in
            returnString.append(str + "\n")
        }
        return returnString
    }
    
    func undo()
    {
        undoWatchers.forEach{ element in
            element()
        }
    }
}
