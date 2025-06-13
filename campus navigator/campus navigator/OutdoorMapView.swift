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
                Button(action: { text = "" }) {
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

    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9023, longitude: 79.8612),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    @State private var searchText = ""
    @State private var selectedLocation: CampusLocation? = nil
    @State private var currentRoute: MKRoute? = nil

    private var filteredLocations: [CampusLocation] {
        searchText.isEmpty ? campusLocations
            : campusLocations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Map background
                Map(position: $cameraPosition) {
                    // Campus annotations
                    ForEach(filteredLocations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Button {
                                selectedLocation = location
                                centerMap(on: location.coordinate)
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
                    // Route overlay
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
                            Spacer()
                            MapUserLocationButton()
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                }

                // Search bar overlay
                SearchBar(text: $searchText)
                    .padding(.top, 50)
            }
            .navigationTitle("Campus Navigator")
            .navigationBarTitleDisplayMode(.inline)
            // Detail sheet
            .sheet(item: $selectedLocation) { location in
                VStack(spacing: 20) {
                    Text(location.name)
                        .font(.title2)
                        .bold()
                    Text(location.description)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Get Directions") {
                        if let userCoord = locationManager.userLocation?.coordinate {
                            calculateRoute(from: userCoord, to: location.coordinate)
                        }
                        selectedLocation = nil
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }
                .presentationDetents([.medium])
                .padding()
            }
        }
    }

    // MARK: - Helpers
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            )
        )
    }

    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking

        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    // Show and zoom to route
                    currentRoute = route
                    let boundingRegion = MKCoordinateRegion(route.polyline.boundingMapRect)
                    cameraPosition = .region(boundingRegion)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OutdoorMapView()
}
