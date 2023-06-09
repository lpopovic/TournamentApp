//
//  Extensions+Date.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import Foundation

extension Date {
    func getDateOfBirthFormatString(dateFormat: String = Date.dateOfBirthFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    static let dateOfBirthFormat: String = "YYYY-MM-dd"
    static let dateOfBirthFullFormat: String = "yyyy-MM-dd HH:mm:ss"
    
    static func getCurrentDate()-> Date {
         var now = Date()
         var nowComponents = DateComponents()
         let calendar = Calendar.current
         nowComponents.year = Calendar.current.component(.year, from: now)
         nowComponents.month = Calendar.current.component(.month, from: now)
         nowComponents.day = Calendar.current.component(.day, from: now)
         nowComponents.hour = Calendar.current.component(.hour, from: now)
         nowComponents.minute = Calendar.current.component(.minute, from: now)
         nowComponents.second = Calendar.current.component(.second, from: now)
         nowComponents.timeZone = NSTimeZone.local
         now = calendar.date(from: nowComponents)!
         return now as Date
     }
    
    static func getMinMaxDateForDatePicker() -> (minDate: Date?, maxDate: Date?) {
        let yearsToSubForMin = -50
        let yearsToSubForMax = -12
        let currentDate = Date.getCurrentDate()
        var dateComponent = DateComponents()
        
        dateComponent.year = yearsToSubForMin
        let minDateValue = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        dateComponent.year = yearsToSubForMax
        let maxDateValue = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        return(minDate: minDateValue, maxDate: maxDateValue)
    }
}
