//
//  DateExtension.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/26/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
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
