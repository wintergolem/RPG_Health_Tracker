//
//  DamageAddAlert.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/25/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class DamageAddAlert
{
    //MARK: - Properties
    var alert : UIAlertController
    var addAction : UIAlertAction
    
    init( title : String , message : String , type : d20AttackType )
    {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in })
        addAction = UIAlertAction()
        addAction = UIAlertAction(title: "Add", style: .default, handler:
        { (action : UIAlertAction!) in
            DamageTypeCatalogued.add( newValue: (self.alert.textFields![0].text!), type)
        })
        addAction.isEnabled = false
        
        alert.addTextField
            { textField in
            NotificationCenter.default.addObserver(self , selector: #selector(self.textFieldChangeHandler), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
            textField.keyboardType = .alphabet
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
    }
    
    @objc func textFieldChangeHandler( notification : NSNotification)
    {
        let textField = notification.object as! UITextField
        if textField.text != ""
        {
            addAction.isEnabled = true
        }
        else
        {
            addAction.isEnabled = false
        }
    }


}
