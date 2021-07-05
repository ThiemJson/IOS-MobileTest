//
//  DateExtension.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit

// MARK: - Date
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
    
    func isOnSameDay(with date: Date) -> Bool {
        let firstDateFormat = Calendar.current.dateComponents([.day, .year, .month], from: self)
        let secondDateFormat = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        return (firstDateFormat.year == secondDateFormat.year
                    && firstDateFormat.month == secondDateFormat.month
                    && firstDateFormat.day == secondDateFormat.day! - 1)
    }
}

// MARK: - UIImage
var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImage(with urlString: String, completion: @escaping (UIImage) -> Void ) {
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage{
            completion(image)
        }
        
        guard let url = URL(string: urlString) else {
            return
            
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                }
            }
        }
    }
}
