//
//  AuthManager.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: - Public
    
    public func registerNewUser(profileImage: UIImage,
                                username: String,
                                email: String,
                                password: String,
                                completion: @escaping (Bool)->Void) {
        /*
         - check if username is available
         - check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - create account
                 - insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard result != nil,error == nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    StorageManager.shared.uploadUserProfileImage(with: profileImage) { (urlString) in
                        switch urlString {
                        case .success(let imageString):
                            
                            // insert into database
                            DatabaseManager.shared.insertNewUser(urlString: imageString, with: email, username: username) { (inserted) in
                                if inserted {
                                    completion(true)
                                    return
                                } else {
                                    // failed to insert to database
                                    completion(false)
                                    return
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                }
            }
            else {
                // either username or email does not exist
                completion(false)
            }
        }
        
        
    }
    
    
    public func loginUser(username: String?,
                          email: String?,
                          password: String,
                          completion: @escaping (Bool) -> Void) {
        if let email = email {
            // email log in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil,error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        } else if let username = username {
            // username log in
            #warning("還沒做")
            print(username)
        }
        
    }
    
    public func logOut(completion: (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print("failed to sign out.")
            completion(false)
            return
        }
    }
    
}
