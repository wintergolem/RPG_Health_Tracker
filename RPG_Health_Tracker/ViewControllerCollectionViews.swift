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
        /*if collectionView.tag == 0
        {
            //1. Heal
            //2. lethal or nonlethal
            //+ DamageTypes
            return 2 + CharacterManager.player.damageTypeList.count
        }
        else
        {
          */  return countCellCount
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       /* if collectionView.tag == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
            fillCell(byRow: indexPath.row, cell: cell)
            return cell
        }
        else
        {*/
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Count", for: indexPath) as! CountingCell
            cell.label.text = "\(indexPath.row + 1)"
            cell.label.textColor = UIColor(red: 0, green: 1, blue: 0.9, alpha: 1)
            return cell
       // }
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
        return CGSize(width: countCellWidth, height: countCellHeight)
        /*
        if collectionView.tag == 0
        {
            return CGSize(width: 70, height: 70)
        }
        else
        {
            return CGSize(width: 60, height: 60)
        }
         */
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

