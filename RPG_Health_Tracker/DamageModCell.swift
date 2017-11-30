//
//  modCell.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/4/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class DamageModCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var resetButton: UIButton!
    
    var switchAction : ()->() = {}
    var resetAction : ()->() = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchChanged(_ sender: UISwitch)
    {
        switchAction()
    }
    @IBAction func resetButtonPressed(_ sender: UIButton)
    {
        resetAction()
    }
}
