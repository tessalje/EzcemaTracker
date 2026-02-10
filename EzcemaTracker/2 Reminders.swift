//
//  Reminders.swift
//  EzcemaTracker
//
//  Created by Tessa Lee on 9/2/26.
//

import SwiftUI
internal import Combine

struct ReminderView: View {
    @State private var quote = "Take this time to rest and recharge"
    
    let quotes = [
        "Flare-ups are not your fault.",
        "Be gentle with your skin today.",
        "Healing takes time. You are improving.",
        "Press, don’t scratch.",
        "Pip believes in you!",
        "Remember to moisturise within 3 minutes after shower",
        "Use gentle, fragrance-free cleanser",
        "Trim nails to prevent damage",
        "Wear cotton to protect your skin",
        "Reapply cream on your hands after washing",
        "Try a cold cloth/ice pack to cool your skin",
        "Apply moisturiser instead of scratching",
        "Take 3 slow breaths before reacting",
        "Focus on hand care today",
        "You’re improving — keep going!",
        "Sending you a big hug and wishing you a speedy recovery!",
        "Hoping each day brings you closer to recovery",
        "Rest up and take all the time you need to heal",
        "Remember: Health is your top priority",
        "Better days are ahead",
        "Take your medication!",
        "Keep showers under 10-15 minutes with lukewarm water",
        "Gently pat skin dry with a towel instead of rubbing",
        "Use a humidifier to prevent dry air",
        "Consult a doctor if skin becomes infected",
        "Stay calm! High stress can trigger flares",
        "Apply thick creams or ointments"
    ]

    @State private var timer = Timer.publish(every: 500, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(quote)
                .padding()
                .multilineTextAlignment(.center)
        }
        .onReceive(timer) { _ in
            refreshQuote()
        }
    }
    
    func refreshQuote() {
        quote = quotes.randomElement() ?? ""
    }
}
