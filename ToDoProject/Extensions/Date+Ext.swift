//
//  Date+Ext.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import Foundation
import UIKit

extension Date {
    
    func convertToString() -> String {
        let dateformatter = DateFormatter()
        
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone(abbreviation: "KST")
        
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: self)
        
    }
    
    func getStartOfDay() -> Date {
        let calendar = Calendar.KoreanCalendar
        return calendar.startOfDay(for: self)
    }
}


