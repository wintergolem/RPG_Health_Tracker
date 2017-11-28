//
//  Primitives.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/9/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

extension Bool
{
    static func & ( a : Bool , b : Bool) -> Bool
    {
        if a && a == b
        {
            return true
        }
        else
        {
            return false
        }
    }
}

extension Int
{
    //MARK: Floor
    mutating func subtractWithFloor(_ subtractValue: Int)
    {
        subtractWithFloor(subtractValue, 0)
    }
    mutating func subtractWithFloor(_ subtractValue : Int ,_ floor: Int)
    {
        self = Int.floor(self - subtractValue, floor)
    }
    static func floor(_ a: Int) -> Int
    {
        return floor(a, 0)
    }
    static func floor(_ value: Int ,_ floor: Int) -> Int
    {
        return value > floor ? value : floor
    }
    
    //MARK: Ceilling
    /*mutating func addWithCeiling(_ addValue: Int)
    {
        addWithCeiling(addValue, 0)
    }*/
    mutating func addWithCeiling(_ addValue : Int , _ ceiling : Int)
    {
        self = Int.ceiling(self + addValue, ceiling)
    }
    static func ceiling(_ a : Int ) -> Int
    {
        return ceiling( a , 0)
    }
    static func ceiling(_ a : Int , _ ceiling : Int ) -> Int
    {
        return a < ceiling ? a : ceiling
    }
}

extension Array where Iterator.Element == Bool
{
    var allTrue: Bool
    {
        for i in 0...self.count - 1
        {
            if self[i] == false
            {
                return false
            }
        }
        return true
    }
    
    func firstValue( mask: Bool) -> Int
    {
        for i in 0...count - 1
        {
            if self[i] == mask
            {
                return i
            }
        }
        print("*************** ERROR ************** no \(mask) in current bool array")
        return -1
    }
}
