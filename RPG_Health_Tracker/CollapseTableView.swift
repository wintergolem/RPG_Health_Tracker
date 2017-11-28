//
//  CollapseTableView.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/30/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

class CollapseTableViewController: UITableViewController
{
    var sectionCollapseArray : [Bool]!
    var sectionHeaderArray : [HeaderView]!
    var sectionRowCount : [Int]!
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        //create arrays w/ open sections
        sectionCollapseArray = [Bool](repeating: false, count: tableView.numberOfSections)
        sectionRowCount = [Int](repeating: 0 , count: tableView.numberOfSections)
        for i in 0...tableView.numberOfSections - 1
        {//fill array
            sectionRowCount[i] = tableView.numberOfRows(inSection: i) - 1
        }
        for i in 0...sectionCollapseArray.count - 1
        {//set array to close all sections
            sectionCollapseArray[i] = true
        }
        sectionCollapseArray[0] = false //open first section to avoid weird UI issues
        sectionHeaderArray = [HeaderView](repeating: HeaderView(), count: tableView.numberOfSections)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView
        {
            headerView.section = section
            headerView.delegate = self
            sectionHeaderArray[section] = headerView
            headerView.collaspeArrow?.rotate(sectionCollapseArray[section] ? 0 : .pi)
            return headerView
        }
        return UIView()
    }
}

extension CollapseTableViewController //MARK: - UITableViewDataSource
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let array = sectionCollapseArray
        {
            return array[section] ? 0 : super.tableView(tableView, numberOfRowsInSection: section)
        }
        return 0
         
    }
}

extension CollapseTableViewController : HeaderViewDelegate
{
    func toggleSection(header: HeaderView, section: Int)
    {
        //don't change anything while animating nor if selected section is open
        if HeaderView.animating || !sectionCollapseArray[section]
        {
            return
        }
        else
        {
            //close open path
            let openSection = sectionCollapseArray.firstValue(mask: false)
            var deletePaths : [IndexPath] = [IndexPath]()
            for i in 0...sectionRowCount[openSection]
            {
                deletePaths.append(IndexPath(item: i, section: openSection))
            }
            sectionCollapseArray[openSection] = true
            //open new section
            var openPaths : [IndexPath] = [IndexPath]()
            for i in 0...sectionRowCount[section]
            {
                openPaths.append(IndexPath(item: i, section: section))
            }
            sectionCollapseArray[section] = false
            //animate change
            tableView.beginUpdates()
            tableView.deleteRows(at: deletePaths, with: .fade)
            tableView.insertRows(at: openPaths, with: .automatic)
            tableView.endUpdates()
        }
    }
}
