// Bluetooth.swift
// responsible for providing BT helper functions

import SwiftUI
import CoreBluetooth

class BluetoothView: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    private var selectedPeripheral: CBPeripheral?
    
    @Published var peripheralNames: [String] = []
    @Published var receivedMessages: [String] = [] // Store received messages
    @Published var isConnected: Bool = false // Track connection status
    @Published var connectedPeripheralName: String? = nil // Name of connected peripheral
    
    @Published var batteryVoltageLeft: Double = 0.0
    @Published var batteryVoltageRight: Double = 0.0
    @Published var batteryPercentageLeft: Int = 0
    @Published var batteryPercentageRight: Int = 0
    @Published var leftHandleWeight: Int = 0
    @Published var rightHandleWeight: Int = 0
    @Published var logEntries: [LogEntry] = []

    private var peripheralMap: [String: CBPeripheral] = [:]

    // Characteristic References
    public var leftHandleCharacteristic: CBCharacteristic?
    public var rightHandleCharacteristic: CBCharacteristic?
    public var thresholdCharacteristic: CBCharacteristic?
    public var vibrationCharacteristic: CBCharacteristic?
    public var batteryCharacteristic: CBCharacteristic?
    public var timeCharacteristic: CBCharacteristic?
    public var logDataCharacteristic: CBCharacteristic?
 
    private var characteristicsReady = false
    
    struct LogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let leftWeight: Double
        let rightWeight: Double
    }

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - CBCentralManagerDelegate Methods

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is on")
            self.centralManager?.scanForPeripherals(withServices: nil,
                                                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        case .poweredOff, .resetting, .unauthorized, .unsupported, .unknown:
            print("Bluetooth state changed: \(central.state.rawValue)")
            resetConnection()
        @unknown default:
            print("Unhandled Bluetooth state")
            resetConnection()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? "Unknown Device"
        
        guard deviceName != "Unknown Device" else { return }

        if !peripheralMap.keys.contains(deviceName) {
            peripherals.append(peripheral)
            peripheralNames.append(deviceName)
            peripheralMap[deviceName] = peripheral
            print("Discovered peripheral: \(deviceName)")
        }
    }

    func connectToPeripheral(named peripheralName: String) {
        guard let peripheral = peripheralMap[peripheralName] else {
            print("Peripheral \(peripheralName) not found")
            return
        }
        print("Connecting to peripheral: \(peripheralName)")
        self.selectedPeripheral = peripheral
        self.selectedPeripheral?.delegate = self
        centralManager?.stopScan()
        centralManager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "a peripheral")")
        self.selectedPeripheral = peripheral

        DispatchQueue.main.async {
            self.isConnected = true
            self.connectedPeripheralName = peripheral.name
        }
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "a peripheral")")
        DispatchQueue.main.async {
            self.isConnected = false
            self.connectedPeripheralName = nil
        }
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    // MARK: - CBPeripheralDelegate Methods

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            switch characteristic.uuid {
                case CBUUID(string: "FFE1"):
                    self.leftHandleCharacteristic = characteristic
                    print("Left Handle Characteristic Found")

                case CBUUID(string: "FFE2"):
                    self.rightHandleCharacteristic = characteristic
                    print("Right Handle Characteristic Found")

                case CBUUID(string: "FFE3"):
                    self.thresholdCharacteristic = characteristic
                    print("Threshold Characteristic Found")

                case CBUUID(string: "FFE4"):
                    self.vibrationCharacteristic = characteristic
                    print("Vibration Characteristic Found")

                case CBUUID(string: "FFE5"):
                    self.batteryCharacteristic = characteristic
                    print("Battery Characteristic Found")
                
                case CBUUID(string: "FFE6"):
                    print("Time Sync Characteristic Found")
                    self.timeCharacteristic = characteristic
                    // Store a reference if needed later
                    self.sendTimeSync(to: characteristic)
                case CBUUID(string: "FFE7"):
                    self.logDataCharacteristic = characteristic
                    print("Log Data Characteristic Found")
                    peripheral.setNotifyValue(true, for: characteristic)


                default:
                    print("Unknown characteristic: \(characteristic.uuid)")
            }

            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }

        guard let data = characteristic.value else {
            print("No data received for characteristic \(characteristic.uuid)")
            return
        }

        DispatchQueue.main.async {
            switch characteristic.uuid {
                case CBUUID(string: "FFE1"): // Left Handle Weight
                    guard data.count == MemoryLayout<UInt16>.size else {
                        print("Unexpected data length for FFE1: \(data.count)")
                        return
                    }
                    let leftWeight = data.withUnsafeBytes { $0.load(as: UInt16.self) }
                    self.leftHandleWeight = Int(leftWeight)
                    print("Left Handle Weight: \(self.leftHandleWeight) lbs")

                case CBUUID(string: "FFE2"): // Right Handle Weight
                    guard data.count == MemoryLayout<UInt16>.size else {
                        print("Unexpected data length for FFE2: \(data.count)")
                        return
                    }
                    let rightWeight = data.withUnsafeBytes { $0.load(as: UInt16.self) }
                    self.rightHandleWeight = Int(rightWeight)
                    print("Right Handle Weight: \(self.rightHandleWeight) lbs")

                case CBUUID(string: "FFE5"): // Battery Data (4 bytes, UInt32)
                    guard data.count == MemoryLayout<UInt32>.size else {
                        print("Unexpected data length for battery: \(data.count)")
                        return
                    }
                case CBUUID(string: "FFE7"):
                    guard data.count >= 8 else { return }
                    
                    let timestamp = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: UInt32.self) }
                    let left = data.withUnsafeBytes { $0.load(fromByteOffset: 4, as: UInt16.self) }
                    let right = data.withUnsafeBytes { $0.load(fromByteOffset: 6, as: UInt16.self) }

                    let entry = LogEntry(
                        timestamp: Date(timeIntervalSince1970: TimeInterval(timestamp)),
                        leftWeight: Double(left) / 100.0,
                        rightWeight: Double(right) / 100.0
                    )
                    DispatchQueue.main.async {
                        self.logEntries.append(entry)
                        print("Received log entry: \(entry)")
                    }


                let batteryData = data.withUnsafeBytes { $0.load(as: UInt32.self) }
                let leftVoltageRaw = UInt16(batteryData & 0xFFFF)   // Lower 16 bits
                let rightVoltageRaw = UInt16(batteryData >> 16)     // Upper 16 bits

                let voltageLeft = Double(leftVoltageRaw) / 1000.0
                let voltageRight = Double(rightVoltageRaw) / 1000.0

                self.batteryVoltageLeft = voltageLeft
                self.batteryVoltageRight = voltageRight

                self.batteryPercentageLeft = self.calculateBatteryPercentage(voltage: voltageLeft)
                self.batteryPercentageRight = self.calculateBatteryPercentage(voltage: voltageRight)

                print("Battery Left: \(voltageLeft)V (\(self.batteryPercentageLeft)%)")
                print("Battery Right: \(voltageRight)V (\(self.batteryPercentageRight)%)")

            default:
                print("Unhandled characteristic update: \(characteristic.uuid)")
            }
        }
    }

    // Convert voltage (V) to percentage
    private func calculateBatteryPercentage(voltage: Double) -> Int {
        let minVoltage = 3.0  
        let maxVoltage = 3.75
        let percentage = (voltage - minVoltage) / (maxVoltage - minVoltage) * 100
        return max(0, min(100, Int(percentage)))
    }


    // MARK: - Sending Data

    func sendThreshold(leftValue: Int, rightValue: Int) {
        sendTwoByteData(leftValue, rightValue, to: thresholdCharacteristic)
    }

    func sendVibration(leftValue: Int, rightValue: Int) {
        sendTwoByteData(leftValue, rightValue, to: vibrationCharacteristic)
    }

    // Generic function to send two UInt8 values (Left & Right Handles)
    private func sendTwoByteData(_ leftValue: Int, _ rightValue: Int, to characteristic: CBCharacteristic?) {
        guard let selectedPeripheral = selectedPeripheral, let characteristic = characteristic else {
            print("No connected peripheral or characteristic available.")
            return
        }

        let leftByte = UInt8(leftValue & 0xFF)   // Extract lower byte
        let rightByte = UInt8(rightValue & 0xFF) // Extract lower byte

        let data = Data([leftByte, rightByte]) // Create a 2-byte Data packet

        selectedPeripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("Sent data: Left: \(leftValue) Right: \(rightValue) to \(characteristic.uuid)")
    }


    private func sendData(_ value: Int, to characteristic: CBCharacteristic?) {
        guard let selectedPeripheral = selectedPeripheral, let characteristic = characteristic else {
            print("No connected peripheral or characteristic available.")
            return
        }

        var dataValue = UInt16(value)
        let data = Data(bytes: &dataValue, count: MemoryLayout<UInt16>.size)

        selectedPeripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("Sent data: \(value) to \(characteristic.uuid)")
    }

    // MARK: - Helper Methods

    func debugBLEState() {
        print("BLE Debug - Connected: \(isConnected), Device: \(connectedPeripheralName ?? "None")")
    }
    
    func sendTimeSync(to characteristic: CBCharacteristic) {
        guard let peripheral = selectedPeripheral else { return }

        // Get current Unix time (seconds since 1970)
        let now = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT(for: now)
        let localTimestamp = UInt32(now.timeIntervalSince1970) + UInt32(timezoneOffset)

        var timeData = localTimestamp.littleEndian
        let data = Data(bytes: &timeData, count: MemoryLayout<UInt32>.size)


        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("Sent current time \(localTimestamp) to ESP32")
    }


    private func resetConnection() {
        peripherals.removeAll()
        peripheralNames.removeAll()
        peripheralMap.removeAll()
        selectedPeripheral = nil
        isConnected = false
        connectedPeripheralName = nil
        receivedMessages.removeAll()
        characteristicsReady = false
    }
}
