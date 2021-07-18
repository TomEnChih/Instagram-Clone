//
//  Comment.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import Foundation

struct Comment {
    
    let user: UserTest
    let text: String
    let email: String
    
    init(user: UserTest,dictionary: [String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
