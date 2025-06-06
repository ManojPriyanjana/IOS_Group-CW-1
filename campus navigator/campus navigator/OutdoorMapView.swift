import SwiftUI

struct OutdoorMapView: View {
    var body: some View {
        VStack {
            Text("Outdoor Map Screen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
        }
        .navigationTitle("Outdoor Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OutdoorMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OutdoorMapView()
        }
    }
}
