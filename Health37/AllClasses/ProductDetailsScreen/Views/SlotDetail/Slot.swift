//
//  Slot.swift
//  Appt
//
//  Created by user on 02/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import Foundation
struct Slot {
    let title: String
    let `descrition`: String
    let days: String

    static func duretionSlot()->[Slot]{
        let t1 = Slot(title: "15 mins", descrition: "(0.25 hour)", days: "5")
        let t2 = Slot(title: "30 mins", descrition: "(0.5 hour)", days: "5")
        let t3 = Slot(title: "45 mins", descrition: "(0.75 hour)", days: "5")
        let t4 = Slot(title: "60 mins", descrition: "(1 hour)", days: "5")
        return [t1,t2,t3,t4]
    }
    
    static func planPrice()->[Slot]{
        let t1 = Slot(title: "$187", descrition: "6 Months", days: "6")
        let t2 = Slot(title: "$347", descrition: "1 Year", days: "12")
        return [t1,t2]
    }
    
    static func availbleDays()->[Slot]{
        let t1 = Slot(title: "Weekdays", descrition: "(Sun-Thu)", days: "5")
        let t2 = Slot(title: "Long Week", descrition: "(Sun-Fri)", days: "6")
        let t3 = Slot(title: "Everyday", descrition: "(Sun-Sat)", days: "7")
        return [t1,t2,t3]
    }
    
}

class AppointmentDetail {
    
    var slotTime: String?
    var availableDays: String?
    var availableFromHours: String?
    var availableToHours: String?
    var breakFromTime: String?
    var breakToTime: String?
    var notes: String?
    var locationLat: String?
    var locationLong: String?
    var userID: String?

    init(slotTime: String?,availableDays: String?,availableFromHours: String?,availableToHours: String?,breakFromTime: String?,breakToTime: String?,notes: String?,locationLat: String?,locationLong: String?,userID: String?){
        self.slotTime = slotTime
        self.availableDays = availableDays
        self.availableFromHours = availableFromHours
        self.availableToHours = availableToHours
        self.breakFromTime = breakFromTime
        self.breakToTime = breakToTime
        self.notes = notes
        self.locationLat = locationLat
        self.locationLong = locationLong
        self.userID = userID
    }
}
