//
//  ViewController.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/17/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

extension Date{
	func startOfMonth()->Date{
		let currentMonthComponents = Calendar.current.dateComponents([.year, .month], from: self)
		return Calendar.current.date(from: currentMonthComponents)!
	}
	func endOfMonth()->Date{
		return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
	}
	mutating func toNextMonth(){
		self = Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
	}
	mutating func toPrevMonth(){
		self = Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
	}
}
extension DateComponents{
	func getWeekday()->String?{
		if let weekday = self.weekday{
			switch weekday{
			case 1:
				return "Sunday"
			case 2:
				return "Monday"
			case 3:
				return "Tuesday"
			case 4:
				return "Wednesday"
			case 5:
				return "Thursday"
			case 6:
				return "Friday"
			case 7:
				return "Saturday"
			default:
				break
			}
		}
		return nil
	}
}



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	lazy var calendarCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.setCollectionViewLayout(layout, animated: true)
		collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCell")
		collectionView.dataSource = self
		collectionView.delegate = self
//		collectionView.isPagingEnabled = true
		collectionView.backgroundColor = UIColor.blue
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	var datesInMonths: [Date] = []
	let numMonthsToDisplay: Int = 5
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		print("viewdidload")
		self.initDateInStartingMonth()
		self.setupViews()
		self.setupConstraints()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupViews(){
		self.view.addSubview(self.calendarCollectionView)
	}
	func setupConstraints(){
		self.calendarCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		self.calendarCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		self.calendarCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.calendarCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("collview")
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.datesInMonths.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCollectionViewCell
		
		let date = self.datesInMonths[indexPath.row]
		cell?.initCalendar(date: date)
		
		return cell!
	}
	
	func initDateInStartingMonth(){
		let currentDate = Date()
		for i in -2...2{
			let date = Calendar.current.date(byAdding: DateComponents(month: i), to: currentDate)!
			self.datesInMonths.append(date)
		}
	}
}

