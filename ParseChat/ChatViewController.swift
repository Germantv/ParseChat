//
//  ChatViewController.swift
//  ParseChat
//
//  Created by German Flores on 2/28/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var messages: [PFObject] = []
    var timer: Timer?
    let cellSpacingHeight: CGFloat = 10
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        self.navigationController?.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            let window :UIWindow? = UIApplication.shared.keyWindow
            window?.rootViewController = loginViewController
            self.timer?.invalidate()
        })
    }
    @IBAction func sendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.separatorStyle = .none
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        chatTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        chatTableView.estimatedRowHeight = 50
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
        getMessages()
        
    }
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                self.messages = messages
                print(self.messages)
                self.chatTableView.reloadData()
            } else {
                print("Error from chat view controller trying to get messages in fetchMessages() function with localized description \"\(error!.localizedDescription)\"")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.section]
        cell.chatMsg.text = message["text"] as? String
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.userName.text = user.username
        } else {
            // No user found, set default username
            cell.userName.text = "💩"
        }
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
