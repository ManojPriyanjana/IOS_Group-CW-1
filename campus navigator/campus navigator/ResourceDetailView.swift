import SwiftUI

struct ResourceDetailView: View {
    let resource: ResourceStatusView_2.ResourceItem
    
    var crowdColor: Color {
        switch resource.crowdLevel.lowercased() {
        case "low": return .green
        case "medium": return .orange
        case "high": return .red
        case "full": return .gray
        default: return .secondary
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text(resource.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if resource.isAvailable {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Available Today: \(resource.availableTime ?? "-")")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                } else {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("Unavailable Today: \(resource.unavailableTime ?? "-")")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("Open: \(resource.openHours)  |  Close: \(resource.closeHours)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(crowdColor)
                    Text("Crowd Level: \(resource.crowdLevel)")
                        .font(.footnote)
                        .foregroundColor(crowdColor)
                }
                
                Divider()
                
                Text("Booked Dates")
                    .font(.headline)
                
                CalendarView(bookedDates: resource.bookedDates)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(resource.name)
    }
}
