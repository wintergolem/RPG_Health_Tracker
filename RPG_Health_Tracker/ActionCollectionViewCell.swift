//
//  CollectionViewCell.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    //var switchChangeFunc : () -> () = {}
    var activeText : String = "active"
    var inactiveText : String = "inactive"
    var value : Int = -1
    
    @IBAction func activeSwitchChanged(_ sender: UISwitch)
    {
        //switchChangeFunc()
        
        if activeSwitch.isOn
        {
            titleLabel.text = activeText
        }
        else
        {
            titleLabel.text = inactiveText
        }
        CharacterManager.player.applyTypeChange( typeChange: value + 1 )
    }
}
