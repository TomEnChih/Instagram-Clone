//
//  Post.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import Foundation

struct PostTest {
    
    var id: String? ///用於 comment
    
    let user: UserTest
    let imageURL: String
    let caption: String
    let creationDate: Date
    
    var hasLiked = false
    var hasSaved = false
    
    init(user: UserTest,dictionary: [String:Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
