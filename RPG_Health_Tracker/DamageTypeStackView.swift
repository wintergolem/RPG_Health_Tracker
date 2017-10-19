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
    //MARK: - Outlets
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var attackTypeSegCon: UISegmentedControl!
    //MARK: - Variables
    var actionTypeByte : UInt32 = UInt32(3)
    var activeAttackType : d20AttackType = .DR
    var activeNumberOfItems : Int = 0
    var cellSet : Bool = false
    //MARK: - Methods
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
            print("DetermineAttackType() - DamageTypeView : invalid case \(attackTypeSegCon.selectedSegmentIndex)")
            return .DR
        }
        
    }
    //MARK: - Actions
    @IBAction func attackTypeChanged(_ sender: UISegmentedControl)
    {
        CharacterManager.player.currentAttackType = determineAttackType()
        activeAttackType = determineAttackType()
        actionCollectionView.reloadData()
    }
}
//MARK: - Extensions
extension DamageTypeView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //1. lethal or nonlethal
        //+ DamageTypes
        var value = 1
        switch activeAttackType {
        case .DR:
            value += DamageTypeCatalogued.physical.count + 1
        case .RESIST:
            value += DamageTypeCatalogued.energy.count + 1
        case .NONE:
            value += 0
        }
        activeNumberOfItems = value
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if ( activeAttackType != .NONE && indexPath.row == activeNumberOfItems - 1)
        {
            if !cellSet
            {
                let nib = UINib(nibName: "AddCell", bundle: nil)
                actionCollectionView.register(nib, forCellWithReuseIdentifier: "AddCell")
                cellSet = true
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        fillCell(byRow: indexPath.row, cell: cell)
        let value = 1 + indexPath.row
        let mask : UInt32 = 1 << value
        cell.activeSwitch.isOn = CharacterManager.player.currentResistanceByte() & mask == mask
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == activeNumberOfItems - 1
        {
            print("AlertView!")
            //start here: add UIAlertController class to handle adding new damage type
        }
    }
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

