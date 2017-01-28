//
//  ViewController.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/17/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
	
	@IBOutlet weak var calendarView: CalendarView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		self.calendarView.showCurrentMonth()
	}
}

