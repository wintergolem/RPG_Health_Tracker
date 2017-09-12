//
//  HealthResistenced20.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/5/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class HealthResistenced20
{
    var enabled: Bool = true
    var displayName : String = "UnNamed"
    var healthTrack : HealthTrackd20?
    var typeByte : UInt32 = 0
    var attackTypeWorksAgainst : d20AttackType = .NONE
    var value : Int = 0
    var op : d20ResistanceOperations = .subtraction
    var modificationText : String
    {
        return "Performed operation: \(op) \(value)"
    }
    
    init() {}
    
    func modifyDamage ( damage : Action20) -> Bool
    {
        //check if this mod works against this damage
        if !enabled || attackTypeWorksAgainst != damage.attackType || checkBypass(input: damage.damageType.damageByte)
        {
            //this resistance doesn't work against this attack
            return false
        }
        //see damage needs applied to healthtrack
        if healthTrack != nil
        {
            let damageType = Action20(newValue: value < damage.value ? value : damage.value, counter: CharacterManager.player.grabActionNumber(), damageType: DamageType() )
            _ = healthTrack?.takeDamage(damage: damageType)
            damage.undoWatchers.append
                {
                    self.healthTrack?.undoAction(value: damageType.value, actionWasHeal: false)
            }
        }
        //modify damage
        damage.value = Int.floor( selectOperation(damageValue: damage.value) )
        damage.modificationTracker.append(modificationText)
        return true
    }
    
    func checkBypass( input : UInt32) -> Bool
    {
        if input & typeByte == typeByte
        {
            return true
        }
        return false
    }
    
    func selectOperation( damageValue : Int) -> Int
    {
        switch op {
        case .addition:
            return damageValue + value
        case .subtraction:
            return damageValue - value
        case .multiplication:
            return damageValue * value
        case .division:
            return damageValue / value
        case .mod:
            return damageValue % value
        }
    }
}
