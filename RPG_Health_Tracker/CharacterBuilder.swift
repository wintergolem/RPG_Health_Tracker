//
//  CharacterBuilder.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/27/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class CharacterBuilder
{
    //MARK: Singleton
    static let singleton : CharacterBuilder = CharacterBuilder()
    
    static func buildPlayers( entities : [CharacterEntity]) -> [Player]
    {
        var returnArray : [Player] = [Player]()
        for character in entities
        {
            let char : Player = Player(displayName: character.displayName! , maxHealth: 0)//max Health will be overwritten
            //action tracking
            char.actionCount = 0 //actionCounter resets whenever we are in a state where this runs
            //transfer healthTracks
            for trackEnt in character.healthTracks!
            {
                let track = trackEnt as! HealthTrackEntity
                switch track.locationMark
                {
                case 0:
                    char.mainHealthTrack = buildTrack(entity: track)
                case 1:
                    char.nonLethalTrack = buildTrack(entity: track)
                case 2:
                    char.beforeHealthTracks.append(newValue: buildTrack(entity: track))
                case 3:
                    char.afterHealthTracks.append(newValue: buildTrack(entity: track))
                case 4:
                    char.separateHealthTracks.append(newValue: buildTrack(entity: track))
                default:
                    print("Error determining track - \(track.locationMark) is not a valid option")
                }
            }
            //transfer resistances
            for resistEntUnSafe in character.resistances!
            {
                let resistEnt = resistEntUnSafe as! ResistEntity
                let resist = HealthResistenced20()
                resist.enabled = resistEnt.enabled
                resist.displayName = resistEnt.displayName!
                resist.healthTrack = buildTrack(entity: resistEnt.ownedTrack!)
                resist.typeByte = UInt32(resistEnt.typeByte)
                resist.value = Int(resistEnt.value)
                resist.op = d20ResistanceOperations.getValueFromInt( Int(resistEnt.operation) )
                
                char.resistanceList.append(newValue: resist)
            }
            
            
            returnArray.append(char)
        }
        
        return returnArray
    }
    
    static func buildTrack( entity : HealthTrackEntity ) -> HealthTrackd20
    {
        let returnTrack = HealthTrackd20(
            displayName: entity.displayName!,
            health: Int(entity.maxHealth),
            destroyOnceEmpty: entity.destoryIfDepleted)
        returnTrack._currentHealth = Int(entity.currentHealth)
        return returnTrack
    }
}
