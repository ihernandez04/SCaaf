//
//  RecentViewController.swift
//  iConta
//
//  Created by Irvin Hernandez on 25/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseUserDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    
    var recents: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadRecents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent)
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let recent = recents[indexPath.row]
        
        
        //create recent for both user2 users
        RestarRecentChat(recent)
        
        performSegueWithIdentifier("recentToChatSeg", sender: indexPath)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let recent = recents[indexPath.row]
        // remove recent from the array
        recents.removeAtIndex(indexPath.row)
        //delete recent from firebase
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    // MARK: IBActions
    
    @IBAction func StarNewChatBarButton(sender: AnyObject) {
        performSegueWithIdentifier("recentToChooseUserVC", sender: self)
    }

    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "recentToChooseUserVC" {
            
            let vc = segue.destinationViewController as! ChooseUserViewController
            vc.delegate = self
            
        }
        
        if segue.identifier == "recentToChatSeg" {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            
            let recent = recents[indexPath.row]
            
            //set chatVC recent to our recent.
            
            chatVC.recent = recent
            chatVC.chatRoomID = recent["chatRoomID"] as? String
            
            
        }
        
    }
    
    // MARK: ChooseUserDelegate
    
    func chreatChatroom(withUser: BackendlessUser) {
        
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)
        
        //set chatVC recent to our recent.
        
        chatVC.withUser = withUser
        chatVC.chatRoomID = startChat(currentUser, user2: withUser)
        
        
    }
    
    // MARK: Load recents from firebase
    
    func loadRecents() {
        
        firebase.childByAppendingPath("Recent").queryOrderedByChild("userId").queryEqualToValue(currentUser.objectId).observeEventType(.Value, withBlock: {
            snapshot in
            
            self.recents.removeAll()
            
            if snapshot.exists() {
                let sorted = (snapshot.value.allValues as
                    NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                
                for recent in sorted {
                    
                    self.recents.append(recent as! NSDictionary)
                    //add funtion to have offline access as well
                    /*
                    firebase.childByAppendingPath("Recent").queryOrderedByChild("chatroomID").queryEqualToValue(recent["chatroomID"]).observeEventType(.Value, withBlock: {
                        snapshot in
                    })*/
                    
                }
                
            }
            self.TableView.reloadData()
            
            
        })
        
    }
    
    
    
    
    
    
    
}
