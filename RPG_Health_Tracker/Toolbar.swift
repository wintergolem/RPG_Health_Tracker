//
//  Toolbar.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/24/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

extension UIToolbar
{
    static func doneToolBar(_ doneFunc : Selector , target : Any) -> UIToolbar
        {
            let doneToolbarT: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbarT.barStyle = UIBarStyle.blackTranslucent
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: target, action: doneFunc )
            
            let items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)
            
            doneToolbarT.items = items as? [UIBarButtonItem]
            doneToolbarT.sizeToFit()
            return doneToolbarT
    }

    static func typeToolBar(doneFunc : Selector , addFunc: Selector, target : Any) -> UIToolbar
        {
            let doneToolbarT: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbarT.barStyle = UIBarStyle.blackTranslucent
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: target, action: doneFunc)
            let new: UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: target, action: addFunc)
            
            let items = NSMutableArray()
            items.add(new)
            items.add(flexSpace)
            items.add(done)
            
            doneToolbarT.items = items as? [UIBarButtonItem]
            doneToolbarT.sizeToFit()
            return doneToolbarT
    }
}

