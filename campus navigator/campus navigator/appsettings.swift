//
//  appsettings.swift
//  University navigator
//
//  Created by Nadeemal 021 on 2025-06-13.
//

import SwiftUI

struct AppSettingsView: View {
    @State private var notificationsEnabled = true
    @State private var selectedRole = "Student"
    @State private var mapTheme = "Light"
    @State private var preferredBuilding = "Select One"
    
    @State private var busyPlaceAlerts = false
    @State private var eventReminders = true
    @State private var syncEvents = false
    
    @State private var allowAppointments = true
    
    let roles = ["Student", "Faculty", "Guest"]
    let mapThemes = ["Light", "Dark"]
    let buildings = [
        "Select One",
        "Faculty of Arts",
        "Faculty of Science",
        "Engineering",
        "Business School",
        "Library",
        "Science Hall",
        "Gymnasium",
        "Administration"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Label("General", systemImage: "person.crop.circle")) {
                    Picker("Your Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) {
                            Text($0)
                        }
                    }
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Label("Navigation", systemImage: "map")) {
                    Picker("Map Theme", selection: $mapTheme) {
                        ForEach(mapThemes, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Preferred Building/Department", selection: $preferredBuilding) {
                        ForEach(buildings, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Label("Public Places & Events", systemImage: "bell")) {
                    Toggle("Receive Busy Place Alerts", isOn: $busyPlaceAlerts)
                    Toggle("Event Reminders", isOn: $eventReminders)
                    Toggle("Sync Events to Calendar", isOn: $syncEvents)
                }
                
                Section(header: Label("Appointments", systemImage: "calendar")) {
                    Toggle("Allow Appointment Requests", isOn: $allowAppointments)
                }
                
                // 🔐 Account Section
                Section(header: Label("Account", systemImage: "person.badge.key.fill")) {
                    Button(action: {
                        // Handle change password
                        print("Change Password tapped")
                    }) {
                        Label("Change Password", systemImage: "key.fill")
                    }

                    Button(action: {
                        // Handle logout
                        print("Logout tapped")
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("App Settings")
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView()
    }
}
