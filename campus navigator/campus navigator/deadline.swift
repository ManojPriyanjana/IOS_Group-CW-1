//
//  deadline.swift
//  University navigator
//
//  Created by Nadeemal 021 on 2025-06-13.
//

import SwiftUI

struct Deadline: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let time: String
    let status: Status

    enum Status {
        case today, upcoming
        
        var label: String {
            switch self {
            case .today: return "Today"
            case .upcoming: return "Upcoming"
            }
        }
        
        var color: Color {
            switch self {
            case .today: return Color.green.opacity(0.2)
            case .upcoming: return Color.blue.opacity(0.2)
            }
        }
        
        var textColor: Color {
            switch self {
            case .today: return .green
            case .upcoming: return .blue
            }
        }
    }
}

struct DeadlineCard: View {
    let deadline: Deadline

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "calendar")
                .foregroundColor(.blue)
                .font(.title2)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(deadline.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("Date: \(deadline.date)   Time: \(deadline.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(deadline.status.label)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(deadline.status.color)
                    .foregroundColor(deadline.status.textColor)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
}

struct AcademicDeadlinesInlineView: View {
    let allDeadlines = [
        Deadline(title: "Assignments Submission", date: "2025-06-13", time: "06:00 PM", status: .today),
        Deadline(title: "Guest Lecture Series", date: "2025-06-13", time: "02:00 PM", status: .today),
        Deadline(title: "Registration Deadline - Fall Semester", date: "2025-08-15", time: "11:59 PM", status: .upcoming),
        Deadline(title: "Course Withdrawal Deadline", date: "2025-09-01", time: "05:00 PM", status: .upcoming),
        Deadline(title: "Mid-Term Exam Period Starts", date: "2025-10-13", time: "09:00 AM", status: .upcoming)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Academic Deadlines")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)

                    ForEach(allDeadlines) { deadline in
                        DeadlineCard(deadline: deadline)
                    }
                }
                .padding()
            }
        }
    }
}

struct AcademicDeadlinesInlineView_Previews: PreviewProvider {
    static var previews: some View {
        AcademicDeadlinesInlineView()
    }
}
