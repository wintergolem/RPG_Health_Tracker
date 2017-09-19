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
    //moved @IBOutlet weak var actionCollectionView: UICollectionView!
    //moved @IBOutlet weak var attackTypeSegCon: UISegmentedControl!
    @IBOutlet weak var actionValueCollectionView: UICollectionView!
    
    //MARK: - Properties
    //moved var actionTypeByte : UInt32 = UInt32(3)
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //delegates and datasources
        healthTrackTableView.dataSource = self
        //moved actionCollectionView.dataSource = self
        //moved actionCollectionView.delegate = self
        actionValueCollectionView.dataSource = self
        actionValueCollectionView.delegate = self
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    /* moved to stackview
    func determineAttackType() -> d20AttackType
    {
        switch attackTypeSegCon.selectedSegmentIndex
        {
        case 0:
            return .DR
        case 1:
            return .RESIST
        case 2:
            return .NONE
        default:
            return .DR
        }
        
    }*/
    
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
    }
    
    
}
