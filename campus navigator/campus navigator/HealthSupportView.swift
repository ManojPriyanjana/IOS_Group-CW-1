import SwiftUI

struct UniversityHealthSupportView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Health & Support")
                            .font(.system(size: 32, weight: .bold))

                        Text("Find health resources, emergency contacts, and emotional support.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    // Health Center Card
                    SupportFeatureCard(
                        icon: "cross.case.fill",
                        title: "Campus Health Center",
                        description: "General medical services for students. Open 8 AM – 5 PM (Mon–Fri).",
                        actionLabel: "View Location"
                    )

                    // Mental Health
                    SupportFeatureCard(
                        icon: "face.smiling.fill",
                        title: "Mental Wellness",
                        description: "Counseling, workshops, and emotional support for students.",
                        actionLabel: "Explore Support"
                    )

                    // Emergency Contacts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Emergency Contacts")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        VStack(spacing: 14) {
                            EmergencyContactRow(name: "Campus Security", phone: "011-1234567")
                            EmergencyContactRow(name: "Medical Emergency", phone: "011-7654321")
                            EmergencyContactRow(name: "Mental Health Helpline", phone: "011-9988776")
                        }
                        .padding(.horizontal)
                    }

                    // Quick Actions
                    VStack(spacing: 20) {
                        SupportActionButton(
                            label: "Report a Health or Safety Issue",
                            systemIcon: "exclamationmark.bubble.fill",
                            color: .orange
                        )

                        SupportActionButton(
                            label: "Student Help Center",
                            systemIcon: "questionmark.circle.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Support")
        }
    }
}

// MARK: - Components

struct SupportFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let actionLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Button(action: {
                // Handle button action
            }) {
                Text(actionLabel)
                    .font(.subheadline)
                    .bold()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

struct EmergencyContactRow: View {
    let name: String
    let phone: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .bold()
                Text(phone)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                let tel = phone.replacingOccurrences(of: "-", with: "")
                if let url = URL(string: "tel://\(tel)") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.green)
                    .padding(8)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 0.5)
    }
}

struct SupportActionButton: View {
    let label: String
    let systemIcon: String
    let color: Color

    var body: some View {
        Button(action: {
            // Handle quick action
        }) {
            HStack {
                Image(systemName: systemIcon)
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(label)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
}
#Preview {
    
}