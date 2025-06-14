import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var showGuestMap: Bool = false  // NEW

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer().frame(height: 150)

                    Image("Nibm_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 80)

                    Text("Campus Navigator")
                        .font(.title2).bold()
                        .foregroundColor(.blue)

                    Spacer().frame(height: 70)

                    // Email Input
                    TextField("Enter Campus Email", text: $email)
                        .padding(12)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                        .padding(.horizontal, 100)

                    // Login Button
                    Button {
                        isLoggedIn = true
                    } label: {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(8)
                            .padding(.horizontal, 100)
                    }

                    // Continue as Guest Button
                    Button {
                        showGuestMap = true  // Trigger map view
                    } label: {
                        Text("Continue as Guest")
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(.top, 10)

                    // Guest NavigationLink (Hidden)
                    NavigationLink(
                        destination: OutdoorMapView(),
                        isActive: $showGuestMap,
                        label: {
                            EmptyView()
                        }
                    )
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ContentView(isLoggedIn: .constant(false))
}
