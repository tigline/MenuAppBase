//
//  CoreDataStack.swift
//

import CoreData
import Foundation
import TMDb

final class CoreDataStack {
//    static let share = CoreDataStack()
//
//    lazy var container: NSPersistentCloudKitContainer = {
//        let container = NSPersistentCloudKitContainer(name: "Model")
//
//        let desc = container.persistentStoreDescriptions.first!
//        desc.setOption(true as NSNumber,
//                       forKey: NSPersistentHistoryTrackingKey)
//        desc.setOption(true as NSNumber,
//                       forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//
//        if !allowCloudKitSync {
//            desc.cloudKitContainerOptions = nil
//        }
//        container.loadPersistentStores { _, error in
//            if let error {
//                fatalError("\(error.localizedDescription)")
//            }
//        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        return container
//    }()
//
//    var viewContext: NSManagedObjectContext {
//        container.viewContext
//    }
//
//    let allowCloudKitSync: Bool = {
//        let arguments = ProcessInfo.processInfo.arguments
//        var allow = true
//        for index in 0 ..< arguments.count - 1 where arguments[index] == "-AllowCloudKitSync" {
//            allow = arguments.count >= (index + 1) ? arguments[index + 1] == "1" : true
//            break
//        }
//        return allow
//    }()
    
    static let shared = CoreDataStack()

    static var preview: CoreDataStack = {
        let result = CoreDataStack(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = FavoriteMovie(context: viewContext)
            newItem.createTimestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension CoreDataStack {
    func updateFavoriteMovie(movieID: Int) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "movieID = %d", movieID)
            request.sortDescriptors = [NSSortDescriptor(key: "createTimestamp", ascending: true)]
            let result = try? context.fetch(request).first
            if let movie = result {
                context.delete(movie)
                try? context.save()
            } else {
                let favoriteMovie = FavoriteMovie(context: context)
                favoriteMovie.movieID = Int64(movieID)
                favoriteMovie.createTimestamp = .now
                try? context.save()
            }
        }
    }

    func updateFavoritePerson(personID: Int) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<FavoritePerson>(entityName: "FavoritePerson")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "personID = %d", personID)
            request.sortDescriptors = [NSSortDescriptor(key: "createTimestamp", ascending: true)]
            let result = try? context.fetch(request).first
            if let movie = result {
                context.delete(movie)
                try? context.save()
            } else {
                let favoritePerson = FavoritePerson(context: context)
                favoritePerson.personID = Int64(personID)
                favoritePerson.createTimestamp = .now
                try? context.save()
            }
        }
    }
}
