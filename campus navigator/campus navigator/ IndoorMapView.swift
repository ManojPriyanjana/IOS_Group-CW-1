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
        Place(name: "Student Computer Lab 117", x: 500, y: 50),
        Place(name: "Restroom", x: 100, y: 850)
    ]
    
    @State private var searchText: String = ""
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var animatePath: Bool = false
    @State private var showGrid: Bool = true
    @State private var showRuler: Bool = true
    
    let entryPoint = CGPoint(x: 500, y: 500)
    
    let pathPoints: [CGPoint] = [
        CGPoint(x: 150, y: 850),
        CGPoint(x: 150, y: 600),
        CGPoint(x: 500, y: 600),
        CGPoint(x: 500, y: 550),
        CGPoint(x: 700, y: 550)
    ]
    
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
            
            Toggle("Show Grid", isOn: $showGrid)
                .padding(.horizontal)
            Toggle("Show Ruler", isOn: $showRuler)
                .padding(.horizontal)
            
            GeometryReader { outerGeometry in
                ZStack {
                    Color(red: 208/255, green: 231/255, blue: 255/255) // 💙 Light blue background
                        .edgesIgnoringSafeArea(.all)

                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                        GeometryReader { geo in
                            let imageDisplayedSize = geo.size
                            let scaleX = imageDisplayedSize.width / imageOriginalSize.width
                            let scaleY = imageDisplayedSize.height / imageOriginalSize.height
                            
                            ZStack {
                                // Floor Image (rotated 90°)
                                Image("floor 1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .rotationEffect(.degrees(90))
                                
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
                                
                                // Path (if search triggered)
                                if animatePath {
                                    Path { path in
                                        let first = CGPoint(x: pathPoints.first!.x * scaleX, y: pathPoints.first!.y * scaleY)
                                        path.move(to: first)
                                        
                                        for point in pathPoints.dropFirst() {
                                            let scaled = CGPoint(x: point.x * scaleX, y: point.y * scaleY)
                                            path.addLine(to: scaled)
                                        }
                                    }
                                    .trim(from: 0, to: 1)
                                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, dash: [8]))
                                    .animation(.easeInOut(duration: 2), value: animatePath)
                                }
                                
                                if showGrid {
                                    GridOverlay(imageSize: imageDisplayedSize, spacing: 50)
                                }
                                
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
                                    .onEnded { _ in
                                        lastZoomScale = zoomScale
                                    }
                            )
                            .onAppear {
                                // Calculate scale to fit (90%) on smaller dimension
                                let scaleW = outerGeometry.size.width / imageOriginalSize.height
                                let scaleH = outerGeometry.size.height / imageOriginalSize.width
                                let baseScale = min(scaleW, scaleH) * 3.1
                                zoomScale = baseScale
                                lastZoomScale = baseScale
                            }
                        }
                        .frame(width: outerGeometry.size.width, height: outerGeometry.size.height)
                    }
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
            stride(from: 0, through: imageSize.width, by: spacing).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: imageSize.height))
            }
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
            Path { path in
                stride(from: 0, through: imageSize.width, by: spacing).forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: 10))
                }
            }
            .stroke(Color.green.opacity(0.7), lineWidth: 1)
            
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

// MARK: - Preview
#Preview {
    IndoorMapView()
}
