//
//  DataSourceDelegate.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 11/13/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class DataSourceDelegate : NSObject, UITableViewDataSource ,UICollectionViewDataSource , UIPickerViewDelegate , UICollectionViewDelegateFlowLayout
{
    var activeAttackType : d20AttackType = .DR
    var activeNumberOfItems : Int = 0
    var activeModTypeByte : UInt32 = UInt32(0)
//MARK: - datasource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if CharacterManager.player.resistanceList.count == 0
        {
            return 0
        }
        var temp : Int = CharacterManager.player.resistanceList.array.contains(where: checkForTypeDR(temp:)) ? 1 : 0
        temp += CharacterManager.player.resistanceList.array.contains(where: checkForTypeRE(temp:)) ? 1 : 0
        return temp
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        //if there is a second section, it's always "Resistance"
        if section == 1
        {
            return "Resistance"
        }
        //first section is "DR", unless there is none, in which case it's "Resistance"
        if CharacterManager.player.resistanceList.array.contains(where: checkForTypeDR(temp:))
        {
            return "DR"
        }
        else
        {
            return "Resistance"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var dr = 0
        var resis = 0
        CharacterManager.player.resistanceList.array.forEach{ res in
            if res.attackTypeWorksAgainst == .DR
            {
                dr += 1
            }
            else
            {
                resis += 1
            }
        }
        
        return section == 0 ? dr : resis
    }
//MARK: - Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //print("Section: \(indexPath.section) - Row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "resistCell", for: indexPath) as! DamageModCell
        var index = 0
        var typeCount = 0
        var looped = 0
        for res in CharacterManager.player.resistanceList.array
        {
            if (res.attackTypeWorksAgainst == .DR && indexPath.section == 0) || (res.attackTypeWorksAgainst == .RESIST && indexPath.section == 1)
            {
                if typeCount == indexPath.row
                {
                    index = looped
                    break
                }
                typeCount += 1
            }
            looped += 1
        }
        cell.nameLabel.text = CharacterManager.player.resistanceList[index].displayName
        cell.valueLabel.text = "\(CharacterManager.player.resistanceList[index].value)"
        cell.enableSwitch.isOn = CharacterManager.player.resistanceList[index].enabled
        cell.switchAction = { CharacterManager.player.resistanceList[index].enabled = cell.enableSwitch.isOn }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var value = 0
        if activeAttackType == .DR
        {
            value = DamageTypeCatalogued.physical.count + 1
        }
        else if activeAttackType == .RESIST
        {
            value = DamageTypeCatalogued.energy.count + 1
        }
        activeNumberOfItems = value
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == activeNumberOfItems - 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        print(activeAttackType)
        let text = DamageTypeCatalogued.getTextForValue(indexPath.row, activeAttackType)
        cell.activeSwitch.isOn = false
        cell.activeText = text
        cell.inactiveText = text
        cell.titleLabel.text = cell.activeSwitch.isOn ? cell.activeText : cell.inactiveText
        cell.value = indexPath.row
        cell.switchChangeFunc = {
            self.activeModTypeByte = self.activeModTypeByte ^ (1 << cell.value)
        }
        return cell
    }
//MARK: - UI Flow Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func checkForTypeDR(temp : HealthResistenced20) -> Bool
    {
        if temp.attackTypeWorksAgainst == .DR
        {
            return true
        }
        else
        {
            return false
        }
    }
    func checkForTypeRE(temp : HealthResistenced20) -> Bool
    {
        if temp.attackTypeWorksAgainst == .RESIST
        {
            return true
        }
        else
        {
            return false
        }
    }
}
