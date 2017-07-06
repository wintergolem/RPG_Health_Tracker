//
//  HealthTrack.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/5/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class HealthTrackd20
{
    var startingHealth : Int
    
    var resistenceList : [HealthResistenced20] = []
    var damageList : [Damaged20] = []
    var damageTypeList : [DamageTyped20] = []
    
    init()
    {
        startingHealth = 100
        
        var lethal : DamageTyped20 = DamageTyped20()
        lethal.damageType = "lethal"
        damageTypeList.append(lethal)
    }
    
    func takeDamage( damage : Damaged20)
    {
        resistenceList.forEach{ resist in
            resist.modifyDamage(damage: damage) }
        damageList.append(damage)
    }
    
    func undoLastDamage()
    {
       _ = damageList.popLast()
    }
    
    func getCurrentHealth() -> String
    {
        if( damageList.count == 0)
        {
            return "\(startingHealth)"
        }
        
        damageList.forEach{ dam in
            
        }
        var returnString = ""
        damageTotals.forEach{ total in
            if ( total.key == "lethal")
            {
                returnString = "\(startingHealth - total.value) / \(startingHealth) - " + returnString
            }
            else
            {
                returnString.append("\(total.key) - \(total.value)")
            }
        }
        return returnString
    }
}
