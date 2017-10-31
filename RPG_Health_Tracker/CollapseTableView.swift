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
    var sectionCellCount : [Int]!
    
    //MARK: - Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        //open all the sections
        sectionCollapseArray = [Bool](repeating: false, count: tableView.numberOfSections)
        sectionCellCount = [Int](repeating: 0, count: sectionCollapseArray.count)
        for i in 0...sectionCollapseArray.count - 1
        {
            sectionCellCount[i] = tableView.numberOfRows(inSection: i)
        }
        sectionCollapseArray = sectionCollapseArray.map { _ in true }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView
        {
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}
extension CollapseTableViewController : HeaderViewDelegate
{
    func toggleSection(header: HeaderView, section: Int)
    {
        //turn off all headers
        sectionCollapseArray = sectionCollapseArray.map { _ in true}
        //open selected one
        sectionCollapseArray[section] = false
        //rotate arrow
        header.setCollapsed(collapsed: sectionCollapseArray[section])
        tableView.reloadData()
    }
}
