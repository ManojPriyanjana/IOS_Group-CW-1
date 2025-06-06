import SwiftUI

struct ContentView: View {
    // 👇 Receive isLoggedIn from parent
    @Binding var isLoggedIn: Bool
    
    // Example state (e.g. email)
    @State private var email: String = ""

    var body: some View {
        NavigationStack {
            
            ZStack {
                // 1) Background Image
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // 2) Foreground Content
                VStack(spacing: 20) {
                    Spacer().frame(height: 150)
                    
                    Image("Nibm_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 60)
                    
                    Text("Campus Navigator")
                        .font(.title2).bold()
                        .foregroundColor(.blue)
                    
                    Spacer().frame(height: 70)
                    
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
                        isLoggedIn = true // 👈 trigger switch to MainTabView
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
                    
                    // Continue as Guest
                    Button {
                        isLoggedIn = true // 👈 also trigger MainTabView
                    } label: {
                        Text("Continue as Guest")
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
            
            // ❌ REMOVE this old navigationDestination
            // .navigationDestination(isPresented: $isLoggedIn) { DashboardView() }
            // Now handled in App entry point!
        }
    }
}

#Preview {
    // Preview needs a constant Binding
    ContentView(isLoggedIn: .constant(false))
}
