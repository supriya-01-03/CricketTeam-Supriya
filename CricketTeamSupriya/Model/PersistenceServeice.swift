//
//  PersistenceServeice.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 22/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import CoreData

class PersistenceServeice: NSObject {

    
    // MARK: - Init
    
    private override init() {}
    
    
    // MARK: - Core Data stack
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var privateContext: NSManagedObjectContext {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = PersistenceServeice.context
        return privateMOC
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CricketTeamSupriya")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = PersistenceServeice.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
