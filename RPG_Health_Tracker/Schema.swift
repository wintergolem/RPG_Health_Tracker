//
//  Schema.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/6/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class ColorsUsed
{
    static let example : UIColor = UIColor(red: 155, green: 155, blue: 155, alpha: 1.0)
}

class Schemas
{
    static let array : [ColorScheme] = [Schemas.standard]
    
    static let standard : ColorScheme = ColorScheme(mainColor: UIColor.red, textColor: UIColor.brown, barStyle: UIBarStyle.default, backgroundColor: UIColor.white, secondaryColor: UIColor.yellow , index: 0)
}
