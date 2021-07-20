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
         - create account
         - insert account to database
         */
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard result != nil,error == nil else {
                // Firebase auth could not create account
                completion(false)
                return
            }
            /// 為了其他地方上傳圖片
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {
                completion(false)
                return
            }
            
            StorageManager.shared.uploadUserProfileImage(with: uploadData) { (urlString) in
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
    
    
    public func loginUser(email: String,
                          password: String,
                          completion: @escaping (Bool) -> Void) {
        // email log in
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard authResult != nil,error == nil else {
                completion(false)
                return
            }
            completion(true)
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
    
    
    public func fetchCurrentUserEmail() -> String{
        let email = Auth.auth().currentUser?.email
        return email?.safeDatabaseKey() ?? "nil"
    }
    
    
}
