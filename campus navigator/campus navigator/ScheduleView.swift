import SwiftUI

struct ScheduleView: View {
    var body: some View {
        VStack {
            Text("Schedule Screen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            
        }
        .navigationTitle("My Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScheduleView()
        }
    }
}
