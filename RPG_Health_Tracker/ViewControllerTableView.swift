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
        if CharacterManager.player.separateHealthTracks.count > 0
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
        else if section == 1 && CharacterManager.player.beforeHealthTracks.count < 0 || section == 2 && CharacterManager.player.afterHealthTracks.count > 0
        {
            return "After"
        }
        else
        {
            return "Separate"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthCell", for: indexPath) as! HealthTrackTableCell
        determineCellInfo(indexPath: indexPath, cell: cell)
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
        else if section == 1 && CharacterManager.player.beforeHealthTracks.count < 0 || section == 2 && CharacterManager.player.afterHealthTracks.count > 0
        {
            return CharacterManager.player.afterHealthTracks.count
        }
        else
        {
            return CharacterManager.player.separateHealthTracks.count
        }
    }
    
    func determineCellInfo( indexPath : IndexPath , cell : HealthTrackTableCell)
    {
        //main health track
        if indexPath.section == 0
        {
            switch( indexPath.row)
            {
            case 0:
                cell.displayNameLabel.text = "Health Total: "
                cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .FULL)
            case 1:
                cell.displayNameLabel.text = "NonLethal: "
                cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .NONLETHAL)
            case 2:
                cell.displayNameLabel.text = "Available: "
                cell.healthDisplayLabel.text = CharacterManager.player.getHealthForDisplay(displayType: .AVAIL)
            default:
                return
            }
        }
        else if indexPath.section == 1 && CharacterManager.player.beforeHealthTracks.count > 0
        {//before track
            cell.displayNameLabel.text = CharacterManager.player.beforeHealthTracks[indexPath.row].displayName
            cell.healthDisplayLabel.text = CharacterManager.player.beforeHealthTracks[indexPath.row].getHealthTrait(trait: .FULL)
        }
        else if indexPath.section == 1 && CharacterManager.player.beforeHealthTracks.count < 0 || indexPath.section == 2 && CharacterManager.player.afterHealthTracks.count > 0
        {//after track
            cell.displayNameLabel.text = CharacterManager.player.afterHealthTracks[indexPath.row].displayName
            cell.healthDisplayLabel.text = CharacterManager.player.afterHealthTracks[indexPath.row].getHealthTrait(trait: .FULL)
        }
        else
        {//separate track
            cell.displayNameLabel.text = CharacterManager.player.separateHealthTracks[indexPath.row].displayName
            cell.healthDisplayLabel.text = CharacterManager.player.separateHealthTracks[indexPath.row].getHealthTrait(trait: .FULL)
        }
    }
    
    //reordering cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        //determine if cell is in "main" section, if yes, return false, else return true
        if  indexPath.section == 0
        {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //bounce the idea of moving a section 1+ to section 0
        if destinationIndexPath.section == 0 && sourceIndexPath.section == 0
        {
            return
        }
        let sourceTrack : d20TrackType = determineTrack(section: sourceIndexPath.section)
        let destTrack : d20TrackType = determineTrack(section: destinationIndexPath.section)
        
        player.moveTrack(
            sourceTrack: sourceTrack, sourceIndex: sourceIndexPath.row,
            destTrack: destTrack, destIndex: destinationIndexPath.row)
    }
    
    func determineTrack( section : Int) -> d20TrackType
    {
        var returnValue = 0
        if section == 1 && CharacterManager.player.beforeHealthTracks.count > 0
        {
            returnValue = 0
        }
        else if section == 1 && CharacterManager.player.beforeHealthTracks.count < 0 || section == 2 && CharacterManager.player.afterHealthTracks.count > 0
        {
            returnValue = 1
        }
        else
        {
            returnValue = 2
        }
        
        return d20TrackType(rawValue: returnValue)!
    }
}


//MARK: - DamageModCreationViewController
extension DamageModCreationViewController : UITableViewDataSource
{
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

//MARK: - CharacterSelect
extension CharacterSelectViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //load character
        CharacterManager.player = characters[indexPath.row]
        changeScenes()
    }
}

extension CharacterSelectViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //core data class -> grab amount of characters
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select") as! CharacterSelectCell
        cell.nameLabel.text = characters[indexPath.row].displayName
        cell.healthLabel.text = characters[indexPath.row].getHealthForDisplay(displayType: .AVAIL)
        return cell
        
        
    }
}
