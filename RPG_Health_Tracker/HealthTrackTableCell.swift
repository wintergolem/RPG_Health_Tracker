//
//  HealthTrackTableCell.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class HealthTrackTableCell: UITableViewCell {

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var healthDisplayLabel: UILabel!
    
    var updateFunc : () -> () = {}
    var displayType : d20HealthReturnType = .FULL
    var healthTrack : HealthTrackd20?
    
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
    
    func update()
    {
        if healthTrack != nil
        {
            healthDisplayLabel.text = healthTrack?.getHealthTrait(trait: displayType)
        }
        else
        {
            updateFunc()
        }
    }

}
