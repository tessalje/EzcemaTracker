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

enum TriggerType: String, CaseIterable {
    case food = "Food"
    case weather = "Weather/Environment"
    case stress = "Stress"
    case animal = "Animal"
    case skincare = "Skincare"
    case medicine = "Medicine"
    case chemical = "Chemical/Material"
    case other = "Other"
    
    var symbol: String {
        switch self {
        case .food: return "fork.knife"
        case .weather: return "cloud.sun.fill"
        case .stress: return "brain.head.profile.fill"
        case .animal: return "pawprint.fill"
        case .skincare: return "bubbles.and.sparkles.fill"
        case .medicine: return "pills.fill"
        case .chemical: return "eyedropper.halffull"
        case .other: return "heart.fill"
        }
    }
}
    
