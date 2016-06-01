//
//  OutgoingMessage.swift
//  iConta
//
//  Created by Irvin Hernandez on 26/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import Foundation

class OutgoingMessage {
    
    
    private let firebase = Firebase(url: "https://icontachatasesorvitualgt.firebaseio.com/Message")
    
    let messageDictionary: NSMutableDictionary
    
    init (message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    init (message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "latitude", "longitude", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    init (message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        let pic = pictureData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "picture", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    func sendMessage(chatRoomID: String, item: NSMutableDictionary) {
        
        let reference = firebase.childByAppendingPath(chatRoomID).childByAutoId()
        
        item["messageId"] = reference.key
        
        reference.setValue(item) {
            (error, ref) -> Void in
            if error != nil {
                print("Error, no se pudo enviar mensaje")
            }
        }
        
        //Send push notification
        UpdateRecents(chatRoomID, lastMessage: (item["message"] as? String)!)
        
        
        
        
    }
    
    
    
    
    
    
}