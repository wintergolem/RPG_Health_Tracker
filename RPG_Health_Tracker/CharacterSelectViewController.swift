//
//  CharacterSelectViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/13/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class CharacterSelectViewController: UIViewController {

    @IBOutlet weak var characterTable: UITableView!
    
    var characters : [Player] = CoreDataManager.singleton.loadPlayers()
    var newCharacterApproved = [false , false]
    weak var alertAddButton : UIAlertAction?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        characters.append(Player(displayName: "Test", maxHealth: 100, true))
        
        characterTable.delegate = self
        characterTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeScenes()
    {
        guard let vs = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as? UITabBarController else
        {
            print("Failed to create viewController")
            return
        }
        
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func addPlayer( name : String , maxHealth : Int)
    {
        let player = Player(displayName: name, maxHealth: maxHealth)
        CharacterManager.player = player
        changeScenes()
    }
    
    @objc func alertTextFieldHandle( notification : NSNotification)
    {
        let textField = notification.object as! UITextField
        if textField.text != ""
        {
            newCharacterApproved[0] = true
        }
        else
        {
            newCharacterApproved[0] = false
        }
        
        if newCharacterApproved[0] && newCharacterApproved[1]
        {
            alertAddButton?.isEnabled = true
        }
    }
    
    @objc func alertNumberFieldHandle( notification : NSNotification)
    {
        let textField = notification.object as! UITextField
        if textField.text != ""
        {
            newCharacterApproved[1] = true
        }
        else
        {
            newCharacterApproved[1] = false
        }
        
        if newCharacterApproved[0] && newCharacterApproved[1]
        {
            alertAddButton?.isEnabled = true
        }
    }
    @IBAction func AddNewCharacterButtonPressed(_ sender: UIButton)
    {
        newCharacterApproved = [false , false]
        let alert = UIAlertController(title: "New Character", message: "Provide a name and max health", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in })
        let addAction = UIAlertAction(title: "Save", style: .default, handler:
        { (action: UIAlertAction!) in
            self.addPlayer(name: alert.textFields![0].text!, maxHealth: (Int)(alert.textFields![1].text!)!)
            
        })
        addAction.isEnabled = false//disable to start, enable once both textfields have content
        
        alert.addTextField
            { textField in
                NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldHandle) , name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                textField.keyboardType = .alphabet
                textField.placeholder = "Enter a Character Name"
                
        }
        alert.addTextField
            { textField in
                NotificationCenter.default.addObserver(self, selector: #selector(self.alertNumberFieldHandle) , name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                textField.keyboardType = .numberPad
                textField.placeholder = "Enter a Max Health"
                
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        alertAddButton = addAction
        
        self.present(alert, animated: true, completion: nil)
    }
}
