//
//  cameraViewController.swift
//  Instagram
//
//  Created by Difan Chen on 2/29/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import Parse

class cameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var uploadImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let resizedImage = resize(originalImage, percentage: 0.5)
            uploadImage = resizedImage
            imageView.image = resizedImage
            self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func onUpload(sender: AnyObject) {
        let caption = captionTextField.text
        UserMedia.postUserImage(uploadImage, withCaption: caption) { (flag: Bool, error: NSError?) -> Void in
            if (error == nil) {
                print("upload image successfully")
                self.clearTextAndImage()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func clearTextAndImage() {
        self.imageView.image = nil
        self.captionTextField.text = ""
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}