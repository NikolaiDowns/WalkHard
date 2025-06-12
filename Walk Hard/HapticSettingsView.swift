// HapticSettingsView.swift

// Responsible for allowing changes in haptic feedback
// Displays battery life of handles

// TODO: Improve display. Doesn't look professional


import SwiftUI

struct HapticSettingsView: View {
    @State private var thresholdLeft: CGFloat = 0.5
    @State private var thresholdRight: CGFloat = 0.5
    @State private var vibrationLeft: CGFloat = 0.5
    @State private var vibrationRight: CGFloat = 0.5

    @ObservedObject var bluetoothView: BluetoothView
    @State private var isScreenOne: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Title
                Spacer(minLength: 30)

                // **Battery Indicator** (LIVE updating)
                BatteryIndicatorView(bluetoothView: bluetoothView)

                Spacer(minLength: 110)
                
                Text("Haptic Settings")
                    .font(.largeTitle)
                    .padding(.top, 8)

                if isScreenOne {
                    // **Separate Left and Right Sliders**
                    HStack(spacing: 30) {
                        HStack(spacing: 15) {
                            // Left Handle Sliders
                            CustomSlider(value: $thresholdLeft,
                                         icon: "music.note.list",
                                         color: Color.blue,
                                         range: 0...100,
                                         label: "Left Weight")
                            { newValue in
                                let thresholdInt = Int(newValue)
                                bluetoothView.sendThreshold(leftValue: thresholdInt, rightValue: Int(thresholdRight))
                            }
                            
                            CustomSlider(value: $vibrationLeft,
                                         icon: "phone.down.waves.left.and.right",
                                         color: Color.blue,
                                         range: 0...10,
                                         label: "Left Strength")
                            { newValue in
                                let vibrationInt = Int(newValue)
                                bluetoothView.sendVibration(leftValue: vibrationInt, rightValue: Int(vibrationRight))
                            }
                        }
                        
                        HStack(spacing: 15) {
                            // Right Handle Sliders
                            CustomSlider(value: $thresholdRight,
                                         icon: "music.note.list",
                                         color: Color.blue,
                                         range: 0...100,
                                         label: "Right Weight")
                            { newValue in
                                let thresholdInt = Int(newValue)
                                bluetoothView.sendThreshold(leftValue: Int(thresholdLeft), rightValue: thresholdInt)
                            }
                            
                            CustomSlider(value: $vibrationRight,
                                         icon: "phone.down.waves.left.and.right",
                                         color: Color.blue,
                                         range: 0...10,
                                         label: "Right Strength")
                            { newValue in
                                let vibrationInt = Int(newValue)
                                bluetoothView.sendVibration(leftValue: Int(vibrationLeft), rightValue: vibrationInt)
                            }
                        }
                    }
                    .padding()
                } else {
                    // **Same Value for Both Handles**
                    HStack(spacing: 60) {
                        CustomSliderBig(value: $thresholdLeft,
                                     icon: "music.note.list",
                                     color: Color.blue,
                                     range: 0...100,
                                     label: "Weight")
                        { newValue in
                            let thresholdInt = Int(newValue)
                            bluetoothView.sendThreshold(leftValue: thresholdInt, rightValue: thresholdInt)
                        }
                        
                        CustomSliderBig(value: $vibrationLeft,
                                     icon: "phone.down.waves.left.and.right",
                                     color: Color.blue,
                                     range: 0...10,
                                     label: "Strength")
                        { newValue in
                            let vibrationInt = Int(newValue)
                            bluetoothView.sendVibration(leftValue: vibrationInt, rightValue: vibrationInt)
                        }
                    }
                    .padding()
                }
                
                Text("Set Handles")
                    .font(.system(size: 15))
                
                Button(action: {
                    isScreenOne.toggle()
                }) {
                    Text(isScreenOne ? "Separately" : "Together")
                        .font(.system(size: 25))
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(22)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 30)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Custom Slider
struct CustomSlider: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var value: CGFloat
    let icon: String
    let color: Color
    let range: ClosedRange<CGFloat>
    let label: String
    var onValueChangeEnded: ((CGFloat) -> Void)?
    var body: some View {
        VStack(spacing: 8) {
            Text("\(Int(value))")
                .font(.headline)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 80, height: 300)
                    .shadow(color: Color.gray, radius: 4)
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(colorScheme == .light ? Color.white.opacity(1) : Color.white.opacity(0.9))
                    .frame(width: 80, height: (300 * ((value + (0.2 * range.upperBound)) / (1.2 * range.upperBound))))
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 24))
                    .padding(.bottom, 12)
            }
            .frame(width: 80, height: 300)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let normalizedValue = max(0, min(1, 1 - (gesture.location.y / 300)))
                        value = range.lowerBound + (normalizedValue * (range.upperBound - range.lowerBound))
                    }
                    .onEnded { _ in
                        onValueChangeEnded?(value)
                    }
            )
            
            Text(label)
                .font(.system(size: 20)) //caption
        }
    }
}
// MARK: - Custom Slider Big
struct CustomSliderBig: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var value: CGFloat
    let icon: String
    let color: Color
    let range: ClosedRange<CGFloat>
    let label: String
    var onValueChangeEnded: ((CGFloat) -> Void)?
    var body: some View {
        VStack(spacing: 8) {
            Text("\(Int(value))")
                .font(.headline)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 130, height: 300)
                    .shadow(color: Color.gray, radius: 5)
                
                RoundedRectangle(cornerRadius: 45)
                    .fill(colorScheme == .light ? Color.white.opacity(1) : Color.white.opacity(0.9))
                    .frame(width: 130, height: (300 * ((value + (0.34 * range.upperBound)) / (1.34 * range.upperBound))))
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 24))
                    .padding(.bottom, 24)
            }
            .frame(width: 140, height: 300)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let normalizedValue = max(0, min(1, 1 - (gesture.location.y / 300)))
                        value = range.lowerBound + (normalizedValue * (range.upperBound - range.lowerBound))
                    }
                    .onEnded { _ in
                        onValueChangeEnded?(value)
                    }
            )
            
            Text(label)
                .font(.caption)
        }
    }
}



