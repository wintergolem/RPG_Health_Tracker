//
//  CreationViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/17/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController
{
    //MARK: - Outlets
    @IBOutlet weak var affectsLabel: UILabel!
    @IBOutlet weak var damageTypeField: UITextField!
    @IBOutlet weak var matchSwitch: UISwitch!
    @IBOutlet weak var operationField: UITextField!
    @IBOutlet weak var addResistanceButton: UIButton!
    @IBOutlet weak var resistanceValueField: UITextField!
    @IBOutlet weak var resistanceNameField: UITextField!
    
    @IBOutlet weak var damageTypeTable: UITableView!
    
    //MARK: - Lazy Properites
    lazy var resistancePickerView : UIPickerView =
        {
            var temp = UIPickerView()
            temp.delegate = self
            temp.dataSource = self
            return temp
    }()
    lazy var resistanceNamePickerView : UIPickerView =
        {
            var temp = UIPickerView()
            temp.delegate = self
            temp.dataSource = self
            return temp
    }()
    
    //MARK: - Properites
    var activeDamageType : String = CharacterManager.player.damageTypeList[0]
    var activeOperation : d20ResistanceOperations = d20ResistanceOperations.subtraction
    lazy var doneToolBar : UIToolbar = UIToolbar.doneToolBar( #selector(CreationViewController.doneButtonAction), target: self)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //add inputView and accessories
        operationField.inputView = resistancePickerView
        operationField.inputAccessoryView = doneToolBar
        damageTypeField.inputView = resistanceNamePickerView
        damageTypeField.inputAccessoryView = UIToolbar.typeToolBar(doneFunc: #selector(CreationViewController.doneButtonAction) , addFunc: #selector(CreationViewController.addButtonAction) , target: self)
        resistanceValueField.inputAccessoryView = UIToolbar.doneToolBar(#selector(CreationViewController.doneButtonAction), target: self)
        resistanceNameField.inputAccessoryView = doneToolBar
        //set text
        operationField.text = activeOperation.toString()
        //damageTypeField.text = CharacterManager.damageTypeList[0]
        //set dataSource and delegetes
        damageTypeTable.dataSource = self
        //add watchers/listeners
        //CharacterManager.addDamageTypeWatchers(watch: self.updateTableView)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK: - ACTIONS
    @IBAction func addResistanceButtonPress(_ sender: UIButton)
    {
        let resist = HealthResistenced20()
       // resist.typeName = activeDamageType
        resist.op = activeOperation
        resist.value = Int(resistanceValueField.text!)!
        //resist.triggerOnSameType = matchSwitch.isOn
        resist.displayName = resistanceNameField.text!
        
        //CharacterManager.addResistance(resist: resist)
        
        resistanceNameField.text = ""
        resistanceValueField.text = "0"
        doneButtonAction()
    }
    
    @IBAction func addDamageTypeButtonPress(_ sender: UIButton)
    {
        addDamageAlert()
    }
    
    @IBAction func resistanceNameFieldEditEnd(_ sender: UITextField){}
    //MARK: - METHODS
    func doneButtonAction()
    {
        view.endEditing(true)
    }

    func addButtonAction()
    {
        addDamageAlert()
            {
                //self.damageTypeField.text = CharacterManager.damageTypeList.last
                self.view.endEditing(true)
        }
    }
    func addDamageAlert(_ block: @escaping () -> Void = {})
    {
        let alert = UIAlertController(title: "Add Damage Type", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            let textField = alert.textFields![0] //as UITextView
            textField.keyboardType = .alphabet
            //CharacterManager.addDamageType(type: textField.text!)
            block()
        })
        
        alert.addTextField { (textField: UITextField!) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func updateTableView()
    {
        damageTypeTable.reloadData()
    }
}


extension CreationViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DamageCell", for: indexPath)
        //cell.textLabel?.text = CharacterManager.damageTypeList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return CharacterManager.damageTypeList.count
        return 1
    }
    
}
