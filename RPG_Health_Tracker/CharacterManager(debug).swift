//
//  CharacterManager(debug).swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class CharacterManager
{
    static var player : Player = Player()
    
    init()
    {
        //add test extra healthtracks
        _ = CharacterManager.player.addHealthTrack(name: "AfterTest", maxHealth: 100, currentHealth: 100, type: .AFTER, destoryOnceEmpty: false)
        _ = CharacterManager.player.addHealthTrack(name: "BeforeTest", maxHealth: 100, type: .BEFORE, destoryOnceEmpty: false)
        
        //add test resistances
            //fire
        let resistTemp : HealthResistenced20 = HealthResistenced20()
        resistTemp.attackTypeWorksAgainst = .RESIST
        resistTemp.displayName = "Test Fire Resist"
        resistTemp.op = .subtraction
        resistTemp.typeByte = UInt32(11)
        resistTemp.value = 5
        CharacterManager.player.resistanceList.append(newValue: resistTemp)
        
            //slashing
        let slashTemp : HealthResistenced20 = HealthResistenced20()
        resistTemp.attackTypeWorksAgainst = .DR
        resistTemp.displayName = "Test Slashing DR"
        resistTemp.op = .subtraction
        resistTemp.typeByte = UInt32(7)
        resistTemp.value = 5
        CharacterManager.player.resistanceList.append(newValue: slashTemp)
        
    }
}
