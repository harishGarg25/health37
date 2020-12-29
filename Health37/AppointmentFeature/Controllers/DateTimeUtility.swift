//
//  DateTimeUtility.swift
//  Appt
//
//  Created by user on 03/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import Foundation

class DateTimeUtility{
    
    func getTimeInterwal(startFrom: String? = nil)->[String]{
        
        var sortedArray: [String] = []
        let array: [String] = ["07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM","12:00AM"]

//        let array: [String] = ["07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM"]
        let time = startFrom ?? "07:00 AM"
        
        if let index = array.index(of: time)
        {
            for index in index...array.count - 1
            {
                sortedArray.append(array[index])
            }
            return sortedArray
        }
        return array
    }
    
    func getLunchTimeInterwal(startFrom: String? = nil)->[String]{
        
        var sortedArray: [String] = []
        let array: [String] = ["12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM"]
        let time = startFrom ?? "12:00 PM"
        
        if let index = array.index(of: time)
        {
            for index in index...array.count - 1
            {
                sortedArray.append(array[index])
            }
            return sortedArray
        }
        return array
    }
    func timeAfter(mints: Double , time: String)->String?{
        let array: [String] = ["12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM"]
        if var index = array.index(of: time)
        {
            index = index + 1
            if index < array.count
            {
                return array[index]
            }
            return time
        }
        return time
    }
    
}
