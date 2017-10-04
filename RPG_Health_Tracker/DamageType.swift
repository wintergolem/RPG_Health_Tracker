//
//  DamageType.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class DamageType
{
    //1.Damage OR Heal
    //2.Lethal OR Nonlethal
    //3+Rest
    var damageTypeForDisplay : [String] = []
    var damageByte : UInt32 = UInt32()
    
    init()
    {
        
    }
    
    func convertToByte( temp : [Bool] ) -> UInt32
    {
        var returnInt = UInt32()
        var loopCount : Int = 0
        temp.forEach { bo in
            if bo
            {
                returnInt = returnInt + UInt32(1 << loopCount)
            }
            loopCount += 1
        }
        
        return returnInt
    }
    
    func popFirst() -> Bool
    {
        let returnBool : Bool = Bool(truncating: damageByte & UInt32(1) as NSNumber) //<- so ugly
        damageByte = damageByte >> 1
        return returnBool
    }
    
    func displayType() -> String
    {
        return damageTypeForDisplay.first!
    }
}
