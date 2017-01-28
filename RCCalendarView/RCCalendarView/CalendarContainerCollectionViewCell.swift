//
//  CalendarContainerCollectionViewCell.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/25/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class CalendarContainerCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	static let cellID = "calendarContainerCell"
	
	let NUM_DAYS = 7
	let WEEKDAYS: [String] = ["S", "M", "T", "W", "T", "F", "S"]
	
	let monthLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Futura", size: 17)
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var monthlyCalendarCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor.white
		collectionView.isScrollEnabled = false
		
		collectionView.setCollectionViewLayout(layout, animated: true)
		collectionView.register(MonthlyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: MonthlyCalendarCollectionViewCell.cellID)
		collectionView.dataSource = self
		collectionView.delegate = self
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
	
	func setupViews(){
		self.contentView.addSubview(self.monthLabel)
		self.contentView.addSubview(self.monthlyCalendarCollectionView)
	}
	func setupConstraints(){
		self.monthLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
		self.monthLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
		
		self.monthlyCalendarCollectionView.topAnchor.constraint(equalTo: self.monthLabel.bottomAnchor, constant: 20).isActive = true
		self.monthlyCalendarCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		self.monthlyCalendarCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
		self.monthlyCalendarCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let numCells = self.monthlyCalendar?.numCellsNeeded{
			return NUM_DAYS + numCells
		}
		return 0
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCollectionViewCell.cellID, for: indexPath) as? MonthlyCalendarCollectionViewCell

		if let month = self.monthlyCalendar{
			switch indexPath.row{
			case 0..<NUM_DAYS:
				cell?.dayLabel.text = "\(WEEKDAYS[indexPath.row])"
				cell?.colorLabel(with: UIColor.gray)
			case NUM_DAYS + month.numEmptyCellsFront ..< (NUM_DAYS + month.numEmptyCellsFront + month.dates.count):
				let offset = NUM_DAYS + month.numEmptyCellsFront
				let newIndex = indexPath.row - offset
				let date = month.dates[newIndex]
				let day = Calendar.current.dateComponents([.day], from: date!).day!
				cell?.dayLabel.text = "\(day)"
				cell?.colorLabel(with: UIColor.black)
			default:
				cell?.dayLabel.text = ""
			}
		}

		return cell!
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numColumns: CGFloat = 7
		let cellWidth: CGFloat = self.frame.width/numColumns
		let numRows: CGFloat = 7
		let cellHeight: CGFloat = self.frame.height/numRows
		
		return CGSize(width: cellWidth, height: cellHeight)
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
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM"
		let formattedDate = dateFormatter.string(from: date)
		self.monthLabel.text = formattedDate
		
		self.monthlyCalendarCollectionView.reloadData()
	}
}
