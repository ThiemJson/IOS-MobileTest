//
//  Utils.swift
//  internalTest
//
//  Created by Thiem Jason on 7/5/21.
//

import Foundation
class Utils {
    public static func getDateFromStr(with dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:dateString)!
    }
}
