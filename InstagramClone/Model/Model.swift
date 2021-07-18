//
//  Model.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import Foundation

struct UserTest {
    
    let email: String
    var username: String
    let profileImageURL: String
    
    var name: String?
    var bio: String?
    
    init(email: String,dictionary: [String:Any]) {
        self.email = email 
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
}

