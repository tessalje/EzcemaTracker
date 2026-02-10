//
//  SeverityTracker.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI

struct SeverityTracker: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Track itchiness of each part by tapping on Pip")
                Image("pip")
                    .resizable()
            }
            .navigationTitle("Itch Tracker")
        }
    }
}

#Preview {
    SeverityTracker()
}
