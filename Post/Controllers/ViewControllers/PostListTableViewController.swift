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
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        presentNewPostAlert()
    }
    
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
    
    func presentNewPostAlert() {
        
        let alert = UIAlertController(title: "Add A New Post", message: "Type your username and message and hit \"Post\" and we will send your message", preferredStyle: .alert)
        
        alert.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Your Username"
        }
        
        alert.addTextField { (messageTextField) in
            messageTextField.placeholder = "Your Message"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            
            guard let usernameTextField = alert.textFields?.first,
                let messageTextField = alert.textFields?.last,
                let username = usernameTextField.text,
                let text = messageTextField.text
                else { return }
            
            guard !username.isEmpty, !text.isEmpty else { self.presentErrorAlert() ; return}
            
            PostController.addNewPostWith(username: username, text: text, completion: { (updatedPosts) in
                guard let updatedPosts = updatedPosts else { return }
                self.posts = updatedPosts
                self.reloadTableView()
            })
        }

        alert.addAction(cancelAction)
        alert.addAction(postAction)
        
        present(alert, animated: true)
    }
    
    func presentErrorAlert() {
        let alert = UIAlertController(title: "Something Went Wrong", message: "Your submission was missing information - please try again!", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
    }
}
