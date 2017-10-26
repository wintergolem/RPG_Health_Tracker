//
//  UIApplication.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/25/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

extension UIApplication
{
    class func present( _ alert: UIViewController , controller : UIViewController? = UIApplication.shared.keyWindow?.rootViewController, completion : (()->())?)
    {
        if let tabController = controller as? UITabBarController
        {
            if let selected = tabController.selectedViewController
            {
                selected.present(alert, animated: true, completion: completion)
            }
        }
    }
}
