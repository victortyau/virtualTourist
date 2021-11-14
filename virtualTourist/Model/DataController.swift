//
//  DataController.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/30/21.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer:NSPersistentContainer
    let backgroundContext:NSManagedObjectContext!
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
       persistentContainer = NSPersistentContainer(name: modelName)

       backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            self.configureContexts()
            completion?()
        }
    }
    
    static let shared = DataController(modelName: "virtual_tourist")
}


//    let persistentContainer:NSPersistentContainer
//
//    var viewContext:NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    init(modelName: String){
//        persistentContainer = NSPersistentContainer(name: modelName)
//    }
//
//    func load(completion: (() -> Void)? = nil) {
//        persistentContainer.loadPersistentStores { storeDescription, error in
//            guard error == nil else {
//                fatalError(error!.localizedDescription)
//            }
//            completion?()
//        }
//    }
