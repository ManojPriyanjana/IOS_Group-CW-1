
//import SwiftUI
//
//// 1️⃣ Your location model — now Equatable
//struct Location: Identifiable, Equatable {
//    let id = UUID()
//    let name: String
//    let floor: Int
//    /// normalized (0…1) coords on the image
//    let normalizedPosition: CGPoint
//}
//
//// 2️⃣ Define all your spots here
//let allLocations: [Location] = [
//    // Floor 1
//    .init(name: "Main Entrance", floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.80)),
//    .init(name: "Library",       floor: 1, normalizedPosition: CGPoint(x: 0.75, y: 0.60)),
//    .init(name: "Security Desk", floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.60)),
//    .init(name: "Canteen",       floor: 1, normalizedPosition: CGPoint(x: 0.15, y: 0.40)),
//    .init(name: "Lecture Hall",  floor: 1, normalizedPosition: CGPoint(x: 0.75, y: 0.30)),
//    // Floor 2
//    .init(name: "iOS Lab",       floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.25)),
//    .init(name: "Computer Lab",  floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.55)),
//    .init(name: "Network Lab",   floor: 2, normalizedPosition: CGPoint(x: 0.75, y: 0.40)),
//    .init(name: "Seminar Room",  floor: 2, normalizedPosition: CGPoint(x: 0.20, y: 0.75)),
//    .init(name: "Restrooms",     floor: 2, normalizedPosition: CGPoint(x: 0.75, y: 0.20)),
//    // Floor 3
//    .init(name: "AI Lab",        floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.25)),
//    .init(name: "Cloud Lab",     floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.55)),
//    .init(name: "Mechanical",    floor: 3, normalizedPosition: CGPoint(x: 0.75, y: 0.40)),
//    .init(name: "Offices",       floor: 3, normalizedPosition: CGPoint(x: 0.20, y: 0.80)),
//    .init(name: "Conference",    floor: 3, normalizedPosition: CGPoint(x: 0.75, y: 0.75)),
//]
//
//struct IndoorMapView4: View {
//    // MARK: — Search & selection
//    @State private var searchText     = ""
//    @State private var suggestions    = [Location]()
//    @State private var selectedLoc: Location?
//
//    // MARK: — Floor & gesture state
//    @State private var selectedFloor  = 1
//    @State private var currentScale   : CGFloat = 1.0
//    @State private var currentOffset  : CGSize  = .zero
//
//    @GestureState private var pinchScale : CGFloat = 1.0
//    @GestureState private var dragOffset  : CGSize  = .zero
//
//    // capture the map size for centering math
//    @State private var mapSize = CGSize.zero
//
//    var body: some View {
//        VStack(spacing: 16) {
//            // Title
//            Text("Building A Navigator")
//                .font(.system(size: 24, weight: .bold))
//
//            // Searchable top bar
//            HStack {
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                    TextField("Find a room…", text: $searchText)
//                        .autocapitalization(.none)
//                }
//                .padding(8)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//
//                Button("Search") {
//                    // no-op: suggestions show automatically
//                }
//                .fontWeight(.semibold)
//                .padding(.vertical, 8)
//                .padding(.horizontal, 12)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//            .padding(.horizontal)
//            .searchable(text: $searchText, prompt: "Find a room…") {
//                ForEach(suggestions) { loc in
//                    Button(loc.name) {
//                        select(location: loc)
//                    }
//                }
//            }
//            .onChange(of: searchText) { txt in
//                suggestions = txt.isEmpty
//                    ? []
//                    : allLocations.filter {
//                        $0.name.lowercased().contains(txt.lowercased())
//                    }
//            }
//
//            // Floor Picker
//            Picker("", selection: $selectedFloor) {
//                Text("Floor 1").tag(1)
//                Text("Floor 2").tag(2)
//                Text("Floor 3").tag(3)
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
//
//            // Zoomable & pannable map
//            GeometryReader { geo in
//                ZStack {
//                    // Map image + gestures
//                    Image("building_floor\(selectedFloor)")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: geo.size.width, height: geo.size.height)
//                        .scaleEffect(currentScale * pinchScale, anchor: .topLeading)
//                        .offset(
//                            x: currentOffset.width + dragOffset.width,
//                            y: currentOffset.height + dragOffset.height
//                        )
//                        .onAppear { mapSize = geo.size }
//                        .onChange(of: geo.size) { mapSize = $0 }
//                        .gesture(
//                            MagnificationGesture()
//                                .updating($pinchScale) { v, s, _ in s = v }
//                                .onEnded { final in
//                                    let newScale = currentScale * final
//                                    currentScale = min(max(newScale, 1), 4)
//                                }
//                        )
//                        .simultaneousGesture(
//                            DragGesture()
//                                .updating($dragOffset) { v, s, _ in s = v.translation }
//                                .onEnded { v in
//                                    currentOffset.width  += v.translation.width
//                                    currentOffset.height += v.translation.height
//                                }
//                        )
//                        .clipped()
//
//                    // Elevator pin (fixed)
//                    Image(systemName: "tram.fill")
//                        .font(.title2)
//                        .foregroundColor(.red)
//                        .position(x: mapSize.width * 0.8, y: mapSize.height * 0.2)
//
//                    // Highlight circle
//                    if let loc = selectedLoc, loc.floor == selectedFloor {
//                        Circle()
//                            .stroke(Color.blue, lineWidth: 3)
//                            .frame(width: 60, height: 60)
//                            .position(
//                                x: (loc.normalizedPosition.x * mapSize.width) * currentScale + currentOffset.width,
//                                y: (loc.normalizedPosition.y * mapSize.height) * currentScale + currentOffset.height
//                            )
//                            .animation(.easeOut, value: selectedLoc)
//                    }
//                }
//                .background(Color.white)
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//            }
//            .frame(minHeight: 400)
//            .padding(.horizontal)
//
//            Spacer()
//        }
//    }
//
//    // MARK: — Handle search selection
//    private func select(location: Location) {
//        selectedFloor = location.floor
//        selectedLoc   = location
//
//        // zoom and center
//        let targetScale: CGFloat = 2.0
//        currentScale = min(max(targetScale, 1), 4)
//
//        let scaledW = mapSize.width  * currentScale
//        let scaledH = mapSize.height * currentScale
//
//        let tgtX = location.normalizedPosition.x * scaledW
//        let tgtY = location.normalizedPosition.y * scaledH
//
//        currentOffset = CGSize(
//            width: mapSize.width/2  - tgtX,
//            height: mapSize.height/2 - tgtY
//        )
//    }
//}
//
//// Only one preview declaration
//struct IndoorMapView4_Previews: PreviewProvider {
//    static var previews: some View {
//        IndoorMapView4()
//            .previewDevice("iPhone 16 Pro")
//    }
//}

