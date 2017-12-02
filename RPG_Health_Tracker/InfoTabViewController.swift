//
//  InfoTabViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/30/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class InfoTabViewController: CollapseTableViewController
{

//MARK: - Outlets
    //active damage type outlets
    @IBOutlet weak var activeDamageTypeSegCon: UISegmentedControl!
    @IBOutlet weak var activeDamageTypeCollectionView: UICollectionView!
    
    //add damage mod outlets
    @IBOutlet weak var modName: UITextField!
    @IBOutlet weak var modValue: UITextField!
    @IBOutlet weak var damageTypeSegCon: UISegmentedControl!
    @IBOutlet weak var operationView: UITextField!
    @IBOutlet weak var healthTrackSwitch: UISwitch!
    @IBOutlet weak var damageTypeCollectionView: UICollectionView!
    @IBOutlet weak var addModButton: UIButton!
    @IBOutlet weak var damageModTrackType: UISegmentedControl!
    
    //added mods outlets
    @IBOutlet weak var addedModTableView: UITableView!
    
//MARK: - Properties
    let dataSourceDelegate : DataSourceDelegate = DataSourceDelegate()
    let damageTypeView : DamageTypeView = DamageTypeView()
    var activeModOperation : d20ResistanceOperations = d20ResistanceOperations.subtraction
    lazy var doneToolBar : UIToolbar = UIToolbar.doneToolBar(#selector(self.doneButtonAction), target: self)
    lazy var operationPickerView : UIPickerView =
        {
            var temp = UIPickerView()
            temp.delegate = self
            temp.dataSource = self
            return temp
    }()
    
    //MARK: - Actions
    @IBAction func addModButtonPressed(_ sender: UIButton)
    {
        let entity = CoreDataManager.singleton.grabResistEntity()
        entity.typeByte = Int32(dataSourceDelegate.activeModTypeByte)
        entity.displayName = modName.text!
        entity.operation = activeModOperation.toString()
        entity.attackType = damageTypeSegCon.selectedSegmentIndex == 0 ? d20AttackType.DR.rawValue : d20AttackType.RESIST.rawValue
        entity.value = Int16(Int(modValue.text!)!)
        let newMod = HealthResistenced20( resistEntity: entity )
        if healthTrackSwitch.isOn
        {
            addHealthTrackAlert(newMod: newMod)
            //CharacterManager.player.addHealthTrack(maxHealth: 100, type: .SEPARATE)
            //TODO: attach track to resistance
        }
        else
        {
            CharacterManager.player.addResist(resist: newMod)
        }
    }
    @IBAction func ActiveDamageTypeSegValueChanged(_ sender: UISegmentedControl)
    {
        damageTypeView.attackTypeChanged()
    }
    @IBAction func DamageTypeModSegValueChangged(_ sender: UISegmentedControl)
    {
        
        switch sender.selectedSegmentIndex {
        case 0:
            dataSourceDelegate.activeAttackType = .DR
        case 1: dataSourceDelegate.activeAttackType = .RESIST
        case 2: dataSourceDelegate.activeAttackType = .NONE
        default:
            dataSourceDelegate.activeAttackType = .NONE
        }
        dataSourceDelegate.activeModTypeByte = 0
        damageTypeCollectionView.reloadData()
        
        
    }
    @IBAction func ModNameFieldChanged(_ sender: UITextField)
    {
        addModButton.isEnabled = checkAddButtonValidity()
    }
    @IBAction func addTrackValueChanged(_ sender: UISwitch)
    {
        damageModTrackType.isEnabled = sender.isOn
    }
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //disable mod add button
        addModButton.isEnabled = checkAddButtonValidity()
        //set damageTypeView variables
        damageTypeView.actionCollectionView = activeDamageTypeCollectionView
        damageTypeView.attackTypeSegCon = activeDamageTypeSegCon
        //assign datasources and delegates
        tableView.dataSource = self
        tableView.delegate = self
        addedModTableView.dataSource = dataSourceDelegate
        damageTypeCollectionView.dataSource = dataSourceDelegate
        damageTypeCollectionView.delegate = dataSourceDelegate
        activeDamageTypeCollectionView.dataSource = damageTypeView
        activeDamageTypeCollectionView.delegate = damageTypeView
        
        let addNib = UINib(nibName: "AddCell", bundle: nil)
        damageTypeCollectionView.register(addNib, forCellWithReuseIdentifier: "AddCell")
        
        //setup operationView
        operationView.inputView = operationPickerView
        operationView.inputAccessoryView = doneToolBar
        operationView.text = activeModOperation.toString()
        
        //add done toolbar to keyboards
        modName.inputAccessoryView = doneToolBar
        modValue.inputAccessoryView = doneToolBar
        
        //setup listeners
        _ = CharacterManager.player.resistanceList.addWatcher()
            {
            self.addedModTableView.reloadData()
        }
    }

    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func checkAddButtonValidity() -> Bool
    {
        if modName.text != "" && modValue.text != ""
        {
            return true
        }
        return false
    }
    func checkModTrackType() -> d20TrackType
    {
        switch damageModTrackType.selectedSegmentIndex
        {
        case 0:
            return .BEFORE
        case 1:
            return .SEPARATE
        case 2:
            return .AFTER
        default:
            print("*******Default called: checkModTrackType() in InfoTabViewController")
            return .SEPARATE
        }
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
            newMod.healthTrack = CharacterManager.player.addHealthTrack(name: (alert.textFields?[0].text)!, maxHealth: Int((alert.textFields?[1].text)!)!, type: self.checkModTrackType() )
            CharacterManager.player.addResist(resist: newMod)
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
//extensions
extension InfoTabViewController : UIPickerViewDataSource , UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return d20ResistanceOperations.numberOf
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return d20ResistanceOperations.getValueFromInt(row).toString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        activeModOperation = d20ResistanceOperations.getValueFromInt(row)
        operationView.text = activeModOperation.toString()
        operationView.resignFirstResponder()
    }
}
