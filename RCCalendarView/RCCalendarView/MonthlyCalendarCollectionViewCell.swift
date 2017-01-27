//
//  MonthlyCalendarCollectionViewCell.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/27/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
import UIKit

class MonthlyCalendarCollectionViewCell: UICollectionViewCell{
	
	static let cellID = "monthlyCalendarCell"
	
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
