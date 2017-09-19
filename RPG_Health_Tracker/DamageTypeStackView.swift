//
//  DamageTypeStackView.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/18/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class DamageTypeView: UIView
{

    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var attackTypeSegCon: UISegmentedControl!
 
    var actionTypeByte : UInt32 = UInt32(3)
    var activeAttackType : d20AttackType = .DR
    
    func determineAttackType() -> d20AttackType
    {
        switch attackTypeSegCon.selectedSegmentIndex
        {
        case 0:
            return .DR
        case 1:
            return .RESIST
        case 2:
            return .NONE
        default:
            return .DR
        }
        
    }

    @IBAction func attackTypeChanged(_ sender: UISegmentedControl)
    {
        CharacterManager.player.currentAttackType = determineAttackType()
        activeAttackType = determineAttackType()
        actionCollectionView.reloadData()
    }
}

extension DamageTypeView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //1. lethal or nonlethal
        //+ DamageTypes
        var value = 1
        switch activeAttackType {
        case .DR:
            value += DamageTypeCatalogued.physical.count
        case .RESIST:
            value += DamageTypeCatalogued.energy.count
        case .NONE:
            value += 0
        }
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        fillCell(byRow: indexPath.row, cell: cell)
        return cell
    }
    
    func fillCell( byRow : Int , cell : ActionCollectionViewCell)
    {
        cell.value = byRow
        cell.activeSwitch.isOn = false
        if byRow == 0
        {
            cell.activeText = "Lethal"
            cell.inactiveText = "NonLethal"
            cell.activeSwitch.isOn = true
        }
        else
        {
            //TODO: Consider adding strikethrough -
            let text = DamageTypeCatalogued.getTextForValue(byRow - 1 , activeAttackType)
            cell.activeText = text
            cell.inactiveText = text
        }
        cell.titleLabel.text = cell.activeSwitch.isOn ? cell.activeText : cell.inactiveText
    }
}

extension DamageTypeView : UICollectionViewDelegate
{
    
}

extension DamageTypeView : UICollectionViewDelegateFlowLayout
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

