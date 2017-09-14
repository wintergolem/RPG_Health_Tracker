//
//  ViewControllerCollectionViews.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit
//MARK: - PlayerViewController

extension PlayerViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 0
        {
            //1. Heal
            //2. lethal or nonlethal
            //+ DamageTypes
            return 2 + CharacterManager.player.damageTypeList.count
        }
        else
        {
            return 500
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
            fillCell(byRow: indexPath.row, cell: cell)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Count", for: indexPath) as! CountingCell
            cell.label.text = "\(indexPath.row + 1)"
            cell.label.textColor = UIColor(red: 0, green: 1, blue: 0.9, alpha: 1)
            return cell
        }
    }
    
    func fillCell( byRow : Int , cell : ActionCollectionViewCell)
    {
        if byRow == 0
        {
            cell.switchChangeFunc = {
                if cell.activeSwitch.isOn
                {
                    cell.titleLabel.text = "Damage"
                }
                else
                {
                    cell.titleLabel.text = "Heal"
                }
                self.actionTypeByte = self.actionTypeByte ^ UInt32(1 << byRow)
            }
            cell.titleLabel.text = "Damage"
            cell.activeSwitch.isOn = true
        }
        else if byRow == 1
        {
            cell.switchChangeFunc = {
                if cell.activeSwitch.isOn
                {
                    cell.titleLabel.text = "Lethal"
                }
                else
                {
                    cell.titleLabel.text = "NonLethal"
                }
                self.actionTypeByte = self.actionTypeByte ^ UInt32(1 << byRow)
            }
            cell.titleLabel.text = "Lethal"
            cell.activeSwitch.isOn = true
        }
        else
        {
            //TODO: Consider adding strikethrough - 
            cell.switchChangeFunc = {
                self.actionTypeByte = self.actionTypeByte ^ UInt32(1 << byRow)
            }
            cell.activeSwitch.isOn = false
            cell.titleLabel.text = CharacterManager.player.damageTypeList[byRow - 2]
        }
    }
}
//Delegate
extension PlayerViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        addAction(value: indexPath.row + 1) //adjust for 0-index
    }
}

extension PlayerViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView.tag == 0
        {
            return CGSize(width: 70, height: 70)
        }
        else
        {
            return CGSize(width: 60, height: 60)
        }
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

}

//MARK: - DamageModCreationViewController
extension DamageModCreationViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return CharacterManager.player.damageTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        cell.switchChangeFunc = {
            self.actionTypeByte = self.actionTypeByte ^ UInt32(1 << indexPath.row + 1)
        }
        cell.activeSwitch.isOn = false
        cell.titleLabel.text = CharacterManager.player.damageTypeList[indexPath.row]
        return cell
    }
}

extension DamageModCreationViewController : UICollectionViewDelegate
{
    
}
extension DamageModCreationViewController : UICollectionViewDelegateFlowLayout
{
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
    
}
