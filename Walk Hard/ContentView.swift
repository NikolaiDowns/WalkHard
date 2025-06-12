// ContentView.swift

// MARK: - README

// Main File

// Determines whether user should see home screen or BT connection screen
// Includes code for BT connection screen, toolbar, and swiping between pages
// Does NOT include any content on the individual pages themselves (gauges, graphs, sliders, login)
// Those can be found in LiveView.swift, DataView.swift, HapticSettingsView.swift, and SignInView.swift, respectively


import SwiftUI
import CoreBluetooth


// MARK: - ContentView
struct ContentView: View {
    
    // MARK: - Variabels
    
    // Display Conection Screen or Home Screen
    @State private var isConnected = true
    
    // Home Screen Tabs
    @State private var selectedTab = 1
    private let tabCount = 7
    
    @StateObject var bluetoothView = BluetoothView()
    
    
    var body: some View {
        NavigationView {
            if isConnected {

                // MARK: Home Screen
                VStack(spacing: 0) { // Ensures the toolbar stays at the bottom
                    
                    
                    // MARK: - Tabs
                    // Main Content with Swipe Gesture
                    TabView(selection: $selectedTab) {
                        LiveView(bluetoothView: bluetoothView)
                                .tag(1)
                        dayModeView(bluetoothView: bluetoothView).tag(2)
                        weekModeView().tag(3)
                        monthModeView().tag(4)
                        yearModeView().tag(5)
                        HapticSettingsView(bluetoothView: bluetoothView).tag(6)
                        SignInView().tag(7)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Smooth swipe behavior
                    
                    // // MARK: - Toolbar
                    HStack {
                        Spacer()
                        tabButton(image: "gauge.with.needle", selectedImage: "gauge.with.needle.fill", tab: 1)
                        Spacer()
                        tabButton(image: "sun.max.circle", selectedImage: "sun.max.circle.fill", tab: 2)
                        Spacer()
                        tabButton(image: "circle.hexagongrid.circle", selectedImage: "circle.hexagongrid.circle.fill", tab: 3)
                        Spacer()
                        tabButton(image: "calendar.circle", selectedImage: "calendar.circle.fill", tab: 4)
                        Spacer()
                        tabButton(image: "folder.circle", selectedImage: "folder.circle.fill", tab: 5)
                        Spacer()
                        tabButton(image: "gearshape.circle", selectedImage: "gearshape.circle.fill", tab: 6)
                        Spacer()
                        tabButton(image: "person.circle", selectedImage: "person.circle.fill", tab: 7)
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    .background(Color(UIColor.systemBackground).opacity(0.95)) // Matches system color
                }
                .edgesIgnoringSafeArea(.bottom) // Ensures toolbar looks natural
                
                
                
                
            } else { // MARK: BT Connection Screen
                
                GeometryReader { geometry in
                    VStack {
                        List(bluetoothView.peripheralNames, id: \.self) { peripheralName in
                            Button(action: {
                                bluetoothView.connectToPeripheral(named: peripheralName)
                            }) {
                                HStack {
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                        .foregroundColor(.blue)
                                    Text(peripheralName)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Select a Device")
                        
                        
                        // MARK: - Preview Mode Button
                        Button(action: {
                            // Set variables here
                            isConnected = true
                        }) {
                            // Button Visuals
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                Text("Preview Mode")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.2)
                    }
                }
            }
        }
        // Keep local state synced with the BluetoothView's isConnected
        .onReceive(bluetoothView.$isConnected) { connected in
            self.isConnected = connected
        }
    }
    
    // MARK: - Tab Button()
    // Custom tab button for toolbar
    private func tabButton(image: String, selectedImage: String, tab: Int) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(systemName: selectedTab == tab ? selectedImage : image)
                .font(.largeTitle)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
        }
    }
    
}

// MARK: - Preview
#Preview {
    ContentView()
}
