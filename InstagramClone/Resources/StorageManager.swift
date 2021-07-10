//
//  StorageManager.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum IGStorageManagerError: Error {
        case failedToDownload
    }
    //MARK: - Public
    
    public func uploadUserPost(model: UserPost,completion: @escaping (Result<URL,Error>)->Void) {
        
    }
    
    public func downloadImage(with reference: String,completion: @escaping (Result<URL,IGStorageManagerError>)->Void) {
        bucket.child(reference).downloadURL { (url, error) in
            guard let url = url,error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            completion(.success(url))
        }
    }
    
    public func uploadUserProfileImage(with image: UIImage,completion: @escaping(Result<String,Error>)->Void) {
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else {
            return
        }
        
        let fileName = UUID().uuidString
        let ref = bucket.child("profile_images").child(fileName)
        
        ref.putData(uploadData, metadata: nil) { (metaData, error) in
            guard error == nil else {
//                print("Failed to upload profile image", error)
                completion(.failure(error!))
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else { return }
                let downloadURLString = downloadURL.absoluteString
                completion(.success(downloadURLString))
            })
            
        }
        
    }
    
}
