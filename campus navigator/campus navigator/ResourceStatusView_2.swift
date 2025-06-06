import SwiftUI

struct SegmentExampleView: View {
    
    @State private var selectedSegment = "Available"
    @State private var searchText = ""
    
    let segments = ["Available", "All"]
    
    // Data model (dates removed!)
    struct ResourceItem: Identifiable {
        let id = UUID()
        let name: String
        let systemIconName: String
        let isAvailable: Bool
        let availableTime: String?
        let unavailableTime: String?
        let openHours: String
        let closeHours: String
        let crowdLevel: String
    }
    
    // Example data
    let allItems = [
        ResourceItem(
            name: "PC Lab 1",
            systemIconName: "desktopcomputer",
            isAvailable: true,
            availableTime: "10:00 AM - 12:00 PM",
            unavailableTime: nil,
            openHours: "8:00 AM",
            closeHours: "8:00 PM",
            crowdLevel: "Low"
        ),
        
        ResourceItem(
            name: "Library Room A",
            systemIconName: "books.vertical",
            isAvailable: true,
            availableTime: "1:00 PM - 3:00 PM",
            unavailableTime: nil,
            openHours: "9:00 AM",
            closeHours: "6:00 PM",
            crowdLevel: "Medium"
        ),
        
        ResourceItem(
            name: "Study Room B",
            systemIconName: "person.2.square.stack.fill",
            isAvailable: false,
            availableTime: nil,
            unavailableTime: "Booked until 4:00 PM",
            openHours: "9:00 AM",
            closeHours: "5:00 PM",
            crowdLevel: "High"
        ),
        
        // Cafeteria → always available
        ResourceItem(
            name: "Cafeteria",
            systemIconName: "fork.knife",
            isAvailable: true, // Always available
            availableTime: "7:00 AM - 7:00 PM",
            unavailableTime: nil,
            openHours: "7:00 AM",
            closeHours: "7:00 PM",
            crowdLevel: "High" // Any level allowed
        )
    ]
    
    // Filtered items
    var filteredItems: [ResourceItem] {
        let items = selectedSegment == "Available" ? allItems.filter { $0.isAvailable } : allItems
        
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            // Segmented Picker
            Picker("Options", selection: $selectedSegment) {
                ForEach(segments, id: \.self) { segment in
                    Text(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Search Bar
            TextField("Search resources", text: $searchText)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Scrollable cards
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredItems) { item in
                        ResourceCardView(resource: item)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Resources")
    }
}

struct ResourceCardView: View {
    let resource: SegmentExampleView.ResourceItem
    
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
        VStack(alignment: .leading, spacing: 12) {
            
            // Top: Icon + Name
            HStack(spacing: 12) {
                Image(systemName: resource.systemIconName)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(resource.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            Divider()
            
            // Availability
            if resource.isAvailable {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Available: \(resource.availableTime ?? "-")")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
            } else {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Unavailable: \(resource.unavailableTime ?? "-")")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
            }
            
            // Open / Close Hours
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text("Open: \(resource.openHours)  |  Close: \(resource.closeHours)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Crowd Level
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(crowdColor)
                Text("Crowd Level: \(resource.crowdLevel)")
                    .font(.footnote)
                    .foregroundColor(crowdColor)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    SegmentExampleView()
}
