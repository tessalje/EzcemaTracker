//
//  EzcemaTrackerApp.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
import SwiftData

@main
struct EzcemaTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Photo.self, TrackerTask.self, SleepData.self,TriggerData.self])
    }
}
