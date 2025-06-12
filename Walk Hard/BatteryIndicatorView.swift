// BatteryIndicatorView.swift
// Used to display handle battery levels
// Currently being used by HapticSettingsView

import SwiftUI
struct BatteryIndicatorView: View {
    @ObservedObject var bluetoothView: BluetoothView  // Observe BluetoothView
    var body: some View {
        HStack(spacing: 25) {
            VStack {
                BatterySymbol(batteryPercentage: bluetoothView.batteryPercentageLeft)
                Text("Left")
            }
            VStack {
                BatterySymbol(batteryPercentage: bluetoothView.batteryPercentageRight)
                Text("Right")
            }
        }
        .padding()
    }
}
struct BatterySymbol: View {
    var batteryPercentage: Int
    // Selects the appropriate battery SF Symbol based on percentage
    var batteryImageName: String {
        switch batteryPercentage {
        case 0..<9:
            return "battery.0"
        case 9..<38:
            return "battery.25"
        case 38..<63:
            return "battery.50"
        case 63..<88:
            return "battery.75"
        default:
            return "battery.100"
        }
    }
    
    // Change color based on battery level
    var batteryColor: Color {
        batteryPercentage < 20 ? .red : .blue
    }
    
    var body: some View {
        ZStack {
            // The battery icon
            Image(systemName: batteryImageName)
                .font(.system(size: 35))
                .foregroundColor(batteryColor)
            
            // The battery percentage text
            Text("\(batteryPercentage)%")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

