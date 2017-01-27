//
//  MonthlyCalendar.swift
//  RCCalendarView
//
//  Created by Sang Hyuk Cho on 1/27/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation

struct MonthlyCalendar{
	var dates: [Date?] = []
	var numEmptyCellsFront: Int = 0
	var numEmptyCellsBack: Int = 0
	var numCellsNeeded: Int{
		get{
			return self.numEmptyCellsFront + self.dates.count + self.numEmptyCellsBack
		}
	}
	var numWeeks: Int{
		get{
			return self.numCellsNeeded/7
		}
	}
}
