//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/10.
//

import UIKit

class CustomImageView: UIImageView {

    static var cache = NSCache<AnyObject, UIImage>()
    //判斷圖片 url 是否相同
    var url: URL?
    
    func loadingImage(url: URL){
        self.url = url
        //如果 cache，不網路請求
        if let cachedImage = CustomImageView.cache.object(forKey: self.url as AnyObject) {
            self.image = cachedImage
            print("You get image from cache")
        }else{
            //如果沒有 cache，網路請求
            URLSession.shared.dataTask(with: url){(data,response,error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        //判斷式
                        if url == self.url {
                            let cachedImage = UIImage(data: data)
                            self.image = cachedImage
                            CustomImageView.cache.setObject(cachedImage!, forKey: url as AnyObject)
                            print("You get image from \(url)")
                        }else{
                            print("錯誤 ImageURL")
                        }
                    }
                    
                }
            }.resume()
            
        }
    }

}
