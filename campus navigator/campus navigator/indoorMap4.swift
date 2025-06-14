import SwiftUI

// 1️⃣ Your location model — now Equatable
struct Location: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let floor: Int
    /// normalized (0…1) coords on the image
    let normalizedPosition: CGPoint
}

// 2️⃣ Define all your spots here
let allLocations: [Location] = [
    // Floor 1
    .init(name: "Main Entrance", floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.80)),
    .init(name: "Library",       floor: 1, normalizedPosition: CGPoint(x: 0.75, y: 0.60)),
    .init(name: "Security Desk", floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.60)),
    .init(name: "Canteen",       floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.40)),
    .init(name: "Lecture Hall",  floor: 1, normalizedPosition: CGPoint(x: 0.75, y: 0.30)),
    // Floor 2
    .init(name: "iOS Lab",       floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.25)),
    .init(name: "Computer Lab",  floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.55)),
    .init(name: "Network Lab",   floor: 2, normalizedPosition: CGPoint(x: 0.75, y: 0.40)),
    .init(name: "Seminar Room",  floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.75)),
    .init(name: "Restrooms",     floor: 2, normalizedPosition: CGPoint(x: 0.75, y: 0.20)),
    // Floor 3
    .init(name: "AI Lab",        floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.25)),
    .init(name: "Cloud Lab",     floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.55)),
    .init(name: "Mechanical",    floor: 3, normalizedPosition: CGPoint(x: 0.75, y: 0.40)),
    .init(name: "Offices",       floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.80)),
    .init(name: "Conference",    floor: 3, normalizedPosition: CGPoint(x: 0.75, y: 0.75)),
]

struct IndoorMapView4: View {
    // MARK: — Search & selection
    @State private var searchText     = ""
    @State private var suggestions    = [Location]()
    @State private var selectedLoc: Location?
    
    // MARK: — Floor & gesture state
    @State private var selectedFloor  = 1
    @State private var currentScale   : CGFloat = 1.0
    @State private var currentOffset  : CGSize  = .zero
    
    @GestureState private var pinchScale : CGFloat = 1.0
    @GestureState private var dragOffset  : CGSize  = .zero
    
    // capture the map size for centering math
    @State private var mapSize = CGSize.zero
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Building A Navigator")
                .font(.system(size: 24, weight: .bold))
            
            // Searchable top bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Find a room…", text: $searchText)
                        .autocapitalization(.none)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                Button("Search") {
                    // no-op: suggestions show automatically
                }
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            .searchable(text: $searchText, prompt: "Find a room…") {
                ForEach(suggestions) { loc in
                    Button(loc.name) {
                        select(location: loc)
                    }
                }
            }
            .onChange(of: searchText) { txt in
                suggestions = txt.isEmpty
                    ? []
                    : allLocations.filter {
                        $0.name.lowercased().contains(txt.lowercased())
                    }
            }
            
            // Floor Picker
            Picker("", selection: $selectedFloor) {
                Text("Floor 1").tag(1)
                Text("Floor 2").tag(2)
                Text("Floor 3").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Zoomable & pannable map
            GeometryReader { geo in
                ZStack {
                    // Map image + gestures
                    Image("building_floor\(selectedFloor)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(currentScale * pinchScale, anchor: .topLeading)
                        .offset(
                            x: currentOffset.width + dragOffset.width,
                            y: currentOffset.height + dragOffset.height
                        )
                        .onAppear { mapSize = geo.size }
                        .onChange(of: geo.size) { mapSize = $0 }
                        .gesture(
                            MagnificationGesture()
                                .updating($pinchScale) { v, s, _ in s = v }
                                .onEnded { final in
                                    let newScale = currentScale * final
                                    currentScale = min(max(newScale, 1), 4)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($dragOffset) { v, s, _ in s = v.translation }
                                .onEnded { v in
                                    currentOffset.width  += v.translation.width
                                    currentOffset.height += v.translation.height
                                }
                        )
                        .clipped()
                    
                    // Elevator pin (fixed)
                    Image(systemName: "tram.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .position(x: mapSize.width * 0.8, y: mapSize.height * 0.2)
                    
                    // Highlight circle
                    if let loc = selectedLoc, loc.floor == selectedFloor {
                        Circle()
                            .stroke(Color.blue, lineWidth: 3)
                            .frame(width: 60, height: 60)
                            .position(
                                x: (loc.normalizedPosition.x * mapSize.width) * currentScale + currentOffset.width,
                                y: (loc.normalizedPosition.y * mapSize.height) * currentScale + currentOffset.height
                            )
                            .animation(.easeOut, value: selectedLoc)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .frame(minHeight: 400)
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    // MARK: — Handle search selection
    private func select(location: Location) {
        selectedFloor = location.floor
        selectedLoc   = location
        
        // zoom and center
        let targetScale: CGFloat = 2.0
        currentScale = min(max(targetScale, 1), 4)
        
        let scaledW = mapSize.width  * currentScale
        let scaledH = mapSize.height * currentScale
        
        let tgtX = location.normalizedPosition.x * scaledW
        let tgtY = location.normalizedPosition.y * scaledH
        
        currentOffset = CGSize(
            width: mapSize.width/2  - tgtX,
            height: mapSize.height/2 - tgtY
        )
    }
}

// ✅ Only one preview declaration
struct IndoorMapView4_Previews: PreviewProvider {
    static var previews: some View {
        IndoorMapView4()
            .previewDevice("iPhone 16 Pro")
    }
}
