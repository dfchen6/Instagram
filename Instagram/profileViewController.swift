//
//  profileViewController.swift
//  Instagram
//
//  Created by Difan Chen on 2/29/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import Parse

class profileViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UICollectionViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postNumLabel: UILabel!
    
    
    var posts: [PFObject] = []
    var user: PFUser! = PFUser.currentUser()
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImageTapped = UITapGestureRecognizer(target: self, action: "changeProfile:")
        profileImageTapped.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(profileImageTapped)
        profileImageView.userInteractionEnabled = true
        
        nameLabel.text = user.username
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func changeProfile (sender: UITapGestureRecognizer!) {
        print("change profile begin!")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let profileImage = resize(editedImage, percentage: 0.2)
            profileImageView.image = profileImage
            // update to database
            UserMedia.postUserProfileImage(profileImage) { (flag: Bool, error: NSError?) -> Void in
                if (error == nil) {
                    self.profileImageView.image = profileImage
                    print("upload profile image successfully")
                } else {
                    print(error?.localizedDescription)
                }
            }
            self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
        print("user logout")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    func fetchPosts() {
        let query = PFQuery(className: "UserMedia")
        query.whereKey("author", equalTo: user)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                print(objects)
                print(self.user)
                self.posts = objects
                self.collectionView.reloadData()
                self.postNumLabel.text = String(self.posts.count)
            } else {
                print(error?.localizedDescription)
            }
        }
        // check if profile exists
        if user!.objectForKey("profilePhoto") != nil {
            let profileMedia = user!["profilePhoto"]
            profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    self.profileImageView.image = image
                }
            }
        } else {
            profileImageView.image = UIImage(named: "profile")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int
        ) -> Int {
            return posts.count
    }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "PostCell",
                forIndexPath: indexPath
                ) as! profileCollectionViewCell
            
            cell.post = posts[indexPath.row]
            
            return cell
    }
    
    func resize(image: UIImage, percentage: Float32) -> UIImage {
        let width = (Int) (percentage * Float(image.size.width))
        let height = (Int) (percentage * Float(image.size.height))
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
