//
//  ViewModel.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import Foundation

// Observable
class Observable<T> {
    var value: T? {
        didSet {
            listener.forEach{
                $0(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private var listener: [((T?)-> Void)] = []
    
    func bind(_ listener: @escaping ((T?)-> Void)) {
        listener(value)
        self.listener.append(listener)
    }
}


struct PostViewModel {
    var posts: [Observable<PostTest>] = []
}
