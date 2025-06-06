// File: ResourceStatusView.swift

import SwiftUI

// MARK: – 1) Model & Sample Data

struct Resource: Identifiable {
    enum CrowdLevel: String {
        case low    = "Low"
        case medium = "Medium"
        case high   = "High"
    }
    
    enum AvailabilityStatus: String {
        case available   = "Available"
        case unavailable = "Unavailable"
    }
    
    let id = UUID()
    let name: String
    let systemIconName: String   // Replace with your own SF Symbols or asset names
    let status: AvailabilityStatus
    let crowd: CrowdLevel
    let availableTime: String?   // e.g. “10:30am – 12:30pm” if it’s a study room
    let openHours: String        // Always show, e.g. “7:30am – 4:30pm”
    
    /// Sample data for previews and development
    static let sampleResources: [Resource] = [
        Resource(
            name: "Cafeteria",
            systemIconName: "cup.and.saucer.fill",
            status: .available,
            crowd: .high,
            availableTime: nil,
            openHours: "7:30am – 4:30pm"
        ),
        Resource(
            name: "Library",
            systemIconName: "book.closed.fill",
            status: .available,
            crowd: .high,
            availableTime: nil,
            openHours: "7:30am – 4:30pm"
        ),
        Resource(
            name: "Study Room 1",
            systemIconName: "text.book.closed.fill",
            status: .available,
            crowd: .low,
            availableTime: "10:30am – 12:30pm",
            openHours: "7:30am – 4:30pm"
        ),
        Resource(
            name: "Study Room 2",
            systemIconName: "text.book.closed.fill",
            status: .available,
            crowd: .low,
            availableTime: "10:30am – 12:30pm",
            openHours: "7:30am – 4:30pm"
        ),
        Resource(
            name: "PC Lab 1",
            systemIconName: "desktopcomputer",
            status: .unavailable,
            crowd: .low,
            availableTime: "10:30am – 12:30pm",
            openHours: "7:30am – 4:30pm"
        ),
        Resource(
            name: "PC Lab 2",
            systemIconName: "desktopcomputer",
            status: .unavailable,
            crowd: .high,
            availableTime: "10:30am – 12:30pm",
            openHours: "7:30am – 4:30pm"
        )
    ]
}


// MARK: – 2) ResourceStatusView

struct ResourceStatusView: View {
    private enum FilterOption: String, CaseIterable {
        case available = "Available"
        case all       = "All"
    }
    
    @State private var selectedFilter: FilterOption = .available
    @State private var searchText: String = ""
    
    // In a real app, replace this with your actual data source
    private let allResources: [Resource] = Resource.sampleResources
    
    private var filteredResources: [Resource] {
        allResources.filter { resource in
            // 1) Filter by availability if “Available” is selected
            let matchesAvailability: Bool = {
                switch selectedFilter {
                case .available:
                    return resource.status == .available
                case .all:
                    return true
                }
            }()
            
            // 2) Filter by searchText (case-insensitive)
            let matchesSearch: Bool = {
                guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return true
                }
                return resource.name.lowercased()
                    .contains(searchText.lowercased().trimmingCharacters(in: .whitespaces))
            }()
            
            return matchesAvailability && matchesSearch
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ─────────────────────────────────────────────────────────
            // (A) Search Bar & Filter Icon
            // ─────────────────────────────────────────────────────────
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Start Searching...", text: $searchText)
                    .foregroundColor(.primary)
                    .font(.body)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 4)
                    .accessibilityLabel("Clear search text")
                }
                
                Spacer()
                
                Button {
                    // TODO: Show advanced filters sheet
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                }
                .accessibilityLabel("Filter")
            }
            .padding(10)
            .background(Color.searchFieldBackground)       // from Helpers.swift
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.searchFieldBorder, lineWidth: 1) // from Helpers.swift
            )
            .padding(.horizontal)
            .padding(.top) // safe‐area top
            
            // ─────────────────────────────────────────────────────────
            // (B) Available / All Toggle (Custom “Segmented” Control)
            // ─────────────────────────────────────────────────────────
            HStack(spacing: 0) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.easeInOut) {
                            selectedFilter = option
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == option ? .semibold : .regular)
                            .foregroundColor(selectedFilter == option ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                Group {
                                    if selectedFilter == option {
                                        Color.purpleAccent
                                    } else {
                                        Color.purpleAccent.opacity(0.3)
                                    }
                                }
                            )
                    }
                    .cornerRadius(10, corners: option == .available
                                 ? [.topLeft, .bottomLeft]
                                 : [.topRight, .bottomRight])
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 4)
            
            // ─────────────────────────────────────────────────────────
            // (C) Scrollable List of Filtered Resources
            // ─────────────────────────────────────────────────────────
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredResources) { resource in
                        ResourceRowView(resource: resource)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("Resource Status")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: – 3) ResourceRowView (Single Card Row)

struct ResourceRowView: View {
    let resource: Resource
    
    var body: some View {
        VStack(spacing: 0) {
            // (1) Top “header” bar
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: resource.systemIconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.purpleAccent)
                    .cornerRadius(8)
                
                Text(resource.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color.purpleAccent.opacity(0.5))
            
            // (2) Detail section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Status : ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(resource.status == .available ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(resource.status.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Crowd : ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(crowdColor(for: resource.crowd))
                        .frame(width: 10, height: 10)
                    Text(resource.crowd.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                if let availableTime = resource.availableTime {
                    HStack(alignment: .top) {
                        Text("Available : ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(availableTime)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                
                HStack {
                    Text("Open Hours : ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(resource.openHours)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.07), radius: 3, x: 0, y: 2)
    }
    
    /// Returns a dot color for crowd level
    private func crowdColor(for level: Resource.CrowdLevel) -> Color {
        switch level {
        case .low:    return .green
        case .medium: return .orange
        case .high:   return .red
        }
    }
}


// MARK: – 4) Previews

struct ResourceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResourceStatusView()
        }
        .preferredColorScheme(.light)
        
        NavigationView {
            ResourceStatusView()
        }
        .preferredColorScheme(.dark)
    }
}

struct ResourceRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResourceRowView(resource: Resource.sampleResources[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
