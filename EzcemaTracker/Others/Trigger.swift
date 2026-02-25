//
//  Trigger.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 22/2/26.
//

import SwiftData
import SwiftUI

@Model
class TriggerData: Identifiable {
    var id: UUID
    var triggerTitle: String
    var severity: Int
    var type: String
    var tint: TaskTint
    
    init(id: UUID = .init(), triggerTitle: String, severity: Int, type: String, tint: TaskTint = .blue) {
        self.id = id
        self.triggerTitle = triggerTitle
        self.severity = severity
        self.type = type
        self.tint = tint
    }
    
    var tintColor: Color {
        tint.color
    }
}
    
