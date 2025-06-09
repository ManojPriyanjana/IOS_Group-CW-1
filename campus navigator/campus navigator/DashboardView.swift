

import SwiftUI

struct DashboardView: View {
    @State private var searchText: String = ""
    
    // Two equally flexible columns with 16pt spacing
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            // Background: grouped system background (light gray in Light mode)
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
                        VStack(spacing: 24) {
                            
                          
                            // 1) Header Card: “Welcome, Manoj!” + Profile Icon
                            // -------------------------------------------------
                            HStack {
                                Text("Welcome, Manoj!")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button {
                                    // TODO: Profile action
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
                            .frame(height: 72) // fixed height to center vertically
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .shadow(color: Color.black.opacity(0.05),
                                            radius: 4, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                            
                          
                            // 2) Search Bar: “Campus Search”
                            // ----------------------------
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
                                    .shadow(color: Color.black.opacity(0.03),
                                            radius: 2, x: 0, y: 1)
                            )
                            .padding(.horizontal)
                            
                      
                            // 3) “My Schedule” Button (Bright Yellow Card)
                            // -----------------------------------------
                           
                            // my card
                            NavigationLink(destination: ScheduleView()) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 350, height: 150)
                                        .shadow(radius: 8)

                                    Image("food")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                            
                          
                            // 4) 2×2 Grid of Navy-Blue Cards
                            // ---------------------------------------------
                            LazyVGrid(columns: gridColumns, spacing:10) {
                                CardButton(
                                    title: "Outdoor Map",
                                    systemIconName: "map.fill",
                                    backgroundColor: .primaryBlue
                                ) {
                                    OutdoorMapView()
                                }
                                
                                CardButton(
                                    title: "Indoor Map",
                                    systemIconName: "building.2.fill",
                                    backgroundColor: .primaryBlue
                                ) {
                                    IndoorMapView()
                                }
                                
                                CardButton(
                                    title: "Resource Status",
                                    systemIconName: "square.grid.3x3.fill",
                                    backgroundColor: .primaryBlue
                                ) {
//                                    ResourceStatusView()
                                    ResourceStatusView_2()

                                }
                                
                                CardButton(
                                    title: "Health & Support",
                                    systemIconName: "cross.case.fill",
                                    backgroundColor: .primaryBlue
                                ) {
                                    HealthSupportView()
                                }
                            }
                            .padding()
                            
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

// MARK: – CardButton (Reusable for Grid Items)

struct CardButton<Destination: View>: View {
    let title: String
    let systemIconName: String
    let backgroundColor: Color
    let destination: () -> Destination
    
    @State private var isPressed = false
    
    init(
        title: String,
        systemIconName: String,
        backgroundColor: Color,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.systemIconName = systemIconName
        self.backgroundColor = backgroundColor
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(spacing: 12) {
                Image(systemName: systemIconName)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(backgroundColor)
                    .shadow(
                        color: Color.black.opacity(isPressed ? 0.02 : 0.15),
                        radius: isPressed ? 1 : 6,
                        x: 0,
                        y: isPressed ? 1 : 4
                    )
            )
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

// MARK: – Color Extensions (Navy & Yellow)

// Navy‐blue primary color (adapts slightly in Dark Mode)
extension Color {
    static var primaryBlue: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 20/255, green: 45/255, blue: 120/255, alpha: 1)
                : UIColor(red: 10/255, green: 33/255, blue: 91/255, alpha: 1)
        })
    }
    
    // Bright yellow accent (adapts to muted gold in Dark Mode)
    static var accentYellow: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 200/255, green: 180/255, blue: 0/255, alpha: 1)
                : UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        })
    }
}

// MARK: – Previews

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .preferredColorScheme(.light)
        
        DashboardView()
            .preferredColorScheme(.dark)
    }
}
