import SwiftUI
import MapKit

// MARK: - Campus Location Model
struct CampusLocation: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Campus Locations Data
let campusLocations = [
    CampusLocation(name: "Main Entrance", description: "Main gate of the university.", coordinate: CLLocationCoordinate2D(latitude: 6.9018, longitude: 79.8609)),
    CampusLocation(name: "Library", description: "Central Library open from 8 AM to 6 PM.", coordinate: CLLocationCoordinate2D(latitude: 6.9026, longitude: 79.8615)),
    CampusLocation(name: "Science Faculty", description: "Labs and lecture halls for science.", coordinate: CLLocationCoordinate2D(latitude: 6.9031, longitude: 79.8619)),
    CampusLocation(name: "Arts Faculty", description: "Departments for arts and languages.", coordinate: CLLocationCoordinate2D(latitude: 6.9029, longitude: 79.8628)),
    CampusLocation(name: "Law Faculty", description: "Faculty of Law and legal studies.", coordinate: CLLocationCoordinate2D(latitude: 6.9022, longitude: 79.8620)),
    CampusLocation(name: "Admin Building", description: "Administration and student services.", coordinate: CLLocationCoordinate2D(latitude: 6.9025, longitude: 79.8606)),
    CampusLocation(name: "Gymnasium", description: "Indoor gym and sports facilities.", coordinate: CLLocationCoordinate2D(latitude: 6.9014, longitude: 79.8602))
]

// MARK: - Custom Search Bar
struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search buildings...", text: $text)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
    }
}

// MARK: - Main Map View
struct OutdoorMapView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var locationManager = LocationManager()

    // 1) Default map region
    private let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9023, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )

    @State private var cameraPosition: MapCameraPosition
    @State private var searchText = ""
    @State private var selectedLocation: CampusLocation? = nil
    @State private var currentRoute: MKRoute? = nil

    // 2) Dummy-start selector: 0 = Current Location, 1…N = campusLocations[0…]
    @State private var startOptionIndex: Int = 0

    init() {
        _cameraPosition = State(initialValue: .region(initialRegion))
    }

    private var filteredLocations: [CampusLocation] {
        searchText.isEmpty
            ? campusLocations
            : campusLocations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    // Labels for the Menu
    private var startOptionLabels: [String] {
        ["Current Location"] + campusLocations.map(\.name)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // — Map
                Map(position: $cameraPosition) {
                    ForEach(filteredLocations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Button {
                                selectedLocation = location
                                centerMap(on: location.coordinate, span: 0.003)
                            } label: {
                                Image(systemName: "building.columns.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(6)
                                    .background(.white.opacity(0.8))
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                    }
                    if let route = currentRoute {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 4)
                    }
                }
                .mapStyle(colorScheme == .dark ? .standard(elevation: .realistic) : .standard)
                .ignoresSafeArea()
                .mapControls {
                    VStack {
                        Spacer()
                        HStack {
                            // Inline menu of all building names
                            Menu {
                                ForEach(startOptionLabels.indices, id: \.self) { idx in
                                    Button(startOptionLabels[idx]) {
                                        startOptionIndex = idx
                                    }
                                }
                            } label: {
                                Image(systemName: "list.bullet")
                                    .font(.title2)
                                    .padding(12)
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(.leading)

                            Spacer()

                            MapUserLocationButton()
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                }

                // — Search Bar + auto-zoom
                SearchBar(text: $searchText)
                    .padding(.top, 50)
                    .onChange(of: searchText) { newValue in
                        withAnimation(.easeInOut) {
                            if newValue.isEmpty {
                                cameraPosition = .region(initialRegion)
                            } else if let first = filteredLocations.first {
                                centerMap(on: first.coordinate, span: 0.002)
                            }
                        }
                    }
            }
            .navigationTitle("Campus Navigator")
            .navigationBarTitleDisplayMode(.inline)

            // Detail sheet
            .sheet(item: $selectedLocation) { location in
                VStack(spacing: 16) {
                    Text(location.name)
                        .font(.title2).bold()
                    Text(location.description)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Show which start is selected
                    Text("Start from: \(startOptionLabels[startOptionIndex])")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Get Directions
                    Button("Get Directions") {
                        // choose source safely
                        let sourceCoord: CLLocationCoordinate2D = {
                            if startOptionIndex == 0 {
                                // current location if available, otherwise fallback
                                return locationManager.userLocation?.coordinate
                                    ?? initialRegion.center
                            } else {
                                let idx = startOptionIndex - 1
                                guard campusLocations.indices.contains(idx) else {
                                    return initialRegion.center
                                }
                                return campusLocations[idx].coordinate
                            }
                        }()

                        calculateRoute(from: sourceCoord, to: location.coordinate)
                        selectedLocation = nil
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .presentationDetents([.medium])
            }
        }
    }

    // MARK: Helpers
    private func centerMap(on coordinate: CLLocationCoordinate2D, span delta: CLLocationDegrees) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            )
        )
    }

    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        req.transportType = .walking

        MKDirections(request: req).calculate { resp, _ in
            if let route = resp?.routes.first {
                DispatchQueue.main.async {
                    currentRoute = route
                    let region = MKCoordinateRegion(route.polyline.boundingMapRect)
                    cameraPosition = .region(region)
                }
            }
        }
    }
}

// MARK: Preview
#Preview {
    OutdoorMapView()
}
