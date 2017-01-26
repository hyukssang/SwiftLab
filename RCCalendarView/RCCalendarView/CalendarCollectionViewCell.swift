//
//  CalendarCollectionViewCell.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/25/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

struct MonthlyCalendar{
	var dates: [Date?] = []
	var numEmptyCellsFront: Int = 0
	var numEmptyCellsBack: Int = 0
	var numCellsNeeded: Int{
		get{
			return self.numEmptyCellsFront + self.dates.count + self.numEmptyCellsBack
		}
	}
}

class MonthlyCalendarCollectionViewCell: UICollectionViewCell{
	let dayLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupViews()
		self.setupConstraints()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupViews()
		self.setupConstraints()
	}
	
	func setupViews(){
		self.contentView.addSubview(self.dayLabel)
	}
	func setupConstraints(){
		self.dayLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
		self.dayLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
	}
}

class CalendarCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
	
	lazy var monthlyCalendarCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.setCollectionViewLayout(layout, animated: true)
		collectionView.register(MonthlyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyCalendarCell")
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.backgroundColor = UIColor.red
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		return collectionView
	}()
	
	var monthlyCalendar: MonthlyCalendar?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupViews()
		self.setupConstraints()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupViews()
		self.setupConstraints()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let numCells = self.monthlyCalendar?.numCellsNeeded{
			print(numCells)
			return numCells
		}
		return 0
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyCalendarCell", for: indexPath) as? MonthlyCalendarCollectionViewCell

		if let month = self.monthlyCalendar{
			switch indexPath.row{
			case month.numEmptyCellsFront ..< (month.numEmptyCellsFront + month.dates.count):
				let adjustedIndex = indexPath.row - month.numEmptyCellsFront
				let date = month.dates[adjustedIndex]
				let day = Calendar.current.dateComponents([.day], from: date!).day!
				cell?.backgroundColor = UIColor.gray
				cell?.dayLabel.text = "\(day)"
			default:
				cell?.dayLabel.text = ""
			}
		}
		
		
		return cell!
	}
	
	func setupViews(){
		self.contentView.addSubview(self.monthlyCalendarCollectionView)
	}
	func setupConstraints(){
		self.monthlyCalendarCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
		self.monthlyCalendarCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		self.monthlyCalendarCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
		self.monthlyCalendarCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
	}
	
	func initCalendar(date: Date){
		self.monthlyCalendar = MonthlyCalendar()
		
		let startDate = date.startOfMonth()
		let startDateComponents = Calendar.current.dateComponents([.weekday], from: startDate)
		
		let endDate = date.endOfMonth()
		let endDateComponents = Calendar.current.dateComponents([.day, .weekday], from: endDate)
		
		if let startDateWeekday = startDateComponents.weekday, let endDateWeekday = endDateComponents.weekday{
			self.monthlyCalendar?.numEmptyCellsFront = startDateWeekday - 1
			self.monthlyCalendar?.numEmptyCellsBack = 7 - endDateWeekday
		}
		
		if let days = endDateComponents.day{
			for i in 0..<days{
				let date = Calendar.current.date(byAdding: DateComponents(day: i), to: startDate)
				self.monthlyCalendar?.dates.append(date)
			}
		}
		
		self.monthlyCalendarCollectionView.reloadData()
	}
}
