//
//  TweetViewController.swift
//  Twitter
//
//  Created by Hamidou Wara Ballo on 3/3/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder() // Displays keyboard and cursor
        // Do any additional setup after loading the view.
        tweetTextView.delegate = self
        remainingCharsLabel.text = "0/280"
    }
    
    @IBOutlet weak var remainingCharsLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: {(error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
    }
    }
    
    
    @objc(textView:shouldChangeTextInRange:replacementText:) func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           let characterLimit = 280
           let newText = NSString(string: tweetTextView.text!).replacingCharacters(in: range, with: text)
           remainingCharsLabel.text = "\(tweetTextView.text.count) / \(characterLimit)"
           return newText.count <= characterLimit
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
