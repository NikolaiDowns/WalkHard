import SwiftUI
import CoreBluetooth
import Charts  // For SwiftUI Charts (iOS 16+)



// MARK: - ContentView Struct

struct ContentView: View {
    @ObservedObject var bluetooth = BluetoothView()
    
    // Local state for connection (mirrors bluetooth.isConnected)
    @State private var isConnected = true
    
    // States for incoming messages (live sensor reading)
    @State private var lastReceivedMessage: String = "31"
    @State private var secondToLastMessage: String = "34"
    @State private var messageUpdateCounter = 0
    
    // UI Mode: Live or History
    @State private var currentMode: Mode = .live
    @State private var selectedTab = 1
    private let tabCount = 6
    
    @State private var brightness: CGFloat = 0.5
    @State private var volume: CGFloat = 0.5
    
    
    private func average(of data: [Int]) -> Int {
        let nonZeroValues = data.filter { $0 > 0 }
        guard !nonZeroValues.isEmpty else { return 0 }
        let sum = nonZeroValues.reduce(0, +)
        return sum / nonZeroValues.count
    }
    
    var body: some View {
        NavigationView {
            if isConnected {
                VStack(spacing: 0) { // Ensures the toolbar stays at the bottom
                            // Main Content with Swipe Gesture
                            TabView(selection: $selectedTab) {
                                liveView.tag(1)
                                dayView.tag(2)
                                weekView.tag(3)
                                monthView.tag(4)
                                yearView.tag(5)
                                HapticSettingsView().tag(6)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Smooth swipe behavior

                            // Custom Static Toolbar
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
                            }
                            .padding(.vertical, 30)
                            .background(Color(UIColor.systemBackground).opacity(0.95)) // Matches system color
                            .shadow(radius: 5) // Adds slight shadow for better UI
                        }
                        .edgesIgnoringSafeArea(.bottom) // Ensures toolbar looks natural
                
            } else {
                // ======================
                // Device Selection List
                // ======================
                GeometryReader { geometry in
                    VStack {
                        List(bluetooth.peripheralNames, id: \.self) { peripheralName in
                            Button(action: {
                                bluetooth.connectToPeripheral(named: peripheralName)
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
                        
                        //Spacer()
                        
                        Button(action: {
                            // Set variables here
                            isConnected = true
                            // Example of other variables you might set:
                            //                            someOtherVariable = "Connected"
                            //                            anotherVariable = 42
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                Text("Preview Mode")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity) // Make the button stretch horizontally if needed
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal) // Add horizontal padding for the button
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.2)
                    }
                }
            }
        }
        // Keep local state synced with the BluetoothView's isConnected
        .onReceive(bluetooth.$isConnected) { connected in
            self.isConnected = connected
        }
    }

// Custom tab button
    private func tabButton(image: String, selectedImage: String, tab: Int) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(systemName: selectedTab == tab ? selectedImage : image)
                .font(.largeTitle)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
        }
    }
    
    // MARK: - Middle Page View
    // UPDATED: This entire container ensures the Picker is in the same vertical position
    private var liveView: some View {
        VStack(spacing: 0) {
            
            // Title (e.g. “SMART-HANDLE6”)
            Text(bluetooth.connectedPeripheralName ?? "SMARTHANDLE")
                .font(.headline)
                .padding(.top, 8)
            
            // A little spacer after the title
            Spacer(minLength: 16)
            
            // MAIN CONTENT
            liveModeView
            
            Spacer()
            
            
            // Bottom toolbar
            //bottomToolbar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Update sensor readings on new messages
        .onReceive(bluetooth.$receivedMessages) { messages in
            messageUpdateCounter += 1
            // Only update display on every odd message
            if messageUpdateCounter % 2 == 1 {
                if let lastMessage = messages.last {
                    self.lastReceivedMessage = lastMessage
                    if messages.count >= 2 {
                        self.secondToLastMessage = messages[messages.count - 2]
                    } else {
                        self.secondToLastMessage = ""
                    }
                }
            }
        }
    }
    
    
    // MARK: - Live Mode
    // UPDATED: Removed extra vertical padding so it aligns with the new layout
    private var liveModeView: some View {
            HStack(spacing: 40) {
                
                Spacer()
                // Left handle gauge
                CircularGauge(value: parseReading(lastReceivedMessage),
                              label: "Left Handle")
                // Right handle gauge
                CircularGauge(value: parseReading(secondToLastMessage),
                              label: "Right Handle")
                Spacer()
            }
    }
    
    
    // MARK: - Bottom Toolbar (Haptics, Connection, Settings)
    private var bottomToolbar: some View {
        HStack {
            
            Spacer()
            Spacer()
            
            Button {
                // Haptics logic
            } label: {
                Image(systemName: "gauge.with.needle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button {
                // Some Bluetooth or handle logic
            } label: {
                Image(systemName: "sun.max.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "circle.hexagongrid.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "calendar.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "folder.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "gearshape.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    /// Attempt to parse the reading as a Double, clamping to [0..100]
    private func parseReading(_ str: String) -> Double {
        if let val = Double(str) {
            return min(max(val, 0), 100)
        }
        return 0
    }
    
}

// MARK: - Mode Enum

enum Mode {
    case live
    case day
    case week
    case month
    case year
}


// MARK: - Preview

#Preview {
    ContentView()
}
