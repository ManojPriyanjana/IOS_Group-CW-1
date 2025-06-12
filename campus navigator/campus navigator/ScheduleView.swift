import SwiftUI

// MARK: - Schedule Model
struct ScheduleItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let location: String
    let type: String
    let date: Date
}

// MARK: - Schedule View
struct ScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()
    @State private var showAll = false

    // Sample schedule data
    let schedule: [ScheduleItem] = [
        ScheduleItem(title: "Data Structures Lecture", time: "8:00 AM - 10:00 AM", location: "Room 117", type: "Lecture", date: Date()),
        ScheduleItem(title: "AI Lab", time: "11:00 AM - 1:00 PM", location: "Lab 205", type: "Lab", date: Date()),
        ScheduleItem(title: "Project Meeting", time: "2:00 PM - 3:00 PM", location: "Room 122", type: "Meeting", date: Date()),
        ScheduleItem(title: "Cybersecurity Lecture", time: "9:00 AM - 11:00 AM", location: "Room 101", type: "Lecture", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        ScheduleItem(title: "Database Lab", time: "1:00 PM - 3:00 PM", location: "Lab 102", type: "Lab", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
    ]

    var filteredSchedule: [ScheduleItem] {
        if showAll {
            return schedule
        } else {
            return schedule.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Date Picker
            if !showAll {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
            }

            // Toggle
            Toggle("Show All Schedules", isOn: $showAll)
                .padding(.horizontal)

            // Section Header
            Text(showAll ? "All Schedules" : "Today's Schedule")
                .font(.headline)
                .padding(.horizontal)

            // Schedule List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredSchedule) { item in
                        ScheduleCard(item: item)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.top)
        .navigationTitle("My Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.leading, 6) // ✅ Added spacing for beauty under notch
                }
            }
        }
    }
}

// MARK: - Schedule Card View
struct ScheduleCard: View {
    let item: ScheduleItem
    @State private var isHovered = false

    var iconName: String {
        switch item.type {
        case "Lecture": return "book.closed"
        case "Lab": return "desktopcomputer"
        case "Meeting": return "person.2"
        default: return "calendar"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.blue)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(item.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if !Calendar.current.isDateInToday(item.date) {
                    Text(item.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isHovered ? Color.blue.opacity(0.15) : Color(.systemBackground))
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ScheduleView()
    }
}