//------------------------


//import SwiftUI
//
//struct MapZone: Identifiable, Equatable {
//    let id = UUID()
//    let name: String
//    let floor: Int
//    let rect: CGRect
//}
//
//let allZones: [MapZone] = [
//    .init(name: "Student Computer Lab 117", floor: 1, rect: CGRect(x: 0.29, y: 0.50, width: 0.15, height: 0.08)),
//    .init(name: "Information Technology Support Services", floor: 1, rect: CGRect(x: 0.60, y: 0.48, width: 0.20, height: 0.15)),
//    .init(name: "iOS Lab", floor: 2, rect: CGRect(x: 0.20, y: 0.30, width: 0.12, height: 0.08)),
//    .init(name: "Mechanical", floor: 3, rect: CGRect(x: 0.55, y: 0.40, width: 0.15, height: 0.10)),
//]
//
//struct IndoorMapZoneView: View {
//    @State private var searchText = ""
//    @State private var selectedFloor = 1
//    @State private var selectedZone: MapZone? = nil
//
//    @State private var mapSize: CGSize = .zero
//    @State private var currentScale: CGFloat = 1.0
//    @State private var currentOffset: CGSize = .zero
//
//    @GestureState private var pinchScale: CGFloat = 1.0
//    @GestureState private var dragOffset: CGSize = .zero
//
//    @State private var zoomTarget: MapZone? = nil
//    @State private var isSearchTriggered = false
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Building A Navigator")
//                .font(.system(size: 24, weight: .bold))
//
//            // 🔍 Search Bar
//            HStack {
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                    TextField("Find a room…", text: $searchText)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                }
//                .padding(8)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//
//                Button("Search") {
//                    if let zone = allZones.first(where: { $0.name.lowercased().contains(searchText.lowercased()) }) {
//                        searchText = ""
//                        zoomTarget = zone
//                        selectedZone = nil
//                        isSearchTriggered = true  // 🧠 important
//                        selectedFloor = zone.floor
//                    }
//                }
//                .fontWeight(.semibold)
//                .padding(.vertical, 8)
//                .padding(.horizontal, 12)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//            .padding(.horizontal)
//
//            // 🏢 Floor Buttons
//            HStack(spacing: 16) {
//                ForEach(1...3, id: \.self) { floor in
//                    Button("Floor \(floor)") {
//                        handleManualFloorSwitch(floor)
//                    }
//                    .fontWeight(.semibold)
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 16)
//                    .background(selectedFloor == floor ? Color.gray.opacity(0.3) : Color(.systemGray6))
//                    .cornerRadius(10)
//                }
//            }
//            .padding(.horizontal)
//
//            // 🗺️ Map
//            GeometryReader { geo in
//                ZStack {
//                    Image("building_floor\(selectedFloor)")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: geo.size.width, height: geo.size.height)
//                        .scaleEffect(currentScale * pinchScale, anchor: .topLeading)
//                        .offset(
//                            x: currentOffset.width + dragOffset.width,
//                            y: currentOffset.height + dragOffset.height
//                        )
//                        .onAppear { mapSize = geo.size }
//                        .onChange(of: selectedFloor) { _ in
//                            mapSize = geo.size
//
//                            // 🧠 Only zoom if search triggered this floor change
//                            if isSearchTriggered, let zone = zoomTarget {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                                    zoomTo(zone: zone)
//                                    zoomTarget = nil
//                                    isSearchTriggered = false
//                                }
//                            }
//                        }
//                        .gesture(
//                            MagnificationGesture()
//                                .updating($pinchScale) { value, state, _ in state = value }
//                                .onEnded { value in
//                                    currentScale = min(max(currentScale * value, 1), 4)
//                                }
//                        )
//                        .simultaneousGesture(
//                            DragGesture()
//                                .updating($dragOffset) { value, state, _ in
//                                    state = value.translation
//                                }
//                                .onEnded { value in
//                                    currentOffset.width += value.translation.width
//                                    currentOffset.height += value.translation.height
//                                }
//                        )
//
//                    if let zone = selectedZone, zone.floor == selectedFloor {
//                        Rectangle()
//                            .stroke(Color.green, lineWidth: 3)
//                            .frame(
//                                width: zone.rect.width * mapSize.width * currentScale,
//                                height: zone.rect.height * mapSize.height * currentScale
//                            )
//                            .position(
//                                x: (zone.rect.midX * mapSize.width) * currentScale + currentOffset.width,
//                                y: (zone.rect.midY * mapSize.height) * currentScale + currentOffset.height
//                            )
//                    }
//                }
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//                .shadow(radius: 4)
//            }
//            .frame(minHeight: 400)
//            .padding(.horizontal)
//
//            Spacer()
//        }
//    }
//
//    // ✅ Manual floor switch logic
//    private func handleManualFloorSwitch(_ floor: Int) {
//        zoomTarget = nil
//        isSearchTriggered = false
//        selectedZone = nil
//        currentScale = 1.0
//        currentOffset = .zero
//        selectedFloor = floor
//    }
//
//    // 🔍 Zoom to selected room
//    private func zoomTo(zone: MapZone) {
//        selectedZone = zone
//        currentScale = 2.0
//
//        let scaledW = mapSize.width * currentScale
//        let scaledH = mapSize.height * currentScale
//
//        let centerX = zone.rect.midX * scaledW
//        let centerY = zone.rect.midY * scaledH
//
//        currentOffset = CGSize(
//            width: mapSize.width / 2 - centerX,
//            height: mapSize.height / 2 - centerY
//        )
//    }
//}
//
//struct IndoorMapZoneView_Previews: PreviewProvider {
//    static var previews: some View {
//        IndoorMapZoneView()
//            .previewDevice("iPhone 16 Pro")
//    }
//}
//
