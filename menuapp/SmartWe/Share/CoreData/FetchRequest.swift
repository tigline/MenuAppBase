//
//  FetchRequest.swift
//

import CoreData
import Foundation

extension FavoriteMovie {
    static let movieRequest: NSFetchRequest<FavoriteMovie> = {
        let request = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.returnsObjectsAsFaults = false
        return request
    }()

    static let disableRequest: NSFetchRequest<FavoriteMovie> = {
        let request = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.predicate = .init(value: false)
        return request
    }()
}

extension CargoItem {
    static let CargoRequest: NSFetchRequest<CargoItem> = {
        let request = NSFetchRequest<CargoItem>(entityName: "CargoItem")
        //request.relationshipKeyPathsForPrefetching = []
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.returnsObjectsAsFaults = false
        return request
    }()

    static let disableRequest: NSFetchRequest<CargoItem> = {
        let request = NSFetchRequest<CargoItem>(entityName: "CargoItem")
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.predicate = .init(value: false)
        return request
    }()
}

extension FavoritePerson {
    static let personRequest: NSFetchRequest<FavoritePerson> = {
        let request = NSFetchRequest<FavoritePerson>(entityName: "FavoritePerson")
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.returnsObjectsAsFaults = false
        return request
    }()

    static let disableRequest: NSFetchRequest<FavoritePerson> = {
        let request = NSFetchRequest<FavoritePerson>(entityName: "FavoritePerson")
        request.sortDescriptors = [.init(key: "createTimestamp", ascending: false)]
        request.predicate = .init(value: false)
        return request
    }()
}
