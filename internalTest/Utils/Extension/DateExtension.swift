//
//  DateExtension.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import Foundation
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getFormattedDate(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: self)
        }
}
