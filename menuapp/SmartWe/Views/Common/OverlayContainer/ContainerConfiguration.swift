//
//  ContainerConfiguration.swift
//

import Foundation
import SwiftUIOverlayContainer

struct ContainerConfiguration: ContainerConfigurationProtocol {
    var displayType: ContainerViewDisplayType = .stacking
    var queueType: ContainerViewQueueType = .multiple
    var backgroundStyle: ContainerBackgroundStyle? = .blur(.regular)
    var tapToDismiss: Bool? = true
    var ignoresSafeArea: ContainerIgnoresSafeArea = .all
    static let share = ContainerConfiguration()
}

let backdropContainerName = "backdropContainer"
