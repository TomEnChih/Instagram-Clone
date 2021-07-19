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
    
    func fetchUserWithEmail(with email: String,completion: @escaping(UserTest)->Void) {
        
        let safeEmail = email.safeDatabaseKey()
        
        database.child("user").child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            
            let user = UserTest(email: email, dictionary: userDictionary)
            
            completion(user)
        }
    }
    
        func uploadPost(imageURL: String,caption: String,completion: @escaping(Bool)->Void) {
    
            let key = AuthManager.shared.fetchCurrentUserEmail()
    
            let userPostRef = Database.database().reference().child("posts").child(key)
            let ref = userPostRef.childByAutoId()
    
            let values = ["imageURL": imageURL,
                          "caption": caption,
                          "creationDate": Date().timeIntervalSince1970] as [String:Any]
            
            ref.updateChildValues(values) { (error, ref) in
                if error == nil {
                    // succeeded
                    print("成功上傳 Post")
                    completion(true)
                    return
                } else {
                    // failed
                    completion(false)
                    return
                }
            }
        }
    
    
    func fetchUserWithoutOneself(completion: @escaping(String,[String:Any])->Void) {
        
        let ref = database.child("user")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key,value) in
                /// key: user 裡的所有 email
                if key == AuthManager.shared.fetchCurrentUserEmail() {
                    return /// 搜尋不包含自己
                }
                
                guard let userDictionary = value as? [String:Any] else { return }
//                let user = Observable<UserTest>(UserTest(email: key, dictionary: userDictionary))
                completion(key,userDictionary)
            }
        }
    }
    
    
    func fetchPostComments(postId: String,completion: @escaping(UserTest,[String:Any])->Void) {
        let ref = database.child("comments").child(postId)
        
        ref.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let email = dictionary["email"] as? String else { return }
            
            DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
                completion(user,dictionary)
//                let comment = Observable<Comment>(Comment(user: user, dictionary: dictionary))
            }
        }
    }
    
    func uploadPostComment(postId: String,text: String,completion: @escaping()->Void) {
        
        let email = AuthManager.shared.fetchCurrentUserEmail()
        let values = ["text": text,
                      "creationDate": Date().timeIntervalSince1970,
                      "email" : email] as [String : Any]
        
        let ref = database.child("comments").child(postId).childByAutoId()
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to insert comment:", error)
                return
            }
            print("Successfully inserted comment.")
            completion()
        }
    }
    
    func uplaodUserProfile(imageURL: String,username: String,name: String?, bio:String?,completion: @escaping(Bool)->Void) {
        
        let email = AuthManager.shared.fetchCurrentUserEmail()
        let value = ["profileImageURL": imageURL,
                     "username": username,
                     "name": name ?? "",
                     "bio": bio ?? ""] as [String:Any]
        
        let ref = database.child("user").child(email)
        ref.updateChildValues(value) { (error, ref) in
            if error == nil {
                // succeeded
                print("成功上傳 UserProfile")
                completion(true)
                return
            } else {
                // failed
                completion(false)
                return
            }
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            completion(.success("成功上傳 UserProfile"))
        }
    }
    
    func fetchPostsWithEmail(with email: String,completion: @escaping(String,[String:Any])->Void) {
        
        let ref = Database.database().reference().child("posts").child(email)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                /// key: post id
                /// dictionary: post data
                completion(key,dictionary)
            }
        }
    }
    
    func fetchPostLike(postId: String,completion: @escaping(Bool)->Void) {
        
        let currentUserEmail = AuthManager.shared.fetchCurrentUserEmail()
        
        let ref = database.child("likes").child(postId).child(currentUserEmail)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Int,value == 1 {
//                post.value?.hasLiked = true
                completion(true)
            } else {
//                post.value?.hasLiked = false
                completion(false)
            }
        }
    }
    
    
    func uploadPostLike(postId: String,hasLiked: Bool,completion: @escaping(Bool)->Void) {
        
        let email = AuthManager.shared.fetchCurrentUserEmail()
        let values = [email: hasLiked == true ? 0 : 1]
        
        database.child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to like post:",error)
                return
            }
            print("Successfully liked post.")
            completion(!hasLiked)
