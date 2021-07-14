//
//  Model.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import Foundation

enum Gender {
    case male, female ,other
}

struct User {
    let name:(first: String, last: String)
    let username: String
    let bio: String
    let profilePhoto: URL
    let birthDate: Date
//    let email: String
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}


public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

/// Represents a user post
public struct UserPost {
//    let identifier: String
    let postType: UserPostType
//    let thumbnailImage: URL
    let postURL: URL
    let caption: String // 自己的po文內容
    let likeCount: [PostLike]
    let comments:[PostComment]
    let createdDate: Date
//    let taggedUsers: [String] // 不確定 User
    let owner: User
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let thumbnailImage: URL
    let username: String
    let text: String
    let createdDate: Date
//    let like: [CommentLike]
}


enum Profile: Int {
    case Information = 0
    case Article

}


struct UserTest {
    
    let email: String
    let username: String
    let profileImageURL: String
    
    init(email: String,dictionary: [String:Any]) {
        self.email = email 
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

struct PostTest {
    
    var id: String? ///用於 comment
    
    let user: UserTest
    let imageURL: String
    let caption: String
    let creationDate: Date
    
    init(user: UserTest,dictionary: [String:Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

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
