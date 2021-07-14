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
