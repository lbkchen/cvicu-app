//
//  CalendarViewController.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/6/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var month: UILabel!
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.menuView.delegate = self
        self.calendarView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        updateDateLabel()
    }
    
    // MARK: - CVCalendar delegate functions
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday {
        return CVCalendarWeekday.Sunday
    }
    
    func presentedDateUpdated(date: Date) {
        updateDateLabel()
    }
    
    @IBAction func toggleToToday(sender: UIBarButtonItem) {
        self.calendarView.toggleCurrentDayView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelToCalendarViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Log data
    
    @IBAction func recordDate(sender: UIButton) {
        SessionData.sharedInstance.addData("day", value: getCurrentDateString())
    }
    
    // MARK: - Helper functions
    func updateDateLabel() {
        let months = dateFormatter.monthSymbols
        let monthText = months[self.calendarView.presentedDate.month - 1]
        let yearText = String(self.calendarView.presentedDate.year)
        self.month.text = "\(monthText), \(yearText)"
    }
    
    func getCurrentDateString() -> String {
        var month = String(self.calendarView.presentedDate.month)
        var day = String(self.calendarView.presentedDate.day)
        var year = String(self.calendarView.presentedDate.year)
        
        if (month.characters.count == 1) { month = "0\(month)" }
        if (day.characters.count == 1) { day = "0\(day)" }
        
        return "\(month)/\(day)/\(year)"
    }

}
