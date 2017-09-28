//
//  CoreDataManager.swift
//  RPG_Health_Tracker
//
//  Created by steven Hoover on 9/27/17.
//  Copyright © 2017 steven Hoover. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager
{
    //MARK: SharedInstance
    static var singleton : CoreDataManager = CoreDataManager()
    
    //MARK: - Properities
    
    //MARK: -  Methods
    private init(){}
    
    //MARK: Loading
    func loadPlayers() -> [Player]
    {
        var players : [CharacterEntity]
        let request : NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        do{
            let searchResult = try self.persistentContainer.viewContext.fetch(request)
            if searchResult.count != 0
            {
                players.append(contentsOf: searchResult)
            }
        }
        catch
        {
            //TODO add error messaging
        }
        
        return players
    }
    
    lazy var persistentContainer : NSPersistentContainer =
        {
            let container = NSPersistentContainer(name: "TextAdventure")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error - \(error) , \(error.userInfo)")
                }
            })
            return container
    }()
    
    //MARK: Saving
    func saveContext()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                fatalError("Unresolved error - \(nserror) , \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: Deleting
    func deleteEntity( entity: NSManagedObject)
    {
        persistentContainer.viewContext.delete(entity)
        saveContext()
    }
}
