import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
