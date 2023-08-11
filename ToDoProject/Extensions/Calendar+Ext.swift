//
//  Calendar+Ext.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/12.
//

import Foundation

extension Calendar {
    
    static let KoreanCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        
        return calendar
    }()
}
