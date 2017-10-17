//
//  Theme.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/6/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

class ColorScheme
{
    var mainColor : UIColor
    //Text
    var mainTextColor : UIColor
    var mainTextFont : String?
    //NavigationBar
    var barStyle : UIBarStyle
    var navigationBackgroundImage : UIImage?
    //TabBar
    var tabBarBackgroundImage: UIImage?
    var backgroundColor : UIColor
    var secondaryColor : UIColor
    //associated value
    var index : Int
    
    init(mainColor: UIColor , textColor : UIColor , barStyle : UIBarStyle , backgroundColor : UIColor , secondaryColor : UIColor , index : Int)
    {
        self.mainColor = mainColor
        self.mainTextColor = textColor
        self.barStyle = barStyle
        self.backgroundColor = backgroundColor
        self.secondaryColor = secondaryColor
        self.index = index
    }
}

struct SchemeManager
{
    static func currentScheme() -> ColorScheme
    {
        let storedScheme = UserDefaults.standard.integer(forKey: SelectedThemeKey)
        return storedScheme < Schemas.array.count ?Schemas.array[storedScheme] : Schemas.array[0]
    }
    
    static func applyScheme(scheme : ColorScheme)
    {
        // Save Scheme selection to UserDefaults
        UserDefaults.standard.setValue(scheme.index, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // Update app-wide tint
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = scheme.mainColor
        //UIView.appearance().backgroundColor = UIColor.magenta
        
        // Update navigationBar
        UINavigationBar.appearance().barStyle = scheme.barStyle
            //sets image to nil if there is none
        UINavigationBar.appearance().setBackgroundImage(scheme.navigationBackgroundImage, for: .default)
            //back IndicatorImage
            //back indicatorTransitionMaskImage
        
        // Update tabBar
        UITabBar.appearance().barStyle = scheme.barStyle
        UITabBar.appearance().backgroundImage = scheme.tabBarBackgroundImage
        
        // Update selectionIndicator Image
        
        
        // Update Sliders
        
        // Upate Switches
        UISwitch.appearance().onTintColor = scheme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = scheme.mainColor
        
        // Update Labels
        //UILabel.appearance().appearanceFontName = "MarkFelt-Wide"
        UILabel.appearance().appearanceFontColor = scheme.mainTextColor
        
        // Update Collection Views
        //UIView.appearance(whenContainedInInstancesOf: [UICollectionView.self]).backgroundColor = scheme.backgroundColor
        //UIView.appearance(whenContainedInInstancesOf: [UICollectionViewCell.self]).backgroundColor = scheme.secondaryColor
        UILabel.appearance(whenContainedInInstancesOf: [UICollectionView.self]).appearanceFontColor = scheme.mainTextColor
        testLabel.appearance().appearanceFontColor = UIColor.green
        // Update Table Views
        UIView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = scheme.mainColor
    }
}
