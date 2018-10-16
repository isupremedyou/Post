//
//  Post.swift
//  Post
//
//  Created by Travis Chapman on 10/15/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation

struct Post {
    
    let username: String
    let text: String
    let timestamp : TimeInterval
    
    init(username: String, text: String, timestamp: Date = Date()) {
        
        self.username = username
        self.text = text
        self.timestamp = timestamp.timeIntervalSince1970
    }
}

extension Post : Codable { }
