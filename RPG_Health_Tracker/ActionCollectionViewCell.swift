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
    
    var switchChangeFunc : () -> () = {}
    
    @IBAction func activeSwitchChanged(_ sender: UISwitch)
    {
        switchChangeFunc()
    }
}
