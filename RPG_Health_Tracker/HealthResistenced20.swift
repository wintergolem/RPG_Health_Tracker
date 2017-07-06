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
    var typeName : String = ""
    var triggerOnSameType : Bool = true
    var value : Int = 0
    var op : Character = "+"
    var modificationText : String
    {
        return "Performed operation: \(op) \(value)"
    }
    
    init() {}
    
    func modifyDamage ( damage : Damaged20)
    {
        //TEST: if modifying the class passes through correctly
        if( (triggerOnSameType && typeName == damage.damageType)  ||
            ( !triggerOnSameType && typeName != damage.damageType))
        {
            damage.value = selectOperation(damageValue: damage.value)
            damage.modificationTracker.append(modificationText)
        }
    }
    
    func selectOperation( damageValue : Int) -> Int
    {
        switch op {
        case "+":
            return damageValue + value
        case d20ConstantStrings.OperationTypes.subtraction:
            return damageValue - value
        case d20ConstantStrings.OperationTypes.multiplication:
            return damageValue * value
        case d20ConstantStrings.OperationTypes.division:
            return damageValue / value
        case d20ConstantStrings.OperationTypes.mod:
            return damageValue % value
        default:
            print("HealthResistance - selectOperation: couldn't find equation for \(op)")
            return 0
        }
    }
}
