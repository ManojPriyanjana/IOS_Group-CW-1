import SwiftUI

struct ContentView: View {
    // Example state (e.g. email, navigation path)
    @State private var email: String = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
           
            // this line add by me
            
            ZStack {
                
                // 1) Background Image
                // ───────────────────────────────────────────────────────
                Image("BackgroundImage")
                    .resizable()             // allow scaling
                    .scaledToFill()          // fill the view’s frame
                    .ignoresSafeArea()       // extend behind notch/home indicator

              
                // 2) Foreground Content
               //------------------------------------------------------------
                VStack(spacing: 20) {
                    Spacer().frame(height: 150)

                    // Example: Your logo at top
                    Image("Nibm_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 60)

                    Text("Campus Navigator")
                        .font(.title2).bold()
                        .foregroundColor(.blue)

                    Spacer().frame(height: 70)
                    
                    //card test
                    
                    // card test end

                    // Example: Email TextField on top of the image
                    TextField("Enter Campus Email", text: $email)
                        .padding(12)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                        .padding(.horizontal, 100)

                    // Example: Login Button
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

                    // Example: “Continue as Guest”
                    Button {
                        isLoggedIn = true
                    } label: {
                        Text("Continue as Guest")
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.bottom, 40)
            }
            // Example navigation: when isLoggedIn == true, navigate to DashboardView()
            .navigationDestination(isPresented: $isLoggedIn) {
                DashboardView()
            }
        }
    }
}


#Preview {
    ContentView()
}
