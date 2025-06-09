import SwiftUI

// MARK: - Place Model
struct Place: Identifiable {
    let id = UUID()
    let name: String
    let x: CGFloat
    let y: CGFloat
}

// MARK: - IndoorMapView
struct IndoorMapView: View {
    
    let places = [
        Place(name: "Student Computer Lab 117", x: 450, y: 360),
        Place(name: "Restroom", x: 100, y: 850)
    ]
    
    @State private var searchText: String = ""
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var animatePath: Bool = false
    @State private var showGrid: Bool = true  // Grid ON/OFF
    @State private var showRuler: Bool = true // Ruler ON/OFF
    
    // Entry + path points
    let entryPoint = CGPoint(x: 500, y: 500)
    
    let pathPoints: [CGPoint] = [
        CGPoint(x: 150, y: 850),
        CGPoint(x: 150, y: 600),
        CGPoint(x: 500, y: 600),
        CGPoint(x: 500, y: 550),
        CGPoint(x: 700, y: 550)
    ]
    
    // Image size — check your real image size!
    let imageOriginalSize = CGSize(width: 993, height: 768)
    
    var body: some View {
        VStack {
            
            // Search Bar
            TextField("Search places...", text: $searchText, onCommit: {
                if searchText.lowercased().contains("117") || searchText.lowercased().contains("student computer lab") {
                    animatePath = true
                } else {
                    animatePath = false
                }
            })
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Toggle Grid
            Toggle("Show Grid", isOn: $showGrid)
                .padding(.horizontal)
            
            // Toggle Ruler
            Toggle("Show Ruler", isOn: $showRuler)
                .padding(.horizontal)
            
            // Map with zoom + pan
            GeometryReader { outerGeometry in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    GeometryReader { geo in
                        let imageDisplayedSize = geo.size
                        let scaleX = imageDisplayedSize.width / imageOriginalSize.width
                        let scaleY = imageDisplayedSize.height / imageOriginalSize.height
                        
                        ZStack {
                            // Floor Map
                            Image("floor 1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            // Places
                            ForEach(places) { place in
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 20, height: 20)
                                    .position(
                                        x: place.x * scaleX,
                                        y: place.y * scaleY
                                    )
                                    .overlay(
                                        Text(place.name.prefix(1))
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    )
                            }
                            
                            // Animated path if search matches
                            if animatePath {
                                Path { path in
                                    let scaledFirst = CGPoint(x: pathPoints.first!.x * scaleX, y: pathPoints.first!.y * scaleY)
                                    path.move(to: scaledFirst)
                                    
                                    for point in pathPoints.dropFirst() {
                                        let scaledPoint = CGPoint(x: point.x * scaleX, y: point.y * scaleY)
                                        path.addLine(to: scaledPoint)
                                    }
                                }
                                .trim(from: 0, to: animatePath ? 1 : 0)
                                .stroke(Color.orange, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, dash: [8]))
                                .animation(.easeInOut(duration: 2), value: animatePath)
                            }
                            
                            // Grid overlay
                            if showGrid {
                                GridOverlay(imageSize: imageDisplayedSize, spacing: 50)
                            }
                            
                            // Ruler overlay
                            if showRuler {
                                RulerOverlay(imageSize: imageDisplayedSize, spacing: 50)
                            }
                        }
                        .scaleEffect(zoomScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    zoomScale = lastZoomScale * value
                                }
                                .onEnded { value in
                                    lastZoomScale = zoomScale
                                }
                        )
                    }
                    .frame(
                        width: outerGeometry.size.width,
                        height: outerGeometry.size.height
                    )
                }
            }
            .navigationTitle("Indoor Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Grid Overlay
struct GridOverlay: View {
    let imageSize: CGSize
    let spacing: CGFloat
    
    var body: some View {
        Path { path in
            // Vertical lines
            stride(from: 0, through: imageSize.width, by: spacing).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: imageSize.height))
            }
            
            // Horizontal lines
            stride(from: 0, through: imageSize.height, by: spacing).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: imageSize.width, y: y))
            }
        }
        .stroke(Color.red.opacity(0.5), lineWidth: 1)
    }
}

// MARK: - Ruler Overlay
struct RulerOverlay: View {
    let imageSize: CGSize
    let spacing: CGFloat
    
    var body: some View {
        ZStack {
            // Horizontal ruler (top)
            Path { path in
                stride(from: 0, through: imageSize.width, by: spacing).forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: 10))
                }
            }
            .stroke(Color.green.opacity(0.7), lineWidth: 1)
            
            // Vertical ruler (left)
            Path { path in
                stride(from: 0, through: imageSize.height, by: spacing).forEach { y in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: 10, y: y))
                }
            }
            .stroke(Color.green.opacity(0.7), lineWidth: 1)
        }
        
    
    }
       
}

#Preview {
    IndoorMapView()
}
