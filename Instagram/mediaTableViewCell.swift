//
//  mediaTableViewCell.swift
//  Instagram
//
//  Created by Difan Chen on 3/1/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class mediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userMedia: UserMedia! {
        didSet {
            print(userMedia.author)
            var userName = userMedia.author?["username"] as? String
            if let userName = userName {
                userNameLabel.text = userName
            }
            captionLabel.text = userMedia.caption
            //mediaImageView.image = userMedia.media
            let mediaPFFile = userMedia.mediaPFFile
            mediaPFFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    self.mediaImageView.image = image
                }
            }
            timeStampLabel.text = userMedia.timeElapsed()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
