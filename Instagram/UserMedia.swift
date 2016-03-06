//
//  UserMedia.swift
//  Instagram
//
//  Created by Difan Chen on 3/1/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    
    var author: PFUser?
    var createDate: NSDate?
    var media: UIImage?
    var mediaPFFile: PFFile?
    var caption: String?
    var commentsCounts: Int?
    var likesCount: Int?
    var profileImage: UIImage?
    
    init(object: PFObject) {
        super.init()
        author = object["author"] as? PFUser
        createDate = object.createdAt!
        caption = object["caption"] as? String
        commentsCounts = object["commentsCount"] as? Int
        likesCount = object["likesCount"] as? Int
        mediaPFFile = object["media"] as! PFFile
        if author!.objectForKey("profilePhoto") != nil {
            let profileMedia = author!["profilePhoto"]
            profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    self.profileImage = image
                }
            }
        } else {
            self.profileImage = UIImage(named: "profile")
        }
    }
    
    func timeElapsed() -> String {
        let timeElapsedInSeconds = createDate?.timeIntervalSinceNow
        let time = abs(NSInteger(timeElapsedInSeconds!))
        if (time > 24 * 60 * 24) {
            return String(time / (24 * 60 * 24)) + "d"
        } else if (time > 60 * 60) {
            return String(time / (60 * 60)) + "h"
        } else {
            return String(time / 60) + "m"
        }
    }
    
     /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func postUserProfileImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let user = PFUser.currentUser()!
        user["profilePhoto"] = getPFFileFromImage(image)
        user.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}