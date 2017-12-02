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
    //MARK: - Properties
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
    var entity : ResistEntity!
    //MARK: - Methods
    init( resistEntity : ResistEntity)
    {
        entity = resistEntity
        enabled = entity.enabled
        displayName = entity.displayName!
        typeByte = UInt32(entity.typeByte)
        value = Int(entity.value)
        attackTypeWorksAgainst = d20AttackType(rawValue: entity.attackType!)!
        op = d20ResistanceOperations(rawValue: entity.operation!)!
    }
    
    func modifyDamage ( damage : Action20) -> Bool
    {
        //check if this mod works against this damage
        if !enabled || attackTypeWorksAgainst != damage.attackType || !checkBypass(input: damage.damageType.damageByte)
        {
            //this resistance doesn't work against this attack
            return false
        }
        //calculate damage done
        let newDamageValue =  Int.floor( selectOperation(damageValue: damage.value) )
        let damageDone = damage.value - newDamageValue
        //see damage needs applied to healthtrack
        if healthTrack != nil
        {
            let damageType = Action20(newValue: damageDone, counter: CharacterManager.player.grabActionNumber(), damageType: DamageType() )
            _ = healthTrack?.takeDamage(damage: damageType)
            damage.undoWatchers.append
                {
                    self.healthTrack?.undoAction(value: damageDone, actionWasHeal: false)
            }
        }
        //modify damage
        damage.value = newDamageValue
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
    
    func toEntity() -> ResistEntity
    {
        //let entity = CoreDataManager.singleton.grabResistEntity()
        entity.attackType = attackTypeWorksAgainst.rawValue
        entity.displayName = displayName
        entity.enabled = enabled
        entity.operation = op.toString()
        entity.typeByte = Int32(typeByte)
        entity.value = Int16(value)
        
        if( healthTrack != nil )
        {
            entity.ownedTrack = healthTrack?.toEntity()
        }
        
        return entity
    }
}
