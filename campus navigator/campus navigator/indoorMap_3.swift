import SwiftUI

struct IndoorMapView3: View {
    @State private var searchText: String = ""
    @State private var selectedFloor: Int = 1

    var body: some View {
        VStack(spacing: 24) {

            // App Title
            Text("Building A Navigator")
                .font(.system(size: 24, weight: .bold))

            // Search bar + button
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search locations (e.g., iOS Lab, 365)", text: $searchText)
                        .autocapitalization(.none)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                Button("Search") {
                    // your search action
                }
                .fontWeight(.semibold)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            // Floor selector
            Picker("", selection: $selectedFloor) {
                Text("Floor 1").tag(1)
                Text("Floor 2").tag(2)
                Text("Floor 3").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // Zoomable / Pannable Map Card
            ZoomableFloorPlanCard(
                floor: selectedFloor,
                elevatorPosition: CGPoint(x: 0.8, y: 0.2)
            )
            .frame(maxWidth: .infinity, minHeight: 400)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }
}

struct ZoomableFloorPlanCard: View {
    let floor: Int
    let elevatorPosition: CGPoint

    // accumulated scale & offset
    @State private var currentScale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero

    // in-flight gesture state
    @GestureState private var pinchScale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    Image("building_floor\(floor)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                    Image(systemName: "tram.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .position(
                            x: elevatorPosition.x * geo.size.width,
                            y: elevatorPosition.y * geo.size.height
                        )
                }
                // apply zoom & pan **inside** the fixed-size GeometryReader
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(currentScale * pinchScale)
                .offset(
                    x: currentOffset.width + dragOffset.width,
                    y: currentOffset.height + dragOffset.height
                )
            }
        }
        // fix the overall card shape + size
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // limit gestures to this rounded‐rect hit area
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        // pinch to zoom
        .gesture(
            MagnificationGesture()
                .updating($pinchScale) { latest, pinchScale, _ in
                    pinchScale = latest
                }
                .onEnded { final in
                    let newScale = currentScale * final
                    // clamp between 1× and 4×
                    currentScale = min(max(newScale, 1.0), 4.0)
                }
        )
        // drag to pan
        .simultaneousGesture(
            DragGesture()
                .updating($dragOffset) { latest, drag, _ in
                    drag = latest.translation
                }
                .onEnded { final in
                    currentOffset.width += final.translation.width
                    currentOffset.height += final.translation.height
                }
        )
    }
}

struct IndoorMapView_Previews: PreviewProvider {
    static var previews: some View {
        IndoorMapView3()
            .previewDevice("iPhone 16 Pro")
    }
}
