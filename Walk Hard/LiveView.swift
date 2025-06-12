// LiveView.swift
// Shows two gauges with current weight applied on the handles

import SwiftUI

struct LiveView: View {
    
  // MARK: - Variables
  @ObservedObject var bluetoothView: BluetoothView
  @State private var lastReceivedMessage: String = "99"
  @State private var secondToLastMessage: String = "99"
  @State private var messageUpdateCounter = 0

  // MARK: - Bluetooth Handling
  var body: some View {
    VStack(spacing: 0) {
      Text(bluetoothView.connectedPeripheralName ?? "SMARTHANDLE")
        .font(.headline)
        .padding(.top, 8)
      Spacer(minLength: 16)
      LiveModeView(bluetoothView: bluetoothView)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onReceive(bluetoothView.$receivedMessages) { messages in
      messageUpdateCounter += 1
      guard messageUpdateCounter % 2 == 1, let last = messages.last else { return }
      lastReceivedMessage = "\(last)"
      secondToLastMessage = messages.count >= 2
        ? "\(messages[messages.count - 2])"
        : ""
    }
    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
    }
  }
}


// MARK: - Live View (two gauges)
struct LiveModeView: View {
  @ObservedObject var bluetoothView: BluetoothView

  var body: some View {
    HStack(spacing: 40) {
      Spacer()
      CircularGauge(value: Double(bluetoothView.leftHandleWeight), label: "Left Handle")
      CircularGauge(value: Double(bluetoothView.rightHandleWeight), label: "Right Handle")
      Spacer()
    }
    .onReceive(bluetoothView.$leftHandleWeight) { _ in
      print("Updated Left Handle Weight: \(bluetoothView.leftHandleWeight) kgsss")
    }
    .onReceive(bluetoothView.$rightHandleWeight) { _ in
      print("Updated Right Handle Weight: \(bluetoothView.rightHandleWeight) lbs")
    }
  }
}


// MARK: - Circular Gauge
struct CircularGauge: View {
    let value: Double
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(.gray.opacity(0.2), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0, to: (CGFloat(value / 100) * 0.75))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .frame(width: 150, height: 150)

                Text("\(Int(value)) lbs")
                    .font(.system(size: 40))
                    .bold()
            }

            Text(label)
                .font(.footnote)
                .bold()
        }
    }
}
