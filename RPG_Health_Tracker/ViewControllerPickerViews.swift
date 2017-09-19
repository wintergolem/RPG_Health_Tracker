//
//  ViewControllerPickerViews.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/24/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit
//MARK: - DamageModCreationViewController
extension DamageModCreationViewController : UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return d20ResistanceOperations.numberOf
    }
}

extension DamageModCreationViewController : UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return d20ResistanceOperations.getValueFromInt(row).toString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        activeOperation = d20ResistanceOperations.getValueFromInt(row)
        opField.text = activeOperation.toString()
        opField.resignFirstResponder()
    }
}
