//
//  ViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/5/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//
/*
import UIKit

class CharacterViewController: UIViewController{

    //MARK: - Outlets
    @IBOutlet weak var healthView: UITextField!
    @IBOutlet weak var healthAvailableView: UITextField!
    @IBOutlet weak var damageToAddView: UITextField!
    @IBOutlet weak var damageTypeView: UITextField!
    @IBOutlet weak var lethalSwitch: UISwitch!
    @IBOutlet weak var lethalText: UILabel!
    
    @IBOutlet weak var damageHealSwitch: UISwitch!
    @IBOutlet weak var damageHealTitleLabel: UILabel!
    @IBOutlet weak var damageTypeLabel: UILabel!
    @IBOutlet weak var addDamageButton: UIButton!
    
    @IBOutlet weak var resistenceTable: UITableView!
    
    //MARK: - Extra members
    lazy var damagePickerView : UIPickerView =
        {
            var temp = UIPickerView()
            //self.inputAccessoryView = self.doneToolBar
            temp.delegate = self
            temp.dataSource = self
            return temp
    }()
    var activeDamageType : String = CharacterManager.player.damageTypeList[0]
    var doneToolBar : UIToolbar = UIToolbar.doneToolBar(#selector(CharacterViewController.doneButtonAction), target: self)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //assigning pickerViews
        damageTypeView.inputView = damagePickerView
        damageTypeView.inputAccessoryView = doneToolBar
        
        damageToAddView.inputAccessoryView = doneToolBar
        
        //set health UI
        //healthView.text = CharacterManager.player.getCurrentHealth(type: .full)
        //healthAvailableView.text = CharacterManager.player.getCurrentHealth(type: .avail)
        damageTypeView.text = activeDamageType
        
        //set datasources and delegates
        resistenceTable.dataSource = self
        //set watchers
        //CharacterManager.addResistanceWatcher(watch: self.updateTableView)
        
        //create test resistence
    }
 
    //MARK: - Methods
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func updateHealthDisplay()
    {
        //healthView.text = CharacterManager.player.getCurrentHealth(type: .full)
        //healthAvailableView.text = CharacterManager.player.getCurrentHealth(type: .avail)
    }
    func updateTableView()
    {
        resistenceTable.reloadData()
    }
    //MARK: - ACTIONS
    @IBAction func addDamageButtonPressed(_ sender: Any)
    {
        
        if damageHealSwitch.isOn
        {
            let damage = Action20(newValue: Int(damageToAddView.text!)! , counter: CharacterManager.player.grabActionNumber())
            damage.lethal = lethalSwitch.isOn
            //damage.damageType = activeDamageType
            
            CharacterManager.player.takeDamage(damage: damage)
            updateHealthDisplay()
        }
        else
        {
            if CharacterManager.player.checkHealExceed(amount: Int(damageToAddView.text!)! , nonLethalOnly: !lethalSwitch.isOn)
            {
                //capture the value now in case it changes
                let value = Int(self.damageToAddView.text!)!
                let alert = UIAlertController(title: "Healing Exceeds Max", message: "Would you like to add excess health?", preferredStyle: .alert)
                //cancel healing
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in })
                //don't add extra health
                let noAction = UIAlertAction(title: "Don't Add Excess Health", style: .default, handler: { (action: UIAlertAction!) in
                    CharacterManager.player.healDamage(amount: value ,capped: true , nonLethalOnly: !self.lethalSwitch.isOn )
                    self.updateHealthDisplay()
                })
                //add extra health
                let addAction = UIAlertAction(title: "Add Excess Health", style: .default, handler: { (action: UIAlertAction!) in
                    CharacterManager.player.healDamage(amount: value ,capped: false , nonLethalOnly: !self.lethalSwitch.isOn )
                    self.updateHealthDisplay()
                })
                alert.addAction(addAction)
                alert.addAction(noAction)
                alert.addAction(cancelAction)
                self.present(alert, animated:  true, completion:  nil)
            }
            else
            {
                CharacterManager.player.healDamage(amount: Int(damageToAddView.text!)!)
                updateHealthDisplay()
            }
        }
        damageTypeView.text = CharacterManager.damageTypeList[0]
        activeDamageType = CharacterManager.damageTypeList[0]
        damageToAddView.text = "0"
    }
   
    @IBAction func damageValueFieldEditBegin(_ sender: UITextField)
    {
        sender.text = ""
    }
    @IBAction func damageValueFieldEditEnd(_ sender: UITextField)
    {
        return
    }
    @IBAction func lethalSwitchChanged(_ sender: UISwitch)
    {
        if sender.isOn
        {
            lethalText.text = "Lethal"
        }
        else
        {
            lethalText.text = "Nonlethal"
        }
    }
    @IBAction func damageHealSwitchChanged(_ sender: UISwitch)
    {
        if sender.isOn
        {
            damageHealTitleLabel.text = "Add Damage Event"
            damageTypeLabel.text = "Damage Type:"
            //addDamageButton.titleLabel?.text = "Add Damage"
            addDamageButton.setTitle("Add Damage", for: .normal)
        }
        else
        {
            damageHealTitleLabel.text = "Heal Damage"
            damageTypeLabel.text = "Heal Type:"
            //addDamageButton.titleLabel?.text = "Add Health"
            addDamageButton.setTitle("Add Health", for: .normal)
        }
    }
}
*/

