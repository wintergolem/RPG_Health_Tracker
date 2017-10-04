//
//  Character.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/31/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class Player
{
    //MARK: - General Properties
    var displayName : String = "TempName"
    var atMaxHealth : Bool
    {
        return mainHealthTrack.damageDone() == 0 &&
        nonLethalTrack.damageDone() == 0
    }
    //MARK: - Healthtrack properties
    var mainHealthTrack : HealthTrackd20 = HealthTrackd20(displayName: "main", health: 100, destroyOnceEmpty: false)
    var nonLethalTrack : HealthTrackd20 = HealthTrackd20(displayName: "nonLethal", health: 100, destroyOnceEmpty: false)
    var beforeHealthTracks : AccessorArray<HealthTrackd20> = AccessorArray<HealthTrackd20>()
    var afterHealthTracks : AccessorArray<HealthTrackd20> = AccessorArray<HealthTrackd20>()
    var separateHealthTracks : AccessorArray<HealthTrackd20> = AccessorArray<HealthTrackd20>()
    var healthWatchers : [() -> ()] = []
    
    //MARK: - Action tracking properties
    var actionList : AccessorArray = AccessorArray<Action20>()
    var actionCount : Int = 0
    
    //MARK: - Resistance properties
    var resistanceList : AccessorArray = AccessorArray<HealthResistenced20>()
    var actionTypeByte : UInt32 = UInt32(3)
    
    //Mark: - Other properties
    //moved var damageTypeList : AccessorArray = AccessorArray<String>()
    var currentAttackType : d20AttackType = .NONE
    
    
    //MARK: - Methods
    init( displayName: String , maxHealth : Int, _ testChar : Bool = false )
    {
        self.displayName = displayName
        mainHealthTrack.maxHealth = maxHealth
        mainHealthTrack.currentHealth = maxHealth
        nonLethalTrack.maxHealth = maxHealth
        nonLethalTrack.currentHealth = maxHealth
        //add watcher to reorder damage mods anytime array changes
        _ = resistanceList.addWatcher {
            self.reorderMods()
        }
        if testChar
        {
            //add test extra healthtracks
            _ = addHealthTrack(name: "AfterTest", maxHealth: 100, currentHealth: 100, type: .AFTER, destoryOnceEmpty: false)
            _ = addHealthTrack(name: "BeforeTest", maxHealth: 100, type: .BEFORE, destoryOnceEmpty: false)
            _ = addHealthTrack(name: "SeperateTest", maxHealth: 100, type: .SEPARATE)
            
            //add test resistances
            //fire
            let resistTemp : HealthResistenced20 = HealthResistenced20()
            resistTemp.attackTypeWorksAgainst = .RESIST
            resistTemp.displayName = "Fire Resist"
            resistTemp.op = .subtraction
            resistTemp.typeByte = UInt32(4)
            resistTemp.value = 5
            resistanceList.append(newValue: resistTemp)
            
            //slashing
            let slashTemp : HealthResistenced20 = HealthResistenced20()
            slashTemp.attackTypeWorksAgainst = .DR
            slashTemp.displayName = "Slashing DR"
            slashTemp.op = .subtraction
            slashTemp.typeByte = UInt32(2)
            slashTemp.value = 5
            resistanceList.append(newValue: slashTemp)
        }
    }
    
    func takeAction( action: Action20)
    {
        let damageBool = action.damageType.popFirst()
        if damageBool
        {
            takeDamage(damage: action)
        }
        else
        {
            takeHeal(heal: action)
        }
        actionList.append(newValue: action)
    }
    
    func reorderMods()
    {
        resistanceList.array = resistanceList.array.sorted {
            if $0.attackTypeWorksAgainst != $1.attackTypeWorksAgainst
            {
                if $0.attackTypeWorksAgainst == .DR
                {
                    return true
                }
                else
                {
                    return false
                }
            }
            else
            {
                return $0.value > $1.value
            }
            
        }
    }
    //MARK: - Damage
    func takeDamage( damage: Action20)
    {
        //run damage through mods
        for res in resistanceList.array
        {
            if res.modifyDamage(damage: damage)
            {
                break
            }
        }
        
        
        //check nonlethal
        let lethalBool = damage.damageType.popFirst()
        if !lethalBool
        {
            doDamage(track: nonLethalTrack , damage: damage)
        }
        
        //before
        if beforeHealthTracks.count > 0
        {
            for track in beforeHealthTracks.array
            {
                doDamage(track: track, damage: damage)
                if( damage.value <= 0)
                {
                    beforeHealthTracks.callWatchers()
                    return
                }
            }
            beforeHealthTracks.callWatchers()
        }
        
        //main
        doDamage(track: mainHealthTrack, damage: damage)
        
        //after
        if afterHealthTracks.count > 0
        {
            for tracks in afterHealthTracks.array
            {
                doDamage(track: tracks, damage: damage)
                if( damage.value <= 0)
                {
                    afterHealthTracks.callWatchers()
                    return
                }
            }
            afterHealthTracks.callWatchers()
        }

    }
    
    func doDamage( track : HealthTrackd20 , damage : Action20)
    {
        damage.value = track.takeDamage(damage: damage)
        //damage.value.subtractWithFloor( leftover )
        //damage.value = leftover

    }
    //MARK: - Healing
    func takeHeal(heal : Action20)
    {
        nonLethalTrack.healDamage(heal: heal)
        let lethalBool : Bool = heal.damageType.popFirst()
        if lethalBool
        {
            mainHealthTrack.healDamage(heal: heal)
        }
    }
    //MARK: - Undo's
    func undoLastAction()
    {
        //grab last action's number 
        //figure all healthtracks' touched
        //send undo damage to all touched
        
        let action = actionList.popLast()
        action.undo()
        
    }
    
    func grabActionNumber() -> Int
    {
        actionCount += 1
        return actionCount - 1
    }
    
    //MARK: - Healthtracks
    func addHealthTrack( maxHealth : Int , type : d20TrackType, destroyOnceEmpty : Bool = false)
    {
            _ = addHealthTrack(name: "Temp", maxHealth: maxHealth, type: type)
    }
    
    func addHealthTrack( name : String , maxHealth : Int , currentHealth : Int = -1 , type : d20TrackType , destoryOnceEmpty : Bool = false) -> HealthTrackd20
    {
        let track = HealthTrackd20(displayName: name, health: maxHealth, destroyOnceEmpty: destoryOnceEmpty)
        if currentHealth != -1
        {
            track.currentHealth = currentHealth
        }
        
        switch type {
        case .SEPARATE:
            track.addWatcher {
                self.separateHealthTracks.callWatchers()
            }
            separateHealthTracks.append(newValue: track)
        case .AFTER:
            track.addWatcher {
            self.afterHealthTracks.callWatchers()
        }
            afterHealthTracks.append(newValue: track)
        case .BEFORE:
            track.addWatcher {
                self.beforeHealthTracks.callWatchers()
            }
            beforeHealthTracks.append(newValue: track)
        }
        return track
    }
    
    //Mark: - Resistance
    func applyTypeChange( typeChange : Int )
    {
        actionTypeByte = actionTypeByte ^ UInt32(1 << typeChange)
    }
    
    //MARK: - Display
    func getHealthForDisplay( displayType : d20HealthReturnType) -> String
    {
        var returnString = ""
        if( displayType == .FULL || displayType == .LETHAL)
        {
            returnString.append(mainHealthTrack.getHealthTrait(trait: .FULL))
        }
        if ( displayType == .FULL)
        {
                returnString.append("-\(nonLethalTrack.getHealthTrait(trait: .DAMAGEDONE)) NL")
        }
        if( displayType == .AVAIL)
        {
            var value = mainHealthTrack._currentHealth - nonLethalTrack.damageDone() //add main w/ nonlethal
            beforeHealthTracks.array.forEach{ track in
                value += track.currentHealth
            }
            afterHealthTracks.array.forEach{ track in
                value += track.currentHealth
            }
            
            returnString.append("\(value)")
        }
        if (displayType == .SINGLE)
        {
            returnString.append("\(mainHealthTrack._currentHealth)")
        }
        if( displayType == .NONLETHAL)
        {
            returnString.append("\(nonLethalTrack.damageDone())")
        }
        return returnString
    }
    
}
