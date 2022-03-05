//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Hamidou Wara Ballo on 2/27/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int! // Integer
    
    //Refreshes tweets
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets() // When view loads it also loads tweets
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged) // Needed for tweet refresh
        tableView.refreshControl = myRefreshControl // Telling the table which refresh control to use
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets() {
        
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet] // count parameter from API "Get Tweet Timelines" page
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in // Retrieves dictionaries which are tweets
            
            self.tweetArray.removeAll() // empties entire array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() // Makes sure everytime a call is made to the API the list is repopulated, reload data with content
            self.myRefreshControl.endRefreshing() // End tweet refresher
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
    }
    
    func loadMoreTweets(){
        
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in // Retrieves dictionaries which are tweets
            
            self.tweetArray.removeAll() // empties entire array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() // Makes sure everytime a call is made to the API the list is repopulated, reload data with content
            self.myRefreshControl.endRefreshing() // End tweet refresher
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
        
    }
    
    // Calls function everytime user gets to end of table
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:
        IndexPath) {
            if indexPath.row + 1 == tweetArray.count {
                loadMoreTweets()
            }
        }
    
    
    
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) // Action for logout button
        UserDefaults.standard.set(false, forKey: "userLoggedIn") 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell // Gives us access to labels and image view in tweet table view cell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary // Gets user data from API dictionary
        cell.userNameLabel.text = user["name"] as? String // Extracts name from the user data in the API dictionary
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String // Changes the tweet content in TweetCell
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!) // Retrieves image data from API
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        // Checks if current tweet if favorited or not
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    // MARK: - Table view data source
    
    // How many sections we want
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // How many rows per section we want
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
