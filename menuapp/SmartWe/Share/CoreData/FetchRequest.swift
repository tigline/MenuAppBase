//
//  FetchRequest.swift
//

import CoreData
import Foundation


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

