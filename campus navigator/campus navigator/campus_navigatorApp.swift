
import SwiftUI

@main
struct campus_navigatorApp: App {
    
    @State private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                            
                        MainTabView()
                        } else {
                            ContentView(isLoggedIn: $isLoggedIn)
                        }
        }
    }
}
