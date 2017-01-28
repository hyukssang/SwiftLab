//
//  CalendarView.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/26/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
import UIKit

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	
	lazy var calendarContainerCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		
		let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.isPagingEnabled = true
		collectionView.backgroundColor = UIColor.white
		
		collectionView.register(CalendarContainerCollectionViewCell.self, forCellWithReuseIdentifier: CalendarContainerCollectionViewCell.cellID)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	var datesInMonths: [Date] = []
	let numMonthsToDisplay: Int = 5
	let defaultIndexPath = IndexPath(row: 2, section: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initDateInStartingMonth()
		self.setupViews()
		self.setupConstraints()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initDateInStartingMonth()
		self.setupViews()
		self.setupConstraints()
	}
	
	func initDateInStartingMonth(){
		let currentDate = Date()
		for i in -2...2{
			let date = Calendar.current.date(byAdding: DateComponents(month: i), to: currentDate)!
			self.datesInMonths.append(date)
		}
	}
	
	func setupViews(){
		self.isHidden = true
		self.addSubview(self.calendarContainerCollectionView)
	}
	func setupConstraints(){
		self.calendarContainerCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		self.calendarContainerCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		self.calendarContainerCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		self.calendarContainerCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.datesInMonths.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarContainerCollectionViewCell.cellID, for: indexPath) as? CalendarContainerCollectionViewCell
		
		let date = self.datesInMonths[indexPath.row]
		cell?.initCalendar(date: date)
		
		return cell!
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let monthLabelHeight: CGFloat = 20
		let monthLabelBottomMargin: CGFloat = 20
		// 16:10 Ratio cells
		let cellWidth: CGFloat = collectionView.frame.width
		let ratioComponentLength: CGFloat = cellWidth/16
		let cellHeight: CGFloat = ratioComponentLength * 10 + monthLabelHeight
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func showCurrentMonth(){
		self.calendarContainerCollectionView.scrollToItem(at: defaultIndexPath, at: .centeredHorizontally, animated: false)
		self.isHidden = false
	}
}
