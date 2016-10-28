//
//  ViewController.swift
//  pinterestStyleButton
//
//  Created by Sang Hyuk Cho on 10/27/16.
//  Copyright © 2016 sang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let buttonSquareSize: CGFloat = 64
	var carrotGestureRecognizer = UITapGestureRecognizer()
	
	@IBOutlet weak var carrotButton: UIButton!{
		didSet{
			self.carrotButton.setTitle("", forState: .Normal)
			self.carrotButton.tintColor = UIColor.blackColor()
			self.carrotButton.setImage(UIImage(named: "icon_carrot"), forState: .Normal)
			self.carrotGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleCarrotButton))
			self.carrotButton.addGestureRecognizer(self.carrotGestureRecognizer)
		}
	}
	let topButton = UIButton()
	let leftButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.setupViews()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupViews(){
		
	}
	func toggleCarrotButton(){
		topButton.frame = CGRectMake(self.carrotButton.frame.origin.x, self.carrotButton.frame.origin.y, self.buttonSquareSize, self.buttonSquareSize)
		topButton.setImage(UIImage(named: "icon_add"), forState: .Normal)
		topButton.alpha = 0
		self.view.addSubview(topButton)
		
		leftButton.frame = CGRectMake(self.carrotButton.frame.origin.x, self.carrotButton.frame.origin.y, self.buttonSquareSize, self.buttonSquareSize)
		leftButton.setImage(UIImage(named: "icon_delete"), forState: .Normal)
		leftButton.alpha = 0
		self.view.addSubview(leftButton)
		
		UIView.animateWithDuration(0.5, animations: {
			let topX = self.carrotButton.frame.origin.x
			let topY = self.carrotButton.frame.origin.y - self.buttonSquareSize - 8
			self.topButton.frame.origin = CGPoint(x: topX, y: topY)
			self.topButton.alpha = 1
			
			let leftX = self.carrotButton.frame.origin.x - self.buttonSquareSize - 8
			let leftY = self.carrotButton.frame.origin.y
			
			self.leftButton.frame.origin = CGPoint(x: leftX, y: leftY)
			self.leftButton.alpha = 1
		})
		
		self.carrotButton.removeGestureRecognizer(self.carrotGestureRecognizer)
		self.carrotGestureRecognizer = UITapGestureRecognizer(target: self, action: "untoggleCarrotButton")
		self.carrotButton.addGestureRecognizer(self.carrotGestureRecognizer)
	}
	func untoggleCarrotButton(){
		UIView.animateWithDuration(0.5, animations: {
			self.topButton.frame.origin.y = self.carrotButton.frame.origin.y
			self.topButton.alpha = 0
			
			self.leftButton.frame.origin.x = self.carrotButton.frame.origin.x
			self.leftButton.alpha = 0
		}) { (animationCompleted) in
			self.topButton.removeFromSuperview()
			self.leftButton.removeFromSuperview()
			
			self.carrotButton.removeGestureRecognizer(self.carrotGestureRecognizer)
			self.carrotGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleCarrotButton")
			self.carrotButton.addGestureRecognizer(self.carrotGestureRecognizer)
		}
	}
}

