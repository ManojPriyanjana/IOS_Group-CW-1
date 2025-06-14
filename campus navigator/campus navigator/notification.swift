//
//  notification.swift
//  University navigator
//
//  Created by Nadeemal 021 on 2025-06-13.
//

import SwiftUI

struct Notification: Identifiable {
    let id: UUID
    var title: String
    var date: String
    var icon: String
    var message: String?
    var isUnread: Bool
}

struct NotificationsView: View {
    @State private var expandedNotificationID: UUID? = nil
    @State private var notifications: [Notification] = [
        Notification(id: UUID(), title: "Course Registration Reminder",
                     date: "June 10, 2025 at 02:30 PM",
                     icon: "lightbulb.fill",
                     message: "Don't forget to register for your upcoming semester courses before the deadline.",
                     isUnread: true),
        
        Notification(id: UUID(), title: "Library Extended Hours",
                     date: "June 8, 2025 at 08:00 PM",
                     icon: "calendar",
                     message: "The university library will be open until midnight during finals week.",
                     isUnread: false),
        
        Notification(id: UUID(), title: "Urgent: System Maintenance",
                     date: "June 5, 2025 at 03:30 PM",
                     icon: "exclamationmark.triangle.fill",
                     message: "University systems will undergo maintenance on June 6 from 1:00 AM to 4:00 AM. Services may be temporarily unavailable.",
                     isUnread: false),
        
        Notification(id: UUID(), title: "Appointment Confirmed: Prof. Johnson",
                     date: "June 9, 2025 at 05:15 PM",
                     icon: "person.crop.circle.badge.checkmark",
                     message: "Your appointment with Prof. Johnson is scheduled for June 16 at 10:00 AM in Room 205, Arts Building.",
                     isUnread: true),
        
        Notification(id: UUID(), title: "New Study Room Available",
                     date: "June 7, 2025 at 09:30 PM",
                     icon: "lightbulb.fill",
                     message: "Room B12 is now open for student booking. Reserve via the facility management portal.",
                     isUnread: false),
        
        Notification(id: UUID(), title: "Annual University Fair",
                     date: "June 1, 2025 at 01:30 PM",
                     icon: "calendar",
                     message: "Join us at the main auditorium to explore clubs, organizations, and career opportunities.",
                     isUnread: false)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Text("Your Notifications")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            notifications.removeAll()
                        }) {
                            Text("Clear All")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("You have \(notifications.filter { $0.isUnread }.count) unread notification\(notifications.filter { $0.isUnread }.count == 1 ? "" : "s").")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    ForEach(notifications.indices, id: \.self) { index in
                        NotificationCard(notification: $notifications[index],
                                         expandedNotificationID: $expandedNotificationID)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct NotificationCard: View {
    @Binding var notification: Notification
    @Binding var expandedNotificationID: UUID?

    var isExpanded: Bool {
        expandedNotificationID == notification.id
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    // Expand or collapse
                    expandedNotificationID = isExpanded ? nil : notification.id
                    // Mark as read
                    notification.isUnread = false
                }
            }) {
                HStack {
                    Image(systemName: notification.icon)
                        .foregroundColor(notification.isUnread ? .blue : .gray)
                        .font(.title2)
                    Text(notification.title)
                        .font(.headline)
                        .foregroundColor(notification.isUnread ? .blue : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.gray)
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
            }

            Text(notification.date)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 2)

            if isExpanded, let message = notification.message {
                Text(message)
                    .font(.subheadline)
                    .padding(.top, 8)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
