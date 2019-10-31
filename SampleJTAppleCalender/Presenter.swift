//
//  Presenter.swift
//  SampleJTAppleCalender
//
//  Created by Shunsuke Igusa on 2019/10/31.
//  Copyright © 2019 Shunsuke Igusa. All rights reserved.
//

import Foundation

class Presenter {
    
    let today: Date!
    let start: Date!
    let end: Date!
    let calendarRange: ClosedRange<Date>!
    var didChangeFocusedDateHandler: ((Date) -> Void)?
    
    var focusedMonth: Date = Date().startOfMonth {
        didSet {
            let sanitized = focusedMonth.startOfMonth
            if oldValue != sanitized {
                focusedMonth = sanitized
                didChangeFocusedDateHandler?(focusedMonth)
            }
        }
    }
    
    init() {
        today = Date()
        start = Date.calendar.date(byAdding: .month, value: -12, to: today)!.startOfMonth
        end = Date.calendar.date(byAdding: .month, value: 13, to: today)!.startOfMonth.addingTimeInterval(-1)
        calendarRange = start...end
    }
    
    private var cachedCellViewModels: [Date: MonthlyCell.Cache] = [:]

    func clearCellViewModels(at dates: Set<Date>) {
        for date in dates {
            cachedCellViewModels.removeValue(forKey: date)
        }
    }

    func clearAllCellViewModels() {
        cachedCellViewModels.removeAll()
    }

    func storeCellViewModel(_ cache: MonthlyCell.Cache) {
        let key = cache.cellState.date
        cachedCellViewModels[key] = cache
    }

    func fetchCellViewModel(at date: Date) -> MonthlyCell.Cache? {
        return cachedCellViewModels[date]
    }
}
