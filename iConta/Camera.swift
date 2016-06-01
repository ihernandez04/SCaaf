//
//  Camera.swift
//  iConta
//
//  Created by Irvin Hernandez on 3/04/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import Foundation
import MobileCoreServices


class Camera {
    
    class func PresentPhotoLibrary(target: ChatViewController, canEdit: Bool) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                
                if (availableTypes as NSArray).containsObject(type) {
                    
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                    
                }
                
            }
        
        } else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            imagePicker.sourceType = .SavedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum) {
                if (availableTypes as NSArray).containsObject(type) {
                    imagePicker.mediaTypes = [type]
                    
                }
                
            }
            
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = target
        target.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    class func PresentPhotoCamera(target: ChatViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return
        }
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
                
                if (availableTypes as NSArray).containsObject(type1) {
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                }
            }
        
            if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
             imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.Front) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
            
        } else {
            //Show Alert no camera
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = target
        target.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
}