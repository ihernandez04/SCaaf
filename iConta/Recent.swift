//
//  Recent.swift
//  iConta
//
//  Created by Irvin Hernandez on 25/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import Foundation

//--------Constants--------\\
public let kAVATARSTATE = "AvatarState"
public let kFIRSTRUN = "firstRun"
//-----------\\


let firebase = Firebase(url: "https://icontachatasesorvitualgt.firebaseio.com/")
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser


//MARK: Create Chatroom

func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String {
    
    //user 1 is current user
    let userId1: String = user1.objectId
    let userId2: String = user2.objectId
    
    var chatRoomId: String = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1.stringByAppendingString(userId2)
    } else {
        chatRoomId = userId2.stringByAppendingString(userId1)
    }
    
    let members = [userId1, userId2]
    
    //MARK: Create recent
    createRecent(userId1, chatRoomID: chatRoomId, members: members, withUserUsername: user2.name!, withUseruserId: userId2)
    createRecent(userId2, chatRoomID: chatRoomId, members: members, withUserUsername: user1.name!, withUseruserId: userId1)
    
    
    
    return chatRoomId
    
    
    
}

//MARK: Create recentItem
func createRecent(userId: String,chatRoomID: String, members: [String],withUserUsername: String,withUseruserId: String) {
    
    firebase.childByAppendingPath("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        
        var createRecent = true
        
        //check if we have a result
        if snapshot.exists() {
            for recent in snapshot.value.allValues {
                if recent["userId"] as! String == userId {
                    
                }
            }
        }
        
        if createRecent {
           CreateRecentItem(userId, chatRoomID: chatRoomID, members: members, withUserUsername: withUserUsername, withUserUserId: withUseruserId)
            
        }
        
        
    })
    
    
    
}

func CreateRecentItem(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserId: String) {
    let ref = firebase.childByAppendingPath("Recent").childByAutoId()
    
    let recentId = ref.key
    let date = dateFormatter().stringFromDate(NSDate())
    
    let recent = ["recentId" : recentId, "userId" : userId, "chatRoomID" : chatRoomID, "members" : members, "withUserUsername" : withUserUsername, "lastMessage" : "", "counter" : 0, "date" : date, "withUserUserId" : withUserUserId]
    
    //save to firebase
    ref.setValue(recent) { (error, ref) -> Void in
        if error != nil {
            print("Error generado\(error)")
        }
    }
    
}

//MARK: Update Recent

func UpdateRecents(chatRoomID: String, lastMessage: String) {
    firebase.childByAppendingPath("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        
        if snapshot .exists() {
            for recent in snapshot.value.allValues {
                UpdateRecentItem(recent as! NSDictionary, lastMessage: lastMessage)
            }
        }
        
    })
    
}


func UpdateRecentItem(recent: NSDictionary, lastMessage: String) {
    let date = dateFormatter().stringFromDate(NSDate())
    
    var counter = recent["counter"] as! Int
    
    if recent["userId"] as? String != currentUser.objectId {
        counter++
    }
    
    let values = ["lastMessage" : lastMessage, "counter" : counter, "date" : date]
    firebase.childByAppendingPath("Recent").childByAppendingPath(recent["recentId"] as? String).updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: {
      (error, ref) -> Void in
        
        if error != nil {
            print("Error no se pudo actualizar item reciente")
        }
        
        
        
        
    })
    
    
}


//MARK: Restart recent chat
func RestarRecentChat(recent: NSDictionary) {
    for userId in recent["members"] as! [String] {
        if userId != currentUser.objectId {
            
            createRecent(userId, chatRoomID: (recent["chatRoomID"] as? String)!, members: recent["members"] as! [String], withUserUsername: currentUser.name, withUseruserId: currentUser.objectId)
            
        }
    }
    
}





//MARK: Delete recent funtions

func DeleteRecentItem(recent: NSDictionary) {
    firebase.childByAppendingPath("Recent").childByAppendingPath(recent["recentId"] as? String).removeValueWithCompletionBlock { (error, ref) -> Void in
        if error != nil {
            print("Error al borrar: \(error)")
        }
    }
}






//MARK: Helper funtions

private let dateFormat = "yyyyMMddHHmmss"


func dateFormatter() -> NSDateFormatter{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
    
}