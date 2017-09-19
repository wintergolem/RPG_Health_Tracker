//
//  DamageTypeCatalogued.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/18/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class DamageTypeCatalogued
{
    static var physical : [String] = ["Slashing" , "Bludgeon" , "Piercing" , "Holy" , "UnHoly" , "Good" , "Evil"]
    
    static var energy : [String] = ["Fire" , "Cold" , "Electricity" , "Acid" , "Sonic"]
    
    static var totalCount : Int
    {
        get
        {
            return physical.count + energy.count
        }
        set
        {}
    }
    
    static func getTextForValue (_ value : Int , _ attackType : d20AttackType) -> String
    {
        if value < 0
        {
            print("No Damage type for value (too low): \(value)")
            return "Error"
        }
        switch attackType {
        case .DR:
            return value < physical.count ? physical[value] : "Error(Too High)"
        case .RESIST:
            return value < energy.count ? energy[value] : "Error(Too High)"
        case .NONE:
            return ""
        }
    }
}
