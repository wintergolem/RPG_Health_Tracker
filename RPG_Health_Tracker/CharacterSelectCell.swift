//
//  CharacterSelectCell.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/13/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class CharacterSelectCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
