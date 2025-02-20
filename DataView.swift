import SwiftUI
import Charts  // For SwiftUI Charts (iOS 16+)

// MARK: - LIVE Display Mode

struct CircularGauge: View {
    let value: Double  // Between 0 and 99
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background circle
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(.gray.opacity(0.2), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .frame(width: 150, height: 150)
                
                // Filled arc
                Circle()
                    .trim(from: 0, to: (CGFloat(value / 100) * 0.75))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .frame(width: 150, height: 150)
                
                // Value text
                Text("\(Int(value)) lbs")
                    .font(.system(size: 40))
                    .bold()
            }
            
            // Label under the gauge
            Text(label)
                .font(.footnote)
                .bold()
        }
    }
}

// MARK: - YEAR History Mode
    
public var yearModeView: some View {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Left Average Weight: 35")     // \(average(of: leftYearData)) lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleLeftYearData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
                
                Text("Right Average Weight: 32")        //\(average(of: rightYearData)) lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleRightYearData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
            }
        }
    }
}

// MARK: - MONTH History Mode

public var monthModeView: some View {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Left Average: 30 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleLeftMonthData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        if let stringValue = value.as(String.self),
                           let intValue = Int(stringValue), // Convert "5" to 5
                           intValue % 5 == 0 { // Show only multiples of 5
                            AxisValueLabel()
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
                
                Text("Right Average: 28 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleRightMonthData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        if let stringValue = value.as(String.self),
                           let intValue = Int(stringValue), // Convert "5" to 5
                           intValue % 5 == 0 { // Show only multiples of 5
                            AxisValueLabel()
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
            }
        }
    }
}

// MARK: - WEEK History Mode

public var weekModeView: some View {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Left Average: 18 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleLeftWeekData) { day in //leftYearData2
                    BarMark(
                        x: .value("Time", day.time),
                        y: .value("Weight", day.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
                
                Text("Right Average: 17 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleRightWeekData) { day in //leftYearData2
                    BarMark(
                        x: .value("Time", day.time),
                        y: .value("Weight", day.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
            }
        }
    }
}

// MARK: - DAY History Mode

public var dayModeView: some View {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Left Average Weight: 23 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleLeftDayData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        if let stringValue = value.as(String.self),
                           ["12am", "6am", "12pm", "6pm"].contains(stringValue) {
                            AxisValueLabel {
                                Text(stringValue)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
                
                Text("Right Average Weight: 21 lbs")
                    .font(.body)
                    .padding(.leading)
                
                Chart(SampleRightDayData) { month in //leftYearData2
                    BarMark(
                        x: .value("Time", month.time),
                        y: .value("Weight", month.weight)
                    )
                }
                .frame(height: geometry.size.height * 0.45)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks { value in
                        if let stringValue = value.as(String.self),
                           ["12am", "6am", "12pm", "6pm"].contains(stringValue) {
                            AxisValueLabel {
                                Text(stringValue)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine() // Keeps horizontal grid lines
                        AxisTick() // Keeps small tick marks
                        AxisValueLabel()
                            .font(.title2) // Increases Y-axis font size
                    }
                }
                .chartYAxisLabel("lbs ", position: .top, alignment: .topTrailing)
            }
        }
    }
}
