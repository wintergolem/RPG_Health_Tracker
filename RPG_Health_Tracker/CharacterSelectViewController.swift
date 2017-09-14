//
//  CharacterSelectViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/13/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class CharacterSelectViewController: UIViewController {

    @IBOutlet weak var characterTable: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        characterTable.delegate = self
        characterTable.dataSource = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeScenes()
    {
        guard let vs = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as? CharacterPageViewController else
        {
            print("Failed to create viewController")
            return
        }
        
        self.navigationController?.pushViewController(vs, animated: true)
    }
}
