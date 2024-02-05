//
//  ErrorHandler.swift
//

import Foundation

func withErrorHandling<T>(_ block: @escaping () async throws -> T) async -> T? {
    do {
        return try await block()
    } catch {
        #if DEBUG
            print("An error occurred: \(error)")
        #endif
        return nil
    }
}
