import SwiftUI

struct DashboardView: View {
    @State private var searchText: String = ""
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // Welcome Header
                            HStack {
                                Text("Welcome, Manoj!")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button {
                                    // Profile action
                                } label: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.accentColor)
                                }
                                .accessibilityLabel("Profile")
                            }
                            .padding()
                            .frame(height: 72)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                            
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 18))
                                
                                TextField("Campus Search", text: $searchText)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 18))
                                
                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 18))
                                    }
                                    .padding(.trailing, 8)
                                    .accessibilityLabel("Clear search text")
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(UIColor.systemBackground))
                                    .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                            )
                            .padding(.horizontal)
                            
                            // Shared horizontal padding for My Schedule + Grid
                            VStack(spacing: 16) {
                                
                                // My Schedule Card
                                NavigationLink(destination: ScheduleView()) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("My Schedule")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.top, 12)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            Image("food")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .padding(.bottom, 12)
                                                .padding(.trailing, 12)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 140)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.indigo]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                                }
                                
                                // Grid of Feature Cards
                                LazyVGrid(columns: gridColumns, spacing: 16) {
                                    CardButton(title: "Outdoor Map", systemIconName: "map.fill") {
                                        OutdoorMapView()
                                    }
                                    
                                    CardButton(title: "Indoor Map", systemIconName: "building.2.fill") {
//                                        IndoorMapView()
                                        IndoorMapView4()
                                    }
                                    
                                    CardButton(title: "Resource Status", systemIconName: "square.grid.3x3.fill") {
                                        ResourceStatusView_2()
                                    }
                                    
                                    CardButton(title: "Health & Support", systemIconName: "cross.case.fill") {
                                        HealthSupportView()
                                    }
                                }
                            }
                            .padding(.horizontal) // ✅ Shared horizontal padding for alignment
                            
                            Spacer(minLength: 24)
                        }
                        .padding(.vertical, 24)
                    }
                    .scrollIndicators(.hidden)
                )
                .navigationTitle("Dashboard")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: – Professional Gradient CardButton

struct CardButton<Destination: View>: View {
    let title: String
    let systemIconName: String
    let destination: () -> Destination
    
    @State private var isPressed = false
    
    init(
        title: String,
        systemIconName: String,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.systemIconName = systemIconName
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination()) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.indigo]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: Color.black.opacity(isPressed ? 0.03 : 0.08),
                        radius: isPressed ? 2 : 6,
                        x: 0,
                        y: isPressed ? 1 : 3
                    )
                
                VStack(spacing: 10) {
                    Image(systemName: systemIconName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: – Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .preferredColorScheme(.light)
        
        DashboardView()
            .preferredColorScheme(.dark)
    }
}

