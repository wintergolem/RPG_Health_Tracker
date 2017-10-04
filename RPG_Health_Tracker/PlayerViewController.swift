//
//  PlayerViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var healthTrackTableView: UITableView!
    @IBOutlet weak var actionValueCollectionView: UICollectionView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var DamageOrHealSegCon: UISegmentedControl!
    @IBOutlet weak var maxHealButton: UIButton!
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //delegates and datasources
        healthTrackTableView.dataSource = self
        actionValueCollectionView.dataSource = self
        actionValueCollectionView.delegate = self
        //register xib to collectionView
        let valueNib = UINib(nibName: "CountingCell", bundle: nil)
        actionValueCollectionView.register(valueNib, forCellWithReuseIdentifier: "Count")
        actionValueCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //add watchers
        CharacterManager.player.mainHealthTrack.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        CharacterManager.player.nonLethalTrack.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        _ = CharacterManager.player.beforeHealthTracks.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        _ = CharacterManager.player.afterHealthTracks.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        _ = CharacterManager.player.separateHealthTracks.addWatcher {
            self.healthTrackTableView.reloadData()
        }
        //disable UI
        checkUiStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func addAction (value : Int)
    {
        //build damageType Class
        let damageType = DamageType()
        damageType.damageByte = CharacterManager.player.actionTypeByte
        damageType.damageTypeForDisplay.append("Not implemented yet")
        
        let attackType : d20AttackType = CharacterManager.player.currentAttackType
        
        let action = Action20(newValue: value, counter: CharacterManager.player.grabActionNumber(), damageType: damageType)
        action.attackType = attackType
        CharacterManager.player.takeAction(action: action)
        checkUiStatus()
    }
    
    func checkUiStatus()
    {
        undoButton.isEnabled = CharacterManager.player.actionList.count != 0
        maxHealButton.isEnabled = CharacterManager.player.atMaxHealth
    }
    
    //MARK: - Actions
    @IBAction func undoButtonPress(_ sender: UIButton)
    {
        CharacterManager.player.undoLastAction()
        checkUiStatus()
    }
    @IBAction func maxHealButtonPress(_ sender: UIButton)
    {
        checkUiStatus()
    }
    @IBAction func damageOrHealSegConChanged(_ sender: UISegmentedControl)
    {
        CharacterManager.player.applyTypeChange(typeChange: 0)
    }
    
}
