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
    var currentHealth : Int
    {
        if( damageList.count != 0)
        {
            return startingHealth
        }
        else
        {
            var health = startingHealth
            damageList.forEach{ dam in health - dam.value }
            return health
        }
    }
    var resistenceList : [HealthResistenced20] = []
    var damageList : [Damaged20] = []
    
    init()
    {
        startingHealth = 100
        currentHealth = maxHealth
    }
    
    func takeDamage( damage : Damaged20)
    {
        resistenceList.forEach{ resist in
            resist.modifyDamage(damage: damage) }
        damageList.append(damage)
    }
}
