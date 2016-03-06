//
//  profileCollectionViewCell.swift
//  Instagram
//
//  Created by Difan Chen on 3/5/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import Parse

class profileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var post: PFObject! {
        didSet {
            let media = post.objectForKey("media") as! PFFile
            media.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.postImageView.image = UIImage(data: data)
                } else {
                    print(error?.localizedDescription)
                }
            })
        }
    }
}
