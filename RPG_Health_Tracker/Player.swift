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
    //MARK: - Healthtrack properties
    var mainHealthTrack : HealthTrackd20 = HealthTrackd20(displayName: "main", health: 100, destroyOnceEmpty: false)
    var nonLethalTrack : HealthTrackd20 = HealthTrackd20(displayName: "nonLethal", health: 100, destroyOnceEmpty: false)
    var beforeHealthTracks : [HealthTrackd20] = []
    var afterHealthTracks : [HealthTrackd20] = []
    var separateHealthTracks : [HealthTrackd20] = []
    var healthWatchers : [() -> ()] = []
    
    //MARK: - Action tracking properties
    var actionList : AccessorArray = AccessorArray<Action20>()
    var actionCount : Int = 0
    
    //MARK: - Resistance properties
    var resistanceList : AccessorArray = AccessorArray<HealthResistenced20>()
    
    //Mark: - Other properties
    var damageTypeList : AccessorArray = AccessorArray<String>()
    
    
    
    //MARK: - Properities
    init()
    {
        damageTypeList.array.append(contentsOf: ["Physical", "Fire", "Electric", "Cold", "Sonic", "Force", "Holy", "Good", "Evil"] )
        _ = resistanceList.addWatcher {
            self.reorderMods()
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
    }
    
    func reorderMods()
    {
        resistanceList.array = resistanceList.array.sorted {
            if $0.0.attackTypeWorksAgainst != $0.1.attackTypeWorksAgainst
            {
                if $0.0.attackTypeWorksAgainst == .DR
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
                return $0.0.value > $0.1.value
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
            for tracks in beforeHealthTracks
            {
                doDamage(track: tracks, damage: damage)
                if( damage.value == 0)
                {
                    return
                }
            }
        }
        
        //main
        doDamage(track: mainHealthTrack, damage: damage)
        
        //after
        if afterHealthTracks.count > 0
        {
            for tracks in afterHealthTracks
            {
                doDamage(track: tracks, damage: damage)
                if( damage.value == 0)
                {
                    return
                }
            }
        }

    }
    
    func doDamage( track : HealthTrackd20 , damage : Action20)
    {
        let leftover = track.takeDamage(damage: damage)
        if leftover != 0
        {
            damage.value -= leftover
        }
        else
        {
            damage.value = 0
        }

    }
    //MARK: - Healing
    func takeHeal(heal : Action20)
    {
        let lethalBool : Bool = heal.damageType.popFirst()
        if lethalBool
        {
            mainHealthTrack.healDamage(heal: heal)
        }
        else
        {
            nonLethalTrack.healDamage(heal: heal)
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
            separateHealthTracks.append(track)
        case .AFTER:
            afterHealthTracks.append(track)
        case .BEFORE:
            beforeHealthTracks.append(track)
        }
        return track
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
            beforeHealthTracks.forEach{ track in
                value += track.currentHealth
            }
            afterHealthTracks.forEach{ track in
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
