import SwiftUI

struct IndoorMapView: View {
    var body: some View {
        VStack {
            Text("Indoor Map Screen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
        }
        .navigationTitle("Indoor Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IndoorMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IndoorMapView()
        }
    }
}

