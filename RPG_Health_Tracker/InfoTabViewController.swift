//
//  InfoTabViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/30/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class InfoTabViewController: CollapseTableViewController
{

    //MARK: - Outlets
    
    
    //MARK: - Properties
    
    //MARK: - Actions
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    
}

extension InfoTabViewController //MARK: - UITableViewDataSource
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let array = sectionCollapseArray
        {
            return array[section] ? 0 : sectionCellCount[section]
        }
        return 0
    }
}
