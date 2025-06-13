import SwiftUI

struct ModernIndoorMapViewV2: View {
    @State private var selectedBuilding = "Building A"
    @State private var selectedFloor = 0
    @State private var zoomScale: CGFloat = 1.0
    @GestureState private var gestureZoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    let buildings = ["Building A", "Building B", "Building C"]
    let floors = ["Ground Floor", "Floor 1", "Floor 2"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Title
                Text("Indoor Map")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Building Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Building")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Menu {
                        ForEach(buildings, id: \.self) { building in
                            Button(building) {
                                selectedBuilding = building
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedBuilding)
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                // Floor Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Floor Levels")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        ForEach(floors.indices, id: \.self) { index in
                            Button(action: {
                                selectedFloor = index
                            }) {
                                Text(floors[index])
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(width: 100, height: 40)
                                    .background(selectedFloor == index ? Color.blue : Color(UIColor.systemGray5))
                                    .foregroundColor(selectedFloor == index ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                // Map Title
                Text("\(selectedBuilding) - \(floors[selectedFloor]) Map")
                    .font(.headline)

                // Geometry Reader for Dynamic Size
                GeometryReader { geo in
                    let imageName = mapImageName(for: selectedBuilding, floorIndex: selectedFloor)
                    let totalZoom = zoomScale * gestureZoom
                    let totalOffset = CGSize(
                        width: offset.width + gestureOffset.width,
                        height: offset.height + gestureOffset.height
                    )

                    ZStack(alignment: .topTrailing) {
                        if let uiImage = UIImage(named: imageName) {
                            let aspectRatio = uiImage.size.width / uiImage.size.height
                            let viewWidth = geo.size.width
                            let viewHeight = viewWidth / aspectRatio

                            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(aspectRatio, contentMode: .fit)
                                    .frame(width: viewWidth * totalZoom, height: viewHeight * totalZoom)
                                    .offset(totalOffset)
                                    .gesture(
                                        SimultaneousGesture(
                                            MagnificationGesture()
                                                .updating($gestureZoom) { value, state, _ in
                                                    state = value
                                                }
                                                .onEnded { value in
                                                    zoomScale = min(max(zoomScale * value, 1.0), 5.0)
                                                },
                                            DragGesture()
                                                .updating($gestureOffset) { value, state, _ in
                                                    state = value.translation
                                                }
                                                .onEnded { value in
                                                    offset.width += value.translation.width
                                                    offset.height += value.translation.height
                                                }
                                        )
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: totalZoom)
                            }
                            .frame(width: viewWidth, height: viewHeight)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 4)
                        } else {
                            Text("Map image not found")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, maxHeight: 420)
                        }

                        // Zoom label
                        Text("Zoom: \(Int(totalZoom * 100))%")
                            .font(.caption)
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }
                .frame(height: 450)

                Spacer()
            }
            .padding()
            .onChange(of: selectedBuilding) { _ in resetZoomAndPan() }
            .onChange(of: selectedFloor) { _ in resetZoomAndPan() }
        }
    }

    
    func mapImageName(for building: String, floorIndex: Int) -> String {
        let floorKey = ["ground", "floor1", "floor2"]
        let buildingKey = building.lowercased().replacingOccurrences(of: " ", with: "_")
        return "\(buildingKey)_\(floorKey[floorIndex])"
    }

    func resetZoomAndPan() {
        zoomScale = 1.0
        offset = .zero
    }
}

#Preview {
    ModernIndoorMapViewV2()
}
