//
//  ViewController.swift
//  SampleJTAppleCalender
//
//  Created by Shunsuke Igusa on 2019/10/31.
//  Copyright © 2019 Shunsuke Igusa. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    private var vc: SecondViewController!
    @IBOutlet private weak var fotterView: UIView!
    private var calendarRange: ClosedRange<Date>!
    private var presenter: Presenter = Presenter()
    @IBOutlet private weak var focusedMonth: UILabel!
    @IBOutlet private weak var focusedYear: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = SecondViewController.makeInstance()
        vc.didChangeSwitchStatusHandler = { isOn in
            self.fotterView.isHidden = !isOn
        }
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.backgroundColor = .white
        calendarView.scrollDirection = .vertical
        
        setup(date: presenter.focusedMonth)
        presenter.didChangeFocusedDateHandler = {[weak self] date in
            guard let self = self else { return }
            self.setup(date: date)
            self.scrollToDate(date, animated: false)
        }
    }
    
    private func setup(date: Date?) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "MM"
        focusedMonth.text = date.flatMap({ formatter.string(from: $0) })

        formatter.dateFormat = "yyyy\nMMMM"
        focusedYear.text = date.flatMap({ formatter.string(from: $0) })

    }
    
    @IBAction func presentSecondVC(_ sender: Any) {
        present(vc, animated: true, completion: nil)
    }
    
    func scrollToDate(_ date: Date, animated: Bool) {
        calendarView.visibleDates({ [weak self] visibleDates in
            guard let self = self else { return }
            if visibleDates.monthDates.contains(where: { $0.date.isSameDay(date) }) {
                return
            } else {
                self.calendarView.scrollToDate(
                    date, animateScroll: animated,
                    completionHandler: nil)
            }
        })
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: presenter.calendarRange.start, endDate: presenter.calendarRange.end,
                                       numberOfRows: 6, calendar: Date.calendar,
                                       generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow,
                                       hasStrictBoundaries: true)
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date,
                  cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: "MonthlyCell",
            for: indexPath) as! MonthlyCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell,
                  forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? MonthlyCell else { return }
        if let cache = presenter.fetchCellViewModel(at: cellState.date) {
            cell.configure(cache: cache)
        } else {
            let cellViewModel = cell.configure(cellState: cellState)
            presenter.storeCellViewModel(cellViewModel)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date,
                  cell: JTAppleCell?, cellState: CellState, indexPath: IndexPath) {
        let scheduleMonthlyCell = cell as! MonthlyCell
        
    }

}

extension Date {
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }()
    
    var startOfMonth: Date {
        let components = Date.calendar.dateComponents([.year, .month], from: self)
        return Date.calendar.date(from: components)!
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return Date.calendar.isDate(self, inSameDayAs: date)
    }
    
}

extension ClosedRange where Bound == Date {
    var start: Date { return self.lowerBound }
    var end: Date { return self.upperBound }
}
