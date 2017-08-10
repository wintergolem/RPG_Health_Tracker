//
//  ViewControllerCollectionViews.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 8/1/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit
//MARK: - PlayerViewController DataSource
extension PlayerViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //1. Heal
        //2. lethal or nonlethal
        //3+ DamageTypes
        return 2 + CharacterManager.player.damageTypeList.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        fillCell(byRow: indexPath.row, cell: cell)
        return cell
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
//MARK: - PlayerViewController Delegate
extension PlayerViewController : UICollectionViewDelegate
{
    
}

extension PlayerViewController : UICollectionViewDelegateFlowLayout
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

//MARK: - DamageModCreationViewController
extension DamageModCreationViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return CharacterManager.player.damageTypeList.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        cell.switchChangeFunc = {
            self.actionTypeByte = self.actionTypeByte ^ UInt32(1 << indexPath.row)
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

