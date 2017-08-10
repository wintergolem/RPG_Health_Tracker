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
