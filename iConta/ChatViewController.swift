//
//  ChatViewController.swift
//  iConta
//
//  Created by Irvin Hernandez on 26/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let ref = Firebase(url: "https://icontachatasesorvitualgt.firebaseio.com/Message")
    
    var messages: [JSQMessage] = []
    var objets: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var withUser: BackendlessUser?
    var recent: NSDictionary?
    
    var chatRoomID: String?
    
    var initialLoadComplete: Bool = false
    
    let outgoinBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = currentUser.objectId
        self.senderDisplayName = currentUser.name
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        // Load firebase messages
        loadmessage()
        
        self.inputToolbar?.contentView?.textView?.placeHolder = "Nuevo Mensaje"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: JSQMessages dataSource Funtions
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as!
            JSQMessagesCollectionViewCell
        
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            cell.textView?.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }
        
        return cell
        
        
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messages[indexPath.row]
        
        return data
        
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
        
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            return outgoinBubble
        } else {
            return incomingBubble
        }
        
    }
    
    //JSQMessages delegate funtions
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if text != "" {
        
            sendMessage(text, date: date, picture: nil, location: nil)
            
            
        }
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Tomar Foto", style: .Default) {
            (alert: UIAlertAction!) -> Void in
           Camera.PresentPhotoCamera(self, canEdit: true)
            
        }
        let sharePhoto = UIAlertAction(title: "Libreria de Fotos", style: .Default) { (alert: UIAlertAction!) ->
            Void in
            Camera.PresentPhotoLibrary(self, canEdit: true)
            
        }
        let shareLocation = UIAlertAction(title: "Compartir Ubicación", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            
            if self.haveAccessToLocation() {
                 self.sendMessage(nil, date: NSDate(), picture: nil, location: "location")
            }
        
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
        
        
    }

    // MARK: Send Message
    
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        var outgoingMessage = OutgoingMessage?()
        
        
        
        //if Text message
        if let text = text {
            outgoingMessage = OutgoingMessage(message: text, senderId: currentUser.objectId, senderName: currentUser.name!, date: date, status: "Entregado", type: "text")
            
            
        }
        //Send picture message
        if let pic = picture {
            let imageData = UIImageJPEGRepresentation(pic, 1.0)
            
            outgoingMessage = OutgoingMessage(message: "Foto", pictureData: imageData!, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Entregado", type: "picture")
            
            
            //send picture message
            
        }
        
        if let loc = location {
            
            let lat: NSNumber = NSNumber(double: (appDelegate.coordinate?.latitude)!)
            let lng: NSNumber = NSNumber(double: (appDelegate.coordinate?.longitude)!)
            
            outgoingMessage = OutgoingMessage(message: "Ubicación", latitude: lat, longitude: lng, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Entregado", type: "location")
            
        }
        
            // Play message sent sound
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        outgoingMessage!.sendMessage(chatRoomID!, item: outgoingMessage!.messageDictionary)
        
    }
    
    // MARK: Load messages
    
    
    func loadmessage() {
        
        ref.childByAppendingPath(chatRoomID).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            //get dictionaries
            //create JSQ message
            
            self.insertMessages()
            self.finishReceivingMessageAnimated(true)
            self.initialLoadComplete = true
            
            
            
        })
        
        ref.childByAppendingPath(chatRoomID).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            if snapshot.exists() {
                let item = (snapshot.value as? NSDictionary)!
                
                if self.initialLoadComplete {
                    let incoming = self.insertMessage(item)
                    
                    if incoming {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    
                    self.finishReceivingMessageAnimated(true)
                    
                    
                } else {
                        //add each dictionary to load array
                    self.loaded.append(item)
                    
                }
            }
            
        })
        
        ref.childByAppendingPath(chatRoomID).observeEventType(.ChildChanged, withBlock: {
            snapshot in
            
            //update message
            
        })
        ref.childByAppendingPath(chatRoomID).observeEventType(.ChildRemoved, withBlock: {
            snapshot in
            
            //deleted message
        
        })
        
    }
    
    func insertMessages() {
        for item in loaded {
            //create message
            insertMessage(item)
        }
    }
    
    func insertMessage(item: NSDictionary) -> Bool {
        
       let incomingMessage = IncomingMessage(collectionView_: self.collectionView!)
        
        let message = incomingMessage.createMessage(item)
        
        objets.append(item)
        messages.append(message!)
        
        
       return incoming(item)
        
    }
    
    func incoming(item: NSDictionary) -> Bool {
        
        if self.senderId == item["senderId"] as! String {
            return false
        } else {
            return true
        }
        
    }
    
    func outgoing(item: NSDictionary) -> Bool {
        if self.senderId == item["senderId"] as! String {
            return true
        } else {
            return false
            
        }
        
    }
    
    // MARK: HELPER FUNCTIONS
    
    func haveAccessToLocation() -> Bool {
        if let _ = appDelegate.coordinate?.latitude {
            return true
        } else {
            return false
        }
    }
    
    //MARK: JSQDELEGATE FUNTIONS
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        
        let object = objets[indexPath.row]
        
        if object["type"] as! String == "picture" {
            let message = messages[indexPath.row]
            
            let mediaItem = message.media as! JSQPhotoMediaItem
            
            let photos = IDMPhoto.photosWithImages([mediaItem.image])
            let browser = IDMPhotoBrowser(photos: photos)
            
            self.presentViewController(browser, animated: true, completion: nil)
            
            
        }
        
        if object["type"] as! String == "location" {
            self.performSegueWithIdentifier("chatToMapSeg", sender: indexPath)
        }
    }
    
    
    
    
    //MARK: UIImagePickerController funtions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let picture = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.sendMessage(nil, date: NSDate(), picture: picture, location: nil)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: NAvigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "chatToMapSeg" {
            
            let indexPath = sender as! NSIndexPath
            let message = messages[indexPath.row]
            
            let mediaItem = message.media as! JSQLocationMediaItem
            
            let mapView = segue.destinationViewController as! MapViewController
            mapView.location = mediaItem.location
            
            
        }
        
        
    }
    
    
    
    
    
}
