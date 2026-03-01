//
//  Itch.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 1/3/26.
//

import SwiftData
import SwiftUI

@Model
class Itch: Identifiable {
    var id = UUID()
    var date: Date
    var average: Double
    
    init(date: Date = Date(), average: Double) {
        self.date = date
        self.average = average
    }
    
    var severityLevel: String {
        switch average {
        case 0:
            return "None"
        case 0..<2:
            return "Mild"
        case 2..<4:
            return "Moderate"
        default:
            return "Severe"
        }
    }
}
