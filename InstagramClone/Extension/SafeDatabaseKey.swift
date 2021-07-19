//
//  SafeDatabaseKey.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/19.
//

import Foundation

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}
