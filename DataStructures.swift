/* This file is meant for data handling for user-history tracking */

import SwiftUI

struct Entry: Identifiable {
    let id = UUID()  // Unique ID for SwiftUI
    let time: String // e.g., "Jan", "Feb", or "Mon", "Tue"
    let weight: Double // Pounds (TODO: add kg option)
}

/* SAMPLE DATA
    Originally used for testing, but if the app is downloaded before purchase
    why not show customers what it will look like*/


let SampleLeftYearData = [  // More on left
    Entry(time: "Jan", weight: 70),
    Entry(time: "Feb", weight: 60),
    Entry(time: "Mar", weight: 60),
    Entry(time: "Apr", weight: 40),
    Entry(time: "May", weight: 50),
    Entry(time: "Jun", weight: 45),
    Entry(time: "Jul", weight: 30),
    Entry(time: "Aug", weight: 35),
    Entry(time: "Sep", weight: 30),
    Entry(time: "Oct", weight: 30),
    Entry(time: "Nov", weight: 25),
    Entry(time: "Dec", weight: 25)
]

let SampleRightYearData = [
    Entry(time: "Jan", weight: 65),
    Entry(time: "Feb", weight: 60),
    Entry(time: "Mar", weight: 55),
    Entry(time: "Apr", weight: 40),
    Entry(time: "May", weight: 45),
    Entry(time: "Jun", weight: 45),
    Entry(time: "Jul", weight: 25),
    Entry(time: "Aug", weight: 35),
    Entry(time: "Sep", weight: 25),
    Entry(time: "Oct", weight: 30),
    Entry(time: "Nov", weight: 25),
    Entry(time: "Dec", weight: 20)
]

let SampleLeftMonthData = [
    Entry(time: "1", weight: 30),
    Entry(time: "2", weight: 35),
    Entry(time: "2", weight: 45),
    Entry(time: "3", weight: 40),
    Entry(time: "4", weight: 30),
    Entry(time: "5", weight: 35),
    Entry(time: "6", weight: 50),
    Entry(time: "7", weight: 15),
    Entry(time: "8", weight: 0),
    Entry(time: "9", weight: 0),
    Entry(time: "10", weight: 25),
    Entry(time: "11", weight: 10),
    Entry(time: "12", weight: 0),
    Entry(time: "13", weight: 0),
    Entry(time: "14", weight: 0),
    Entry(time: "15", weight: 10),
    Entry(time: "16", weight: 30),
    Entry(time: "17", weight: 45),
    Entry(time: "18", weight: 25),
    Entry(time: "19", weight: 30),
    Entry(time: "20", weight: 15),
    Entry(time: "21", weight: 0),
    Entry(time: "22", weight: 0),
    Entry(time: "23", weight: 15),
    Entry(time: "24", weight: 25),
    Entry(time: "25", weight: 35),
    Entry(time: "26", weight: 10),
    Entry(time: "27", weight: 40),
    Entry(time: "28", weight: 45),
    Entry(time: "29", weight: 45),
    Entry(time: "30", weight: 25),
    Entry(time: "31", weight: 35)
]

let SampleRightMonthData = [
    Entry(time: "1", weight: 25),
    Entry(time: "2", weight: 35),
    Entry(time: "2", weight: 45),
    Entry(time: "3", weight: 35),
    Entry(time: "4", weight: 30),
    Entry(time: "5", weight: 35),
    Entry(time: "6", weight: 45),
    Entry(time: "7", weight: 15),
    Entry(time: "8", weight: 0),
    Entry(time: "9", weight: 0),
    Entry(time: "10", weight: 20),
    Entry(time: "11", weight: 10),
    Entry(time: "12", weight: 0),
    Entry(time: "13", weight: 0),
    Entry(time: "14", weight: 0),
    Entry(time: "15", weight: 10),
    Entry(time: "16", weight: 25),
    Entry(time: "17", weight: 40),
    Entry(time: "18", weight: 25),
    Entry(time: "19", weight: 30),
    Entry(time: "20", weight: 10),
    Entry(time: "21", weight: 0),
    Entry(time: "22", weight: 0),
    Entry(time: "23", weight: 15),
    Entry(time: "24", weight: 20),
    Entry(time: "25", weight: 30),
    Entry(time: "26", weight: 10),
    Entry(time: "27", weight: 40),
    Entry(time: "28", weight: 40),
    Entry(time: "29", weight: 45),
    Entry(time: "30", weight: 20),
    Entry(time: "31", weight: 35)
]

let SampleLeftWeekData = [  // More on left
    Entry(time: "Sun", weight: 40),
    Entry(time: "Mon", weight: 45),
    Entry(time: "Tue", weight: 30),
    Entry(time: "Wed", weight: 25),
    Entry(time: "Thu", weight: 35),
    Entry(time: "Fri", weight: 25),
    Entry(time: "Sat", weight: 20)
]

let SampleRightWeekData = [
    Entry(time: "Sun", weight: 35),
    Entry(time: "Mon", weight: 40),
    Entry(time: "Tue", weight: 30),
    Entry(time: "Wed", weight: 20),
    Entry(time: "Thu", weight: 35),
    Entry(time: "Fri", weight: 20),
    Entry(time: "Sat", weight: 15)
]
