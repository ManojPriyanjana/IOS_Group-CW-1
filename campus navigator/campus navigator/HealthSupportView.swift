import SwiftUI

struct HealthSupportView: View {
    var body: some View {
        VStack {
            Text("Health & Support Screen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
        }
        .navigationTitle("Health & Support")
        .navigationBarTitleDisplayMode(.inline)
        
        
        //--
        
     
        
        //--
    }
}

struct HealthSupportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HealthSupportView()
        }
    }
}
