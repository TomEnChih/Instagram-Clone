//
//  DatabaseManager.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    // Check if  username and email is available
    // - Parameters
    //   - email: String representring email
    //   - username: String representring username
    #warning("是不是無用的")
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)->Void) {
        completion(true)
    }
    
    // Inserts new user data to database
    // - Parameters
    //   - email: String representring email
    //   - username: String representring username
    public func insertNewUser(urlString imageSting: String,with email: String,username: String, completion: @escaping (Bool)->Void) {
        let key = email.safeDatabaseKey().lowercased() /// 因為auth會自動把大寫變小寫,所以database要全變小寫
        let value = ["profileImageURL":imageSting,"username":username] as [String:Any]
        
        database.child("user").child(key).updateChildValues(value) { error, _ in
            if error == nil {
                // succeeded
                completion(true)
                return
            } else {
                // failed
                completion(false)
                return
            }
            
        }
    }
    
}

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}

