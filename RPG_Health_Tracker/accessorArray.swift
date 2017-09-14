//
//  accessorArray.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 7/31/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation

class AccessorArray<T>
{
    //MARK: - Array 
    var array : Array<T> = []
    
    var count : Int {
        return array.count
    }
    
    //MARK: - Watchers
    private var watchCount : Int = 0
    private var watchers : [() -> ()] = []
    
    func addWatcher( block : @escaping () -> () ) -> Int
    {
        watchers.append(block)
        return grabWatcherCount()
    }
    
    func removeWatcher( watchNumber : Int)
    {
        _ = watchers.remove(at: watchNumber)
    }
    
    func grabWatcherCount() -> Int
    {
        watchCount += 1
        return watchCount - 1
    }
    
    func callWatchers()
    {
        watchers.forEach { watch in
            watch()
        }
    }
    //MARK: - Array methods
    func append( newValue : T)
    {
        array.append(newValue)
        callWatchers()
    }
    
    func popLast() -> T
    {
        return array.popLast()!
    }
    //TODO: forEach
    
    subscript(index : Int) -> T
    {
        if(index >= array.count)
        {
            print("⏰ index out of range \(index) exceeds \(array.count)")
            return array.first!
        }
        return array[index]
    }
}
