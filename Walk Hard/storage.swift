//// INCOMPLETE

//// Used for local storage of weight-timestamp combos as well as averages. Weight timestamp combos are currently sent from Mcu on
//// connection, but need to be handled in Bluetooth view and stored/displayed using this.
//
//
//
//
//
////  storage.swift
//
//// SQLiteManager.swift
//import Foundation
//import SQLite3
//
//class SQLiteManager {
//    static let shared = SQLiteManager()
//
//    private var db: OpaquePointer?
//    private let dbName = "WalkerLogs.sqlite"
//
//    private init() {
//        openDatabase()
//        createTable()
//    }
//
//    private func openDatabase() {
//        let fileURL = try! FileManager.default
//            .urls(for: .documentDirectory, in: .userDomainMask)
//            .first!
//            .appendingPathComponent(dbName)
//
//        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
//            print("❌ Unable to open database")
//        }
//    }
//
//    private func createTable() {
//        let createTableQuery = """
//        CREATE TABLE IF NOT EXISTS DailySummary (
//            id TEXT PRIMARY KEY,
//            date TEXT,
//            averageLeft REAL,
//            averageRight REAL
//        );
//        """
//
//        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
//            print("❌ Failed to create table: \(String(cString: sqlite3_errmsg(db)))")
//        }
//    }
//
//    func insertSummary(date: Date, averageLeft: Double, averageRight: Double) {
//        let query = "INSERT INTO DailySummary (id, date, averageLeft, averageRight) VALUES (?, ?, ?, ?);"
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
//            let uuid = UUID().uuidString
//            let formatter = ISO8601DateFormatter()
//            let dateString = formatter.string(from: date)
//
//            sqlite3_bind_text(stmt, 1, uuid, -1, nil)
//            sqlite3_bind_text(stmt, 2, dateString, -1, nil)
//            sqlite3_bind_double(stmt, 3, averageLeft)
//            sqlite3_bind_double(stmt, 4, averageRight)
//
//            if sqlite3_step(stmt) != SQLITE_DONE {
//                print("❌ Failed to insert summary")
//            }
//        } else {
//            print("❌ Insert statement could not be prepared")
//        }
//        sqlite3_finalize(stmt)
//    }
//
//    func fetchSummaries(for range: DateInterval) -> [DailySummary] {
//        let query = "SELECT id, date, averageLeft, averageRight FROM DailySummary;"
//        var stmt: OpaquePointer?
//        var results: [DailySummary] = []
//
//        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
//            let formatter = ISO8601DateFormatter()
//
//            while sqlite3_step(stmt) == SQLITE_ROW {
//                let id = String(cString: sqlite3_column_text(stmt, 0))
//                let dateString = String(cString: sqlite3_column_text(stmt, 1))
//                let averageLeft = sqlite3_column_double(stmt, 2)
//                let averageRight = sqlite3_column_double(stmt, 3)
//
//                if let date = formatter.date(from: dateString), range.contains(date) {
//                    let summary = DailySummary(id: id, date: date, averageLeft: averageLeft, averageRight: averageRight)
//                    results.append(summary)
//                }
//            }
//        } else {
//            print("❌ Fetch failed")
//        }
//        sqlite3_finalize(stmt)
//        return results
//    }
//}
//
//// DailySummary.swift
//import Foundation
//
//struct DailySummary: Identifiable {
//    var id: String
//    var date: Date
//    var averageLeft: Double
//    var averageRight: Double
//}
