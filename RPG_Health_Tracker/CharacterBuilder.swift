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
            let char : Player = Player(displayName: character.displayName! , maxHealth: 0 , loading: true)//max Health will be overwritten
            //action tracking
            char.actionCount = 0 //actionCounter resets whenever we are in a state where this runs
            //transfer healthTracks
            for trackEnt in character.healthTracks!
            {
                let track = trackEnt as! HealthTrackEntity
                switch track.locationMark
                {
                case 0:
                    char.mainHealthTrack = HealthTrackd20(trackEntity: track)
                case 1:
                    char.nonLethalTrack = HealthTrackd20(trackEntity: track)
                case 10:
                    char.beforeHealthTracks.append(newValue: HealthTrackd20(trackEntity: track))
                case 20:
                    char.afterHealthTracks.append(newValue: HealthTrackd20(trackEntity: track))
                case 30:
                    char.separateHealthTracks.append(newValue: HealthTrackd20(trackEntity: track))
                default:
                    print("Error determining track - \(track.locationMark) is not a valid option")
                }
            }
            //transfer resistances
            for resistEntUnSafe in character.resistances!
            {
                let resistEnt = resistEntUnSafe as! ResistEntity
                let resist = HealthResistenced20(resistEntity: resistEnt)
                if resistEnt.ownedTrack != nil
                {
                    let track = HealthTrackd20(trackEntity: resistEnt.ownedTrack!)
                    resist.healthTrack = char.addHealthTrack(track: track, type: locationMarkToTrackType(track.locationMark), saveEntity: false)
                }
                char.addResist(resist: resist)
            }
            char.entity = character
            
            returnArray.append(char)
        }
        
        return returnArray
    }
    
    fileprivate static func locationMarkToTrackType( _ locationMark : Int) -> d20TrackType
    {
        switch locationMark
        {
        case 10:
            return .BEFORE
        case 20:
            return .AFTER
        case 30:
            return .SEPARATE
        default:
            print("Error determining track - \(locationMark) is not a valid option")
            return .SEPARATE
        }
    }
}
