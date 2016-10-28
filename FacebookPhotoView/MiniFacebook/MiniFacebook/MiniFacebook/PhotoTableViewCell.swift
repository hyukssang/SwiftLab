//
//  PhotoTableViewCell.swift
//  MiniFacebook
//
//  Created by Sang Hyuk Cho on 10/20/16.
//  Copyright © 2016 sang. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
	
	@IBOutlet weak var photoImageView: UIImageView?{
		didSet{
			photoImageView?.contentMode = .ScaleAspectFill
			photoImageView?.clipsToBounds = true
			photoImageView?.userInteractionEnabled = true
		}
	}
	var photoImageString: String?{
		didSet{
			self.photoImageView?.image = UIImage(named: photoImageString!)
		}
	}
	var photoViewController: PhotoViewController?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		setupViews()
		
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setupViews(){
		photoImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhotoTableViewCell.floatImage)))
	}
	
	func floatImage(){
		photoViewController?.floatImage(self.photoImageView!)
	}
	
}
