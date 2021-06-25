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


public enum UserPostType {
    case photo, video
}

/// Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments:[PostComment]
    let createdDate: Date
    let taggedUser: [User]
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
    let username: String
    let text: String
    let createdDate: Date
    let like: [CommentLike]
}



enum Profile {
    case Information
    case Article

}