//            post.value?.hasLiked = !post.value!.hasLiked ///post 跟 posts 無關，需要把他帶換掉 posts[indexPath.item]
//            self.posts[indexPath.item] = post
//            self.homeView.homeCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uploadPostSave(postId: String,hasSaved: Bool,completion: @escaping(Bool)->Void) {
        let email = AuthManager.shared.fetchCurrentUserEmail()
        let values = [email: hasSaved == true ? 0 : 1]
        
        database.child("save").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to save post:",error)
                return
            }
            print("Successfully saved post.")
            completion(!hasSaved)
        }
    }
    
    
    func fetchPostSave(postId: String,completion: @escaping(Bool)->Void) {
        
        let currentUserEmail = AuthManager.shared.fetchCurrentUserEmail()
        
        database.child("save").child(postId).child(currentUserEmail).observeSingleEvent(of: .value) { (snapshot) in
            
            if let value = snapshot.value as? Int ,value == 1 {
//                post.value?.hasSaved = true
                completion(true)
            } else {
//                post.value?.hasSaved = false
                completion(false)
            }
        }
    }
    
    
    
    func fetchFollowerEmail(userEmail: String,completion: @escaping(String)->Void) {
        
//        let currentUserEmail = AuthManager.shared.fetchCurrentUserEmail()
        
        let followerRef = database.child("follower").child(userEmail)
        followerRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach { (key,value) in
                ///key: follower email (all follower)
                completion(key)
//                Database.fetchUserWithEmail(with: key) { (user) in
//                    let model = Observable<UserNotification>(UserNotification(type: .follow, user: user))
//                    self.models.append(model)
//                    self.handleViewDisplay()
//                    self.notificationsView.notificationsTableView.reloadData()
//                }
            }
        }
    }
    
    
    func fetchFollowingEmail(userEmail: String,completion: @escaping(String)->Void) {
        
        let ref = database.child("following").child(userEmail)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            /// [email: 1]
            guard let userEmailDictionary = snapshot.value as? [String:Any] else { return }
            
            userEmailDictionary.forEach { (key,value) in
                /// get user following email
                completion(key)
            }
        }
    }
    
    
    func fetchPostLikeAllUser(postId:String,completion: @escaping(String)->Void) {
        
        let likeRef = database.child("likes").child(postId)
        likeRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let likeDictionary = snapshot.value as? [String:Any] else { return }
            
            likeDictionary.forEach { (key,value) in
                /// key: email (所有點愛心的人)
                /// value: 1 按愛心 ; 0 取消了
                guard let value = value as? Int, value == 1 else { return }
                completion(key)
            }
        }
    }
    
    func cancelFollowerAndFollowing (currentUserEmail: String,OtherUserEmail: String,completion: @escaping()->Void) {
        
        // unfollowing (取消追蹤)
        let ref = Database.database().reference().child("following").child(currentUserEmail).child(OtherUserEmail)
        ref.removeValue { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            completion()
            
            print("successfully unfollowed user")
        }
        // unfollower (粉絲)
        let followerRef = Database.database().reference().child("follower").child(OtherUserEmail).child(currentUserEmail)
        followerRef.removeValue { (error, ref) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func followingOtherUserAndFollower(currentUserEmail: String,otherUserEmail: String,completion: @escaping()->Void) {
        let value = [otherUserEmail: 1]
        let ref = database.child("following").child(currentUserEmail)
        ref.updateChildValues(value, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("Failed to follow user:",error)
                return
            }
            completion()
        })
        
        let followerValue = [currentUserEmail: 1]
        let followerRef = database.child("follower").child(otherUserEmail)
        followerRef.updateChildValues(followerValue) { (error, ref) in
            if let error = error {
                print("粉絲增加失敗：",error)
                return
            }
            print("粉絲增加")
        }
    }
    
    func fetchFollowing(currentUserEmail: String,followingEmail: String,completion: @escaping(Bool)->Void) {
        
        let ref = Database.database().reference().child("following").child(currentUserEmail).child(followingEmail)
        ref.observe(.value) { (snapshot) in
            
            if let isFollowing = snapshot.value as? Int,isFollowing == 1 {
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
}
