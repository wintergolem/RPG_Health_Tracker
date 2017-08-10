//
//  ViewControllerTableView.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/24/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

//MARK: - PlayerViewController

extension PlayerViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var returnInt = 1 //main health track
        if CharacterManager.player.beforeHealthTracks.count > 0
        {
            returnInt += 1
        }
        if CharacterManager.player.afterHealthTracks.count > 0
        {
            returnInt += 1
        }
        return returnInt
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Main"
        }
        else if section == 1 && CharacterManager.player.beforeHealthTracks.count > 0
        {
            return "Before"
        }
        else
        {
            return "After"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthCell", for: indexPath) as! HealthTrackTableCell
        cell.updateFunc = determineUpdateFuncForCell(indexPath: indexPath, cell: cell)
        cell.updateFunc()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 3
        }
        else if section == 1 && CharacterManager.player.beforeHealthTracks.count > 0
        {
            return CharacterManager.player.beforeHealthTracks.count
        }
        else
        {
            return CharacterManager.player.afterHealthTracks.count
        }
        
    }
    
    func determineUpdateFuncForCell( indexPath : IndexPath , cell : HealthTrackTableCell) -> () -> ()
    {
        //main health track
        if indexPath.section == 0
        {
            switch( indexPath.row)
            {
            case 0:
                return
                    {
                        cell.displayNameLabel.text = "Health Total: "
                        cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .FULL)
                }
            case 1:
                return
                    {
                        cell.displayNameLabel.text = "NonLethal: "
                        cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .NONLETHAL)
                }
            case 2:
                return
                    {
                        cell.displayNameLabel.text = "Available: "
                        cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .AVAIL)
                }
            default:
                return {}
            }
        }
        
        //
        return {}
    }
}

    
//MARK: - DamageModCreationViewController
extension DamageModCreationViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if CharacterManager.player.resistanceList.count() == 0
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
        
        return cell
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
