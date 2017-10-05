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
        var players : [CharacterEntity] = [CharacterEntity]()
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
            print("Error with request: \(error)")
            //TODO add error messaging
        }
        
        return CharacterBuilder.buildPlayers(entities: players)
    }
    
    lazy var persistentContainer : NSPersistentContainer =
        {
            let container = NSPersistentContainer(name: "RPG_Health_Tracker")
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
    
    func grabPlayerEntity() -> CharacterEntity
    {
        return CharacterEntity(context: persistentContainer.viewContext)
    }
    func grabTrackEntity() -> HealthTrackEntity
    {
        return HealthTrackEntity(context: persistentContainer.viewContext)
    }
    func grabResistEntity() -> ResistEntity
    {
        return ResistEntity(context: persistentContainer.viewContext)
    }
    //MARK: Deleting
    func deleteEntity( entity: NSManagedObject)
    {
        persistentContainer.viewContext.delete(entity)
        saveContext()
    }
}
