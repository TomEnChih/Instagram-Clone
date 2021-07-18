//
//  ExtensionFunction.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/8.
//

import UIKit
import FirebaseDatabase

extension UICollectionView {
    
    static var id: String {
        return "\(Self.self)"
    }
}

extension Database {
    
    static func fetchUserWithEmail(with email: String,completion: @escaping(UserTest)->Void) {
        
        let safeEmail = email.safeDatabaseKey()
        
        Database.database().reference().child("user").child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in

            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            
            let user = UserTest(email: email, dictionary: userDictionary)
                        
            completion(user)
        }
    }
}


extension UIColor {
    
    static var garywhite: UIColor {
        return UIColor(displayP3Red: 149/255, green: 144/255, blue: 204/255, alpha: 0.3)
    }
}


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
