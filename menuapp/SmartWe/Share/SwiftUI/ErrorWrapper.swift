//
//  ErrorWrapper.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import Foundation
import SwiftUI
struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}

struct ShowErrorEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Error, String?) -> Void = { _, _ in }
}

extension EnvironmentValues {
    var showError: (Error, String?) -> Void {
        get { self[ShowErrorEnvironmentKey.self] }
        set { self[ShowErrorEnvironmentKey.self] = newValue }
    }
}

struct AlertWrapper: Identifiable {
    let id = UUID()
    let title: String
    let content: String?
}

struct ShowAlertEnvironmentKey: EnvironmentKey {
    static var defaultValue: (String, String?) -> Void = { _, _ in }
}

extension EnvironmentValues {
    var showAlert: (String, String?) -> Void {
        get { self[ShowAlertEnvironmentKey.self] }
        set { self[ShowAlertEnvironmentKey.self] = newValue }
    }
}
