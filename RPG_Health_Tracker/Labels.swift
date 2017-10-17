//
//  Labels.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/6/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

extension UILabel
{
    var appearanceFont: UIFont
    {
        get { return self.font }
        set { self.font = newValue }
    }
    
    var appearanceFontName: String
    {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
    var appearanceFontColor: UIColor
    {
        get { return self.textColor }
        set { self.textColor = newValue }
    }
}

class testLabel : UILabel {}
