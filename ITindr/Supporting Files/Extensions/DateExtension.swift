//
//  DateExtension.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//

import Foundation

extension Date {
    static func isIncreasingDateOrder(date1: Date?, date2: Date?) -> Bool {
        guard let date1 = date1, let date2 = date2 else {
            return date1 != nil
        }
        return date1 > date2
    }
    
    static func from(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: string.replacingOccurrences(of: "[UTC]", with: ""))
    }
    
    func toServerFormat() -> String? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
    
    func toMessageFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        formatter.dateFormat = "HH:mm • d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU_POSIX")
        return formatter.string(from: self)
    }
}
