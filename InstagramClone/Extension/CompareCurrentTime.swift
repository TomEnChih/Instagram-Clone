//
//  CompareCurrentTime.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import Foundation

extension Date {
    
    func compareCurrentTime() -> String {
        
    //    let date: Date = Date.init(timeIntervalSince1970: timeStamp)
        var timeInterval = self.timeIntervalSinceNow
        timeInterval = -timeInterval
        
        let minute: Double = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        var result: String
        
        if timeInterval < minute {
            // 一分鐘內
            result = "just now"
            return result
            
        } else if timeInterval < hour {
            // 一小時內
            result = String(format: "%@ min ago", String(Int(timeInterval/minute)))
            return result

        } else if timeInterval < day {
            // 一天內
            result = String(format: "%@ hour ago", String(Int(timeInterval/hour)))
            return result

        } else if timeInterval < week {
            // 一週內
            result = String(format: "%@ day ago", String(Int(timeInterval/day)))
            return result
            
        } else {
            // 超過一週
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "MM/dd/HH:mm"
            result = dateformatter.string(from: self)
            return result
        }
    }
    
}
