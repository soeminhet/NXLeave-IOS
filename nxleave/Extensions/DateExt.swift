//
//  DateExt.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation
import FirebaseFirestore

enum DatePattern: String {
    case weekDay = "EEEE"
    case dayMonthYear = "dd MMM yyyy"
    case dayMonth = "dd MMM"
}

extension Date {
    func format(with pattern: DatePattern) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern.rawValue
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
      }

      func endOfMonth() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.month! += 1
        components.day = 0
        return calendar.date(from: components)!
      }
}

func getTodayStartTimeStamp() -> Timestamp {
    let calendar = Calendar.current
    let now = Date()
    let startOfToday = calendar.startOfDay(for: now)
    return Timestamp(date: startOfToday)
}

func getDateRange(startDate: Date, endDate: Date?, period: String?) -> String {
    if let period = period {
        let startDate = startDate.format(with: DatePattern.dayMonthYear)
        return "\(startDate) - \(period)"
    } else {
        let startDate = startDate.format(with: DatePattern.dayMonthYear)
        let endDate = endDate?.format(with: DatePattern.dayMonthYear)
        return "\(startDate) - \(endDate ?? "")"
    }
}
