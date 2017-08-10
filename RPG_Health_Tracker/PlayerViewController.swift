//
//  PlayerViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var healthTrackTableView: UITableView!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var actionValueField: UITextField!
    
    var actionTypeByte : UInt32 = UInt32(3)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //delegates and datasources
        healthTrackTableView.dataSource = self
        actionCollectionView.dataSource = self
        actionCollectionView.delegate = self
        
        //adding done tool bars
        actionValueField.inputAccessoryView = UIToolbar.doneToolBar(#selector(self.doneButtonAction), target: self)
        
        //add watchers
        CharacterManager.player.mainHealthTrack.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        CharacterManager.player.nonLethalTrack.addWatcher {
            self.healthTrackTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func addActionButtonPressed(_ sender: UIButton)
    {
        //build damageType class
        let damageType = DamageType()
        damageType.damageByte = actionTypeByte
        damageType.damageTypeForDisplay.append("Not implemented yet")
        //grab value
        let value = Int(actionValueField.text!)!
        //create action
        let action = Action20(newValue: value, counter: CharacterManager.player.grabActionNumber(), damageType: damageType)
        //pass action to player
        CharacterManager.player.takeAction(action: action)
    }
}
