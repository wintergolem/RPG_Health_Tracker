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
    var _maxHealth : Int = 0
    var _currentHealth : Int = 0
    var maxHealth : Int
    {
        get
        {
            return _maxHealth
        }
        set
        {
            _maxHealth = newValue
            callWatchers()
        }
    }
    var currentHealth : Int
    {
        get
        {
            return _currentHealth
        }
        set
        {
            _currentHealth = newValue
            callWatchers()
        }
    }
    var destoryIfDepleted : Bool
    var displayName : String
    var watchers : [()->()] = []
    var entity : HealthTrackEntity = CoreDataManager.singleton.grabTrackEntity()
    var locationMark : Int = -1
    // tens digit: 0-mainline 1-before 2-after 3-separate
    // ones digit: (mainline only) 0-lethal 1-nonlethal
    
    init( displayName : String , health : Int , destroyOnceEmpty : Bool , locationMark : Int)
    {
        self.displayName = displayName
        destoryIfDepleted = destroyOnceEmpty
        maxHealth = health
        currentHealth = health
        self.locationMark = locationMark
    }
    
    //MARK: - Damage
    func takeDamage( damage : Action20) -> Int //return unused amount, default to zero if all is used
    {
        let damageValue = damage.value
        if currentHealth < damage.value
        {
            let unused = damageValue - currentHealth
            currentHealth = 0
            damage.undoWatchers.append
                {
                self.undoAction(value: damageValue - unused, actionWasHeal: false)
            }
            return unused
        }
        else
        {
            currentHealth -= damageValue
            damage.undoWatchers.append
                {
                    self.undoAction(value: damageValue, actionWasHeal: false)
            }
            return 0
        }
    }
    
    //MARK: - Healing
    func healDamage( heal : Action20)
    {
        let healValue = heal.value
        currentHealth.addWithCeiling( healValue , maxHealth)
    }
    
    func checkHealExceed(amount : Int) -> Bool
    {
        return amount > (maxHealth - currentHealth)
    }
    
    //MARK: - Undo
    func undoAction( value: Int , actionWasHeal : Bool)
    {
        if actionWasHeal
        {
            currentHealth -= value
        }
        else
        {
            currentHealth += value
        }
        //callWatchers()
    }
    
    //MARK: - Display
    func getHealthTrait( trait : d20HealthReturnType) -> String
    {
        switch trait {
        case .FULL:
            return "\(_currentHealth) / \(_maxHealth)"
        case .AVAIL:
            return "\(_maxHealth - ( _maxHealth - _currentHealth ) )"
        case .DAMAGEDONE:
            return "\(_maxHealth - _currentHealth)"
        default:
            return "\(_maxHealth)"
        }
    }
    //MARK: - Misc
    func healCeiling(amount : Int) -> Int
    {
        let damageTotal = maxHealth - currentHealth
        return damageTotal > amount ? damageTotal : amount
    }

    func addWatcher( watcher: @escaping ()->() )
    {
        watchers.append(watcher)
    }
    
    func callWatchers()
    {
        watchers.forEach{ watcher in
            watcher()
        }
    }
    
    func damageDone() -> Int
    {
        return _maxHealth - _currentHealth
    }
    
    func toEntity()-> HealthTrackEntity
    {
        entity.currentHealth = Int16(_currentHealth)
        entity.maxHealth = Int16(_maxHealth)
        entity.displayName = displayName
        entity.destoryIfDepleted = destoryIfDepleted
        entity.locationMark = Int16(locationMark)
        return entity
    }
}
