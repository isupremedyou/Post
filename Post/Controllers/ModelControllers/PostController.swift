//
//  PostController.swift
//  Post
//
//  Created by Travis Chapman on 10/15/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    static func fetchPosts(completion: @escaping ([Post]) -> Void) {
        guard let baseURL = baseURL else { completion([]) ; return }
        
        let getterEndpoint = baseURL.appendingPathExtension("json")
        print(getterEndpoint)
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error retriving data from the server: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else { completion([]) ; return }
            let jd = JSONDecoder()
            
            do {
                let postsDictionary = try jd.decode([String : Post].self, from: data)
                var posts: [Post] = postsDictionary.compactMap({ (string, value) -> Post in
                    return value
                })
                
                posts = posts.reversed()
                
                completion(posts)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion([])
                return
            }
            
        }
        dataTask.resume()
    }
}
