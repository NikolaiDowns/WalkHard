// DataView.swift

// MARK: - README
// This file contains all the bar chart views and live mode
//
// All bar charts are hard coded with sample data.
// TO DO: In the middle of getting DayView to work with storage (to actually pull from handle).
//        Once that works, make week, month, and year work the same way.

// If you make a style change just repeat the edits on one to them all.
//
// TO DO: Combine all the types of charts into a simple structure.
//        This could eventually be used to let people customize which bar charts they want to see.


import SwiftUI
import Charts // For SwiftUI Charts (iOS 16+)

// MARK: - Day View
func dayModeView(bluetoothView: BluetoothView) -> some View {
    VStack(spacing: 0) {
        Text("Today's Walker Usage")
            .font(.headline)
            .padding(.top, 8)

        Spacer(minLength: 16)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Left Average Weight: \(averageWeight(bluetoothView.logEntries.map { $0.leftWeight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(bluetoothView.logEntries, id: \ .id) { entry in
                        BarMark(
                            x: .value("Time", entry.timestamp.formatted(.dateTime.hour().minute())),
                            y: .value("Left Weight", entry.leftWeight)
                        )
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)

                    Text("Right Average Weight: \(averageWeight(bluetoothView.logEntries.map { $0.rightWeight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(bluetoothView.logEntries, id: \ .id) { entry in
                        BarMark(
                            x: .value("Time", entry.timestamp.formatted(.dateTime.hour().minute())),
                            y: .value("Right Weight", entry.rightWeight)
                        )
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Week View
func weekModeView() -> some View {
    VStack(spacing: 0) {
        Text("This Week's Walker Usage")
            .font(.headline)
            .padding(.top, 8)

        Spacer(minLength: 16)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Left Average: \(averageWeight(SampleLeftWeekData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleLeftWeekData, id: \ .id) { day in
                        BarMark(x: .value("Time", day.time), y: .value("Weight", day.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)

                    Text("Right Average: \(averageWeight(SampleRightWeekData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleRightWeekData, id: \ .id) { day in
                        BarMark(x: .value("Time", day.time), y: .value("Weight", day.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Month View
func monthModeView() -> some View {
    VStack(spacing: 0) {
        Text("This Month's Walker Usage")
            .font(.headline)
            .padding(.top, 8)

        Spacer(minLength: 16)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Left Average: \(averageWeight(SampleLeftMonthData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleLeftMonthData, id: \ .id) { day in
                        BarMark(x: .value("Time", day.time), y: .value("Weight", day.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)

                    Text("Right Average: \(averageWeight(SampleRightMonthData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleRightMonthData, id: \ .id) { day in
                        BarMark(x: .value("Time", day.time), y: .value("Weight", day.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Year View
func yearModeView() -> some View {
    VStack(spacing: 0) {
        Text("This Year's Walker Usage")
            .font(.headline)
            .padding(.top, 8)

        Spacer(minLength: 16)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Left Average: \(averageWeight(SampleLeftYearData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleLeftYearData, id: \ .id) { month in
                        BarMark(x: .value("Time", month.time), y: .value("Weight", month.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)

                    Text("Right Average: \(averageWeight(SampleRightYearData.map { $0.weight })) lbs")
                        .font(.body)
                        .padding(.leading)

                    Chart(SampleRightYearData, id: \ .id) { month in
                        BarMark(x: .value("Time", month.time), y: .value("Weight", month.weight))
                    }
                    .frame(height: geometry.size.height * 0.45)
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Bar Data Structures
struct WeightEntry: Identifiable {
    let id = UUID()
    let time: String
    let weight: Double
}

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let leftWeight: Double
    let rightWeight: Double
}

// Helper Function
func averageWeight(_ weights: [Double]) -> Int {
    let nonZero = weights.filter { $0 > 0 }
    guard !nonZero.isEmpty else { return 0 }
    return Int(nonZero.reduce(0, +) / Double(nonZero.count))
}

// MARK: - Sample Data (pretty)
let SampleLeftWeekData: [WeightEntry] = [
    WeightEntry(time: "Mon", weight: 18),
    WeightEntry(time: "Tue", weight: 20),
    WeightEntry(time: "Wed", weight: 17),
    WeightEntry(time: "Thu", weight: 16),
    WeightEntry(time: "Fri", weight: 19),
    WeightEntry(time: "Sat", weight: 21),
    WeightEntry(time: "Sun", weight: 20)
]

let SampleRightWeekData: [WeightEntry] = [
    WeightEntry(time: "Mon", weight: 17),
    WeightEntry(time: "Tue", weight: 18),
    WeightEntry(time: "Wed", weight: 16),
    WeightEntry(time: "Thu", weight: 15),
    WeightEntry(time: "Fri", weight: 18),
    WeightEntry(time: "Sat", weight: 19),
    WeightEntry(time: "Sun", weight: 20)
]

let SampleLeftMonthData: [WeightEntry] = (1...30).map {
    WeightEntry(time: "\($0)", weight: Double.random(in: 25...35))
}

let SampleRightMonthData: [WeightEntry] = (1...30).map {
    WeightEntry(time: "\($0)", weight: Double.random(in: 23...33))
}

let SampleLeftYearData: [WeightEntry] = [
    WeightEntry(time: "Jan", weight: 34),
    WeightEntry(time: "Feb", weight: 36),
    WeightEntry(time: "Mar", weight: 35),
    WeightEntry(time: "Apr", weight: 33),
    WeightEntry(time: "May", weight: 36),
    WeightEntry(time: "Jun", weight: 34),
    WeightEntry(time: "Jul", weight: 35),
    WeightEntry(time: "Aug", weight: 36),
    WeightEntry(time: "Sep", weight: 34),
    WeightEntry(time: "Oct", weight: 33),
    WeightEntry(time: "Nov", weight: 35),
    WeightEntry(time: "Dec", weight: 34)
]

let SampleRightYearData: [WeightEntry] = [
    WeightEntry(time: "Jan", weight: 32),
    WeightEntry(time: "Feb", weight: 31),
    WeightEntry(time: "Mar", weight: 33),
    WeightEntry(time: "Apr", weight: 30),
    WeightEntry(time: "May", weight: 31),
    WeightEntry(time: "Jun", weight: 30),
    WeightEntry(time: "Jul", weight: 32),
    WeightEntry(time: "Aug", weight: 33),
    WeightEntry(time: "Sep", weight: 31),
    WeightEntry(time: "Oct", weight: 30),
    WeightEntry(time: "Nov", weight: 32),
    WeightEntry(time: "Dec", weight: 31)
]

let SampleLogEntries: [LogEntry] = [
    LogEntry(timestamp: Date().addingTimeInterval(-3600 * 6), leftWeight: 22, rightWeight: 21),
    LogEntry(timestamp: Date().addingTimeInterval(-3600 * 4), leftWeight: 24, rightWeight: 22),
    LogEntry(timestamp: Date().addingTimeInterval(-3600 * 2), leftWeight: 25, rightWeight: 23),
    LogEntry(timestamp: Date(), leftWeight: 23, rightWeight: 21)
]
