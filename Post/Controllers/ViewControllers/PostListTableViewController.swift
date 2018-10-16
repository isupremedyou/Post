//
//  PostListTableViewController.swift
//  Post
//
//  Created by Travis Chapman on 10/15/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = CGFloat(integerLiteral: 44)
        tableView.rowHeight = UITableView.automaticDimension
        
        PostController.fetchPosts(completion: { (fetchedPosts) in
            self.posts = fetchedPosts
            self.reloadTableView()
        })
    }
    
    // MARK: - Actions
    
    @IBAction func refreshControlPulled(_ sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.fetchPosts { (fetchedPosts) in
            self.posts = fetchedPosts
            self.reloadTableView()
        }
    }
}

// MARK: - Class Functions

extension PostListTableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username), \(post.timestamp). \(indexPath.row)"
        
        return cell
    }
    
    // MARK: - Other Functions
    
    func reloadTableView() {
        let queue = DispatchQueue.main
        queue.sync {
            tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
