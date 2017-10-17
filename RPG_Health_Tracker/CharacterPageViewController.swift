//
//  CharacterPageViewController.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/19/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//
/*
import UIKit

class CharacterPageViewController: UIPageViewController {

    private(set) lazy var orderedViewControllers: [UIViewController] =
    {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Create")
        return
            [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Create"),
             UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Character"),
             UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "History")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        //setViewControllers([ orderedViewControllers[1] ], direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension CharacterPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else
        {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else
        {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let max = orderedViewControllers.count
        guard nextIndex != max else
        {
            return nil
        }
        
        guard max > nextIndex else
        {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else
        {
            return 0
        }
        return firstViewControllerIndex
    }
}
*/
