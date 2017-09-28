//
//  DamageModCreationViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/4/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class DamageModCreationViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var modNameField: UITextField!
    @IBOutlet weak var modValueField: UITextField!
    @IBOutlet weak var resistTypeSegCon: UISegmentedControl!
    @IBOutlet weak var opField: UITextField!
    @IBOutlet weak var addTrackSeg: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var damageTypeTable: UICollectionView!
    @IBOutlet weak var modTable: UITableView!
    
    //MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIButton)
    {
        let newMod = HealthResistenced20()
        newMod.typeByte = actionTypeByte
        newMod.displayName = modNameField.text!
        newMod.op = activeOperation
        newMod.attackTypeWorksAgainst = activeAttackType
        newMod.value = Int(modValueField.text!)!
        if addTrackSeg.isOn
        {
            addHealthTrackAlert(newMod: newMod)
            //CharacterManager.player.addHealthTrack(maxHealth: 100, type: .SEPARATE)
            //TODO: attach track to resistance
        }
        else
        {
            CharacterManager.player.resistanceList.append(newValue: newMod)
        }
    }
    
    @IBAction func resistTypeSegConValueChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            activeAttackType = .DR
        case 1: activeAttackType = .RESIST
        case 2: activeAttackType = .NONE
        default:
            activeAttackType = .NONE
        }
        damageTypeTable.reloadData()
    }
    //MARK: - Properities
    var actionTypeByte : UInt32 = UInt32()
    var activeOperation : d20ResistanceOperations = d20ResistanceOperations.subtraction
    var activeAttackType : d20AttackType = .DR
    
    //MARK: Lazy Properities
    lazy var doneToolBar : UIToolbar = UIToolbar.doneToolBar(#selector(self.doneButtonAction), target: self)
    lazy var operationPickerView : UIPickerView =
        {
            var temp = UIPickerView()
            temp.delegate = self
            temp.dataSource = self
            return temp
    }()
    
    //MARK: Watcher properities
    var modTableWatcherNumber : Int = 0
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //setup damageTypeTable
        damageTypeTable.dataSource = self
        damageTypeTable.delegate = self
        
        //setup modTable
        modTable.dataSource = self
        
        //setup operationField
        opField.inputView = operationPickerView
        opField.inputAccessoryView = doneToolBar
        opField.text = activeOperation.toString()
        
        //add done tool to views
        modNameField.inputAccessoryView = doneToolBar
        modValueField.inputAccessoryView = doneToolBar
        
        //setup listeners
        modTableWatcherNumber = CharacterManager.player.resistanceList.addWatcher()
            {
            self.modTable.reloadData()
        }
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    //MARK: - UI Alert (health track)
    weak var actionToEnable : UIAlertAction?
    var valuePassed : Bool = false
    var namePassed : Bool = false
    func addHealthTrackAlert( newMod : HealthResistenced20)
    {
        let alert = UIAlertController(title: "Add Health Track", message: "Name and Value new track", preferredStyle: .alert)
        //actions
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in })
        let saveButton = UIAlertAction(title: "Save", style: .default, handler:
        { (action: UIAlertAction!) in
            newMod.healthTrack = CharacterManager.player.addHealthTrack(name: (alert.textFields?[0].text)!, maxHealth: Int((alert.textFields?[1].text)!)!, type: .SEPARATE)
            CharacterManager.player.resistanceList.append(newValue: newMod)
        })
        //configure textfields
        alert.addTextField { (textField: UITextField!) in
            textField.keyboardType = .alphabet
            textField.placeholder = "Enter Name..."
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            textField.tag = 0
        }
        alert.addTextField { (textField: UITextField!) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter Value..."
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            textField.tag = 1
        }
        
        //add the stuff
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        //enable stuff
        self.actionToEnable = saveButton
        saveButton.isEnabled = false
        
        self.present(alert, animated:  true, completion: nil)
    }
    
    @objc func textChanged(_ sender:UITextField)
    {
        if sender.tag == 0
        {
            namePassed = sender.text != ""
        }
        else
        {
            valuePassed = sender.text != ""
        }
        self.actionToEnable?.isEnabled = namePassed & valuePassed
        
    }
}
