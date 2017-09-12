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
    
    init( displayName : String , health : Int , destroyOnceEmpty : Bool)
    {
        self.displayName = displayName
        destoryIfDepleted = destroyOnceEmpty
        maxHealth = health
        currentHealth = health
    }
    
    //MARK: - Damage
    func takeDamage( damage : Action20) -> Int //return unused amount, default to zero if all is used
    {
        if currentHealth < damage.value
        {
            let unused = damage.value - currentHealth
            currentHealth = 0
            damage.undoWatchers.append
                {
                self.undoAction(value: damage.value - unused, actionWasHeal: false)
            }
            return unused
        }
        else
        {
            currentHealth -= damage.value
            damage.undoWatchers.append
                {
                    self.undoAction(value: damage.value, actionWasHeal: false)
            }
            return 0
        }
    }
    
    //MARK: - Healing
    func healDamage( heal : Action20)
    {
        currentHealth.addWithCeiling( heal.value , maxHealth)
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
}
