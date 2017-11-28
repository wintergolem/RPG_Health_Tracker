//
//  HeaderView.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 10/30/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class
{
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView
{
    
    @IBOutlet weak var collaspeArrow: UILabel?
    var section : Int = 0
    static var animating : Bool = false
    weak var delegate: HeaderViewDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader()
    {
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool , complete: ( (Bool) -> () )?)
    {
        //collaspeArrow?.rotate(collapsed ? 0.0 : .pi)
        
        HeaderView.animating = true
        UIView.animate(withDuration: 0.2, animations: {
            self.collaspeArrow?.rotate(0.50)
        }, completion: { (success) in
            HeaderView.animating = false
            if complete != nil { complete!(success) }
        })
        
    }
    
    func doneAnimatingHandler(_ success : Bool)
    {
        HeaderView.animating = false
    }
    //MARK: - Static Methods
    static var identifier: String
    {
        return String(describing: self)
    }
    
    static var nib: UINib
    {
        return UINib(nibName: identifier, bundle: nil)
    }
}
