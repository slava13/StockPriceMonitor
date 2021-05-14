//
//  Scheduler.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 09/04/2021.
//

import Cocoa

protocol Schedule {
    func isTimeToFetch(ignoreDate: Bool) -> Bool
}

class Scheduler: Schedule {
    
    private let date = Date()
    private let weekends = [Date.WeekDay.sunday, Date.WeekDay.saturday]
    
    func isTimeToFetch(ignoreDate: Bool) -> Bool {
        if ignoreDate { return true }
        let currentDay = date.getWeekDay()
        return weekends.contains(currentDay) ? false : true
    }
}
