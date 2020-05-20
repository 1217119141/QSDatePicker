//
//  NSDateExtension.swift
//  date
//
//  Created by 业通宝 on 2020/5/7.
//  Copyright © 2020 业通宝. All rights reserved.
//

import Foundation

let componentFlags: Set<Calendar.Component> = [.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal]
public extension Date{
    static var currentCalendarSharedCalendar: Calendar? = nil
    
    static func currentCalendar() -> Calendar? {
        if currentCalendarSharedCalendar == nil {
            currentCalendarSharedCalendar = Calendar.autoupdatingCurrent
        }
        return currentCalendarSharedCalendar
    }
    static func dateWithDaysFromNow(days:Int) -> Date{
        return Date().dateByAddingDays(dDays: days)
    }
    static func dateWithDaysBeforeNow(days:Int) -> Date{
        return Date().dateBySubtractingDays(dDays: days)
    }
    static func dateTomorrow() -> Date{
        return Date.dateWithDaysFromNow(days: 1)
    }
    static func dateYesterday() -> Date{
        return Date.dateWithDaysBeforeNow(days: 1)
    }
    static func dateWithHoursFromNow(dHours:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(3600 * dHours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    static func dateWithHoursBeforeNow(dHours:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate - Double(3600 * dHours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    static func dateWithMinutesFromNow(dMinutes:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(60 * dMinutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    static func dateWithMinutesBeforeNow(dMinutes:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate - Double(60 * dMinutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    public func stringWithFormat(format:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    func stringWithDateStyle(dateStyle:DateFormatter.Style, timeStyle:DateFormatter.Style) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    var shortString:String{
        get{
            return stringWithDateStyle(dateStyle: .short, timeStyle: .short)
        }
    }
    var shortTimeString:String{
        get{
            return stringWithDateStyle(dateStyle: .none, timeStyle: .short)
        }
    }
    var shortDateString:String{
        get{
            return stringWithDateStyle(dateStyle: .short, timeStyle: .none)
        }
    }
    var mediumString:String{
        get{
            return stringWithDateStyle(dateStyle: .medium, timeStyle: .medium)
        }
    }
    var mediumTimeString:String{
        get{
            return stringWithDateStyle(dateStyle: .none, timeStyle: .medium)
        }
    }
    var mediumDateString:String{
        get{
            return stringWithDateStyle(dateStyle: .medium, timeStyle: .none)
        }
    }
    var longString:String{
        get{
            return stringWithDateStyle(dateStyle: .long, timeStyle: .long)
        }
    }
    var longTimeString:String{
        get{
            return stringWithDateStyle(dateStyle: .none, timeStyle: .long)
        }
    }
    var longDateString:String{
        get{
            return stringWithDateStyle(dateStyle: .long, timeStyle: .none)
        }
    }
    
    
    
    
    func isEqualToDateIgnoringTime(aDate:Date) -> Bool{
        let components1 = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar()?.dateComponents(componentFlags, from: aDate)
        return components1?.year == components2?.year && components1?.month == components2?.month && components1?.day == components2?.day
    }
    func isToday() -> Bool{
        return isEqualToDateIgnoringTime(aDate: Date())
    }
    func isTomorrow() -> Bool{
        return isEqualToDateIgnoringTime(aDate: Date.dateTomorrow())
    }
    func isYesterday() -> Bool{
        return isEqualToDateIgnoringTime(aDate: Date.dateYesterday())
    }
    func isSameWeekAsDate(aDate:Date) -> Bool{
        let components1 = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar()?.dateComponents(componentFlags, from: aDate)
        if components1?.weekOfMonth != components2?.weekOfMonth {return false}
        return fabs(self.timeIntervalSince(aDate)) < 604800
    }
    func isThisWeek() -> Bool{
        return isSameMonthAsDate(aDate: Date())
    }
    func isNextWeek() -> Bool{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + 604800
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return isSameMonthAsDate(aDate: newDate)
    }
    func isLastWeek() -> Bool{
        let aTimeInterval = Date().timeIntervalSinceReferenceDate - 604800
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return isSameMonthAsDate(aDate: newDate)
    }
    func isSameMonthAsDate(aDate:Date) -> Bool{
        let components1 = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar()?.dateComponents(componentFlags, from: aDate)
        return components1?.month == components2?.month && components1?.year == components2?.year
    }
    func isThisMonth() -> Bool{
        return isSameMonthAsDate(aDate: Date())
    }
    func isLastMonth() -> Bool{
        return isSameMonthAsDate(aDate: Date().dateBySubtractingMonths(dMonths: 1))
    }
    func isNextMonth() -> Bool{
       return isSameMonthAsDate(aDate: Date().dateByAddingMonths(dMonths: 1))
    }
    func isSameYearAsDate(aDate:Date) -> Bool{
        let components1 = Date.currentCalendar()?.component(.year, from: self)
        let components2 = Date.currentCalendar()?.component(.year, from: aDate)
        return components1 == components2
    }
    func isThisYear() -> Bool{
        return self.isSameYearAsDate(aDate: Date())
    }
    func isNextYear() -> Bool{
        let components1 = Date.currentCalendar()?.component(.year, from: self)
        let components2 = Date.currentCalendar()?.component(.year, from: Date())
        return components1 == components2! + 1
    }
    func isLastYear() -> Bool{
        let components1 = Date.currentCalendar()?.component(.year, from: self)
        let components2 = Date.currentCalendar()?.component(.year, from: Date())
        return components1 == components2! - 1
    }
    func isEarlierThanDate(aDate:Date) -> Bool{
        return (self.compare(aDate) == .orderedAscending)
    }
    func isLaterThanDate(aDate:Date) -> Bool{
        return (self.compare(aDate) == .orderedDescending)
    }
    func isInFuture() -> Bool{
        return isLaterThanDate(aDate: Date())
    }
    func isInPast() -> Bool{
        return isEarlierThanDate(aDate: Date())
    }
    func isTypicallyWeekend() -> Bool{
        let components = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        if components?.weekday == 1 ||  components?.weekday == 7{
            return true
        }
        return false
    }
    func isTypicallyWorkday() -> Bool{
        return !isTypicallyWeekend()
    }
    func dateByAddingYears(dYears:NSInteger) -> Date{
        var dateComponents = DateComponents()
        dateComponents.setValue(dYears, for: .year)
        let newDate = Calendar.current.date(byAdding: dateComponents, to: self)
        return newDate!
    }
    func dateBySubtractingYears(dYears:Int) -> Date{
        return dateByAddingYears(dYears: -dYears)
    }
    func dateByAddingMonths(dMonths:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.setValue(dMonths, for: .month)
        let newDate = Calendar.current.date(byAdding: dateComponents, to: self)
        return newDate!
    }
    func dateBySubtractingMonths(dMonths:Int) -> Date{
        return dateByAddingMonths(dMonths: -dMonths)
    }
    func dateByAddingDays(dDays:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.setValue(dDays, for: .day)
        let newDate = Calendar.current.date(byAdding: dateComponents, to: self)
        return newDate!
    }
    func dateBySubtractingDays(dDays:Int) -> Date{
        return dateByAddingDays(dDays: dDays * -1)
    }
    
    func dateByAddingHours(dHours:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(3600 * dHours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    func dateBySubtractingHours(dHours:Int) -> Date{
        return dateByAddingHours(dHours: dHours * -1)
    }
    func dateByAddingMinutes(dMinutes:Int) -> Date{
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(60 * dMinutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    func dateBySubtractingMinutes(dMinutes:Int) -> Date{
        return dateByAddingMinutes(dMinutes: dMinutes * -1)
    }
    func componentsWithOffsetFromDate(aDate:Date) -> DateComponents{
        return (Date.currentCalendar()?.dateComponents(componentFlags, from: aDate, to: self))!
    }
    func dateAtStartOfDay() -> Date{
        var components = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        components?.hour = 0
        components?.minute = 0
        components?.second = 0
        return (Date.currentCalendar()?.date(from: components!))!
    }
    func dateAtEndOfDay() -> Date{
        var components = Date.currentCalendar()?.dateComponents(componentFlags, from: self)
        components?.hour = 23
        components?.minute = 59
        components?.second = 59
        return (Date.currentCalendar()?.date(from: components!))!
    }
    func minutesAfterDate(aDate:Date) -> Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / 60)
    }
    func minutesBeforeDate(aDate:Date) -> Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / 60)
    }
    func hoursAfterDate(aDate:Date) -> Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / 3600)
    }
    func hoursBeforeDate(aDate:Date) -> Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / 3600)
    }
    
    func daysAfterDate(aDate:Date) -> Int{
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / 86400)
    }
    func daysBeforeDate(aDate:Date) -> Int{
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / 86400)
    }
    func distanceInDaysToDate(anotherDate:Date) -> Int{
        let gregorianCalendar = Calendar(identifier: .gregorian)
        return gregorianCalendar.dateComponents([.day], from: self, to: anotherDate).day!
    }
    var nearestHour:Int{
        get{
            let aTimeInterval = Date().timeIntervalSinceReferenceDate + 1800
            let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
            return (Date.currentCalendar()?.component(.hour, from: newDate))!
        }
    }
    
    var hour:Int{
        get{
            return (Date.currentCalendar()?.component(.hour, from: self))!
        }
    }
    var minute:Int{
        get{
            return (Date.currentCalendar()?.component(.minute, from: self))!
        }
    }
    var seconds:Int{
        get{
            return (Date.currentCalendar()?.component(.second, from: self))!
        }
    }
    var day:Int{
        get{
            return (Date.currentCalendar()?.component(.day, from: self))!
        }
    }
    var month:Int{
        get{
            return (Date.currentCalendar()?.component(.month, from: self))!
        }
    }
    var week:Int{
        get{
            return (Date.currentCalendar()?.component(.weekOfMonth, from: self))!
        }
    }
    var weekday:Int{
        get{
            return (Date.currentCalendar()?.component(.weekday, from: self))!
        }
    }
    var nthWeekday:Int{
        get{
            return (Date.currentCalendar()?.component(.weekdayOrdinal, from: self))!
        }
    }
    var year:Int{
        get{
            return (Date.currentCalendar()?.component(.year, from: self))!
        }
    }
    static func date(datestr:String, WithFormat format:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: datestr)
        return date!
    }
    func dateWithYMD() -> Date{
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        return fmt.date(from: selfStr)!
    }
    public func dateWithFormatter(formatter:String) -> Date{
        let fmt = DateFormatter()
        fmt.dateFormat = formatter
        let selfStr = fmt.string(from: self)
        return fmt.date(from: selfStr)!
    }
}
