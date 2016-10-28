//
//  PhotoViewController.swift
//  MiniFacebook
//
//  Created by Sang Hyuk Cho on 10/20/16.
//  Copyright © 2016 sang. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

	@IBOutlet weak var photoTableView: UITableView!
	
	let photoCellIdentifier = "PhotoCell"
	let defaultPhotoFrameWidth: CGFloat = UIScreen.mainScreen().bounds.width
	var photoNameList: [String] = ["sample1", "sample2", "sample3"]
	var photoImageList: [UIImage] = []
	
	var selectedImageView: UIImageView?
	var selectedImageViewYCoord: CGFloat = 0
	let floatingImageView = UIImageView()
	let backgroundView = UIView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("viewdidload")
        // Do any additional setup after loading the view.
		self.loadImages()
		
		self.photoTableView.dataSource = self
		self.photoTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Load Images
	func loadImages(){
		for i in 0..<(self.photoNameList.count){
			self.photoImageList.append(UIImage(named: self.photoNameList[i])!)
		}
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		print("numofsections")
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("numrowsinsection")
		return self.photoImageList.count;
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		print("cellforrowatindex")
		let cell = tableView.dequeueReusableCellWithIdentifier(photoCellIdentifier) as? PhotoTableViewCell
		cell?.photoImageString = photoNameList[indexPath.row]
		cell?.photoViewController = self
		
		return cell!
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 300
	}
	
	func floatImage(selectedImageView: UIImageView){
		// Save a reference to the selectedImageView to use in unfloatImage()
		self.selectedImageView = selectedImageView
		
		// Get the frame of the selected image in superview's coordinate system
		if let imageFrame = self.selectedImageView?.superview?.convertRect(self.selectedImageView!.frame, toView: nil){
			
			// Set attributes for background view
			self.backgroundView.frame = self.view.frame
			self.backgroundView.backgroundColor = UIColor.blackColor()
			self.backgroundView.alpha = 0
			self.view.addSubview(backgroundView)
			
			// Set attributes for floatingImageView
			self.floatingImageView.frame = imageFrame
			self.floatingImageView.image = self.selectedImageView!.image
			self.floatingImageView.contentMode = self.selectedImageView!.contentMode
			self.floatingImageView.clipsToBounds = true
			self.floatingImageView.userInteractionEnabled = true
			self.view.addSubview(floatingImageView)
			
			// Add GestureRecognizer to return to the screen, Tap and Pan
			self.floatingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhotoViewController.unfloatImage)))
			self.floatingImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PhotoViewController.panImage(_:))))
			
			// Move to the center of the screen, full screen mode
			UIView.animateWithDuration(0.7) {
				// Dim the background
				self.selectedImageView?.alpha = 0
				self.backgroundView.alpha = 1
				
				// Calculate new image size based on the actual image size and screen width
				let floatingImageSize = self.floatingImageView.image?.size
				
				// Landscape mode image width < height
				if(self.view.frame.height < self.view.frame.width && floatingImageSize?.width < floatingImageSize?.height){
					let newWidth = (floatingImageSize!.width / floatingImageSize!.height) * self.view.frame.height
					let newX = self.view.frame.width/2 - newWidth/2
					self.floatingImageView.frame = CGRectMake(newX, 0, newWidth, self.view.frame.height)
					self.selectedImageViewYCoord = 0
				}// Portrait mode all types + landscape mode image height < width
				else{
					let newHeight = (self.view.frame.width / floatingImageSize!.width) * floatingImageSize!.height
					let newY = self.view.frame.height/2 - newHeight/2
					self.floatingImageView.frame = CGRectMake(0, newY, self.view.frame.width, newHeight)
					self.selectedImageViewYCoord = newY
				}
				
			}
		}
	}
	func unfloatImage(){
		// Get the frame of the selected image in superview's coordinate system
		if let imageFrame = self.selectedImageView?.superview?.convertRect(self.selectedImageView!.frame, toView: nil){

			// Move back to where the ImageView was, then remove the floating background and imageview
			UIView.animateWithDuration(0.7, animations: {
				self.selectedImageView?.alpha = 1
				self.backgroundView.alpha = 0
				self.floatingImageView.frame = imageFrame
			}, completion: { (animationCompleted) in
				self.backgroundView.removeFromSuperview()
				self.floatingImageView.removeFromSuperview()
			})
			
		}
	}
	func restoreFloatingImage(){
		UIView.animateWithDuration(0.7) {
			self.backgroundView.alpha = 1
			self.floatingImageView.frame.origin.y = self.selectedImageViewYCoord
		}
	}
	
	func panImage(pan: UIPanGestureRecognizer){
		let translation = pan.translationInView(self.view)
		
		switch pan.state{
		case .Began:
			break
		case .Changed:
			// Let image follow the vertical finger movement
			self.floatingImageView.frame.origin.y = self.selectedImageViewYCoord + translation.y
			self.backgroundView.alpha = ((200-abs(translation.y))/100)
		case.Cancelled:
			// Restore the image back to its original position
			self.restoreFloatingImage()
		case .Ended:
			// If "panned away" enough, remove the floatingImageView
			if(abs(translation.y) > 120){
				self.unfloatImage()
			}// Restore the image back to its original position
			else{
				self.restoreFloatingImage()
			}
		default:
			break
		}
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
