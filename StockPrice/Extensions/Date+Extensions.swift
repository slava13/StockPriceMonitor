//
//  Date+Extensions.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 05/04/2021.
//

import Cocoa

extension Date {

    enum WeekDay: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    func getWeekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDay(rawValue: weekDay)!
    }
}
