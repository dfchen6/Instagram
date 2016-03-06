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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var uploadImage: UIImage!
    
    var gotImage = false
    var imageQuality = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Add tap image view responder
        let tapSelectImage = UITapGestureRecognizer(target: self, action: "tapSelect:")
        tapSelectImage.numberOfTapsRequired = 1
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapSelectImage)
        cameraOn()
    }
    
    func tapSelect(sender: UITapGestureRecognizer!) {
        gotImage = false
        print("tap image")
        cameraOn()
    }
    func updateImageView() {
        let resizedImage = resize(uploadImage, percentage: Float(imageQuality))
        imageView.image = resizedImage
    }
    
    @IBAction func ImageQualityChanged(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            imageQuality = 0.25
        case 1:
            imageQuality = 0.4
        case 2:
            imageQuality = 0.7
        default:
            break;
        }
        updateImageView()
    }
    
    func cameraOn() {
        if (gotImage) {
            return
        }
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
        gotImage = true

    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            uploadImage = editedImage
            imageView.image = editedImage
            self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func onUpload(sender: AnyObject) {
        let resizedImage = resize(uploadImage, percentage: Float(imageQuality))
        let caption = captionTextField.text
        UserMedia.postUserImage(resizedImage, withCaption: caption) { (flag: Bool, error: NSError?) -> Void in
            if (error == nil) {
                print("upload image successfully")
                self.clearTextAndImage()
            } else {
                print(error?.localizedDescription)
            }
        }
        gotImage = false
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