//
//  DateFormatterHelper.swift
//  NewsClient
//
//  Created by Marina Zhukova on 20.06.2024.
//

import Foundation

struct DateFormatterHelper {
    
    static func formatDateString(from dateString: String, inputFormat: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputFormat
            return outputDateFormatter.string(from: date)
        } else {
            return "Date format error"
        }
    }
    
}
