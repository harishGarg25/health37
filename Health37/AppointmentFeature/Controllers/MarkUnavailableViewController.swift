//
//  NewApptTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/17/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class MarkUnavailableViewController: UITableViewController {
    
    var selectedTimeSlot: Date?
    var doctorID: String?
    var isEdit: String?
    let formatter = DateFormatter()
    var calendarViewHidden = false
    var appointmentScrolled = false
    var appointmentDetail : [String : Any]?
    var dateString : String?
    var selectedDate = UILabel()
    var appointment : AppointmentDetail?
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    var availableDays = String()
    var timeSlotString = String()

    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var timeSlotTF: UITextField!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var weekStack: UIStackView!
    @IBOutlet weak var nextMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Book Slots".localized
        timeSlotTF.placeholder = timeSlotTF.placeholder?.localized
        
        setupCalendarView()
        noLargeTitles()
        getAppointmentDetail()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates( [Date()] )
        updateDateDetailLabel(date: Date())
                        
        let backItem = self.navigationItem.backButtonOnRight(title: (appointmentDetail?["patient_name"] as? String ?? appointmentDetail?["doctor_name"] as? String)?.capitalized ?? "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            timeSlotTF.textAlignment = .right
            currentMonthLabel.textAlignment = .right
            nextMonthLabel.textAlignment = .right
            weekStack.semanticContentAttribute = .forceLeftToRight
            let labels = weekStack.subviews.compactMap { $0 as? UILabel }
            for label in labels {
                label.text = label.text?.localized
            }
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            nextMonthLabel.textAlignment = .left
            timeSlotTF.textAlignment = .left
            currentMonthLabel.textAlignment = .left
        }
        calendarView.semanticContentAttribute = .forceLeftToRight
    }
    
    @objc func backTapped(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedTimeSlot != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
            {
                formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
            }
            else
            {
                formatter.locale = NSLocale(localeIdentifier: "en") as Locale
            }
            timeSlotTF.text = formatter.string(from: selectedTimeSlot!)
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
            timeSlotString = formatter.string(from: selectedTimeSlot!)
        }
    }
    
    func noLargeTitles(){
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            tableView.dragDelegate = self as? UITableViewDragDelegate
        }
    }
   
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextMonthButton(_ sender: Any) {
//        calendarView.scrollToSegment(.next)
//        calendarView.reloadData()
    }
    
    @IBAction func slotButton(_ sender: Any) {
        let controller = UnavailableTimeSlotsCVC.instantiate(fromAppStoryboard: .Appointment)
        controller.selectedDate = selectedDate.text?.accessibilityLabel
        controller.doctorID = self.doctorID
        controller.appointmentDetail = self.appointment
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
}

extension MarkUnavailableViewController {
    func toggleCalendarView() {
        calendarViewHidden = !calendarViewHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        appointmentScrolled = true
    }
    
    func updateDateDetailLabel(date: Date){
        formatter.dateFormat = "MMMM dd, yyyy"
        selectedDate.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        selectedDate.text?.accessibilityLabel = formatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleCalendarView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if calendarViewHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension MarkUnavailableViewController {
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else {
            return
        }
        
        if validCell.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
            if self.availableDays == "Weekdays"
            {
                if cellState.day == .friday || cellState.day == .saturday {
                    validCell.dateLabel.textColor = .red
                }
            }else if self.availableDays == "Long Week"
            {
                if cellState.day == .saturday {
                    validCell.dateLabel.textColor = .red
                }
            }
        }
    }
    
    func setupCalendarView() {
        // Setup Calendar Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollDirection = .vertical
    }

}


extension MarkUnavailableViewController {
    
    func fullDayPredicate(for date: Date) -> NSPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)
        let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo as Any])
        
        return datePredicate
    }
    
    @objc func getAppointmentDetail()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetTimeSlot, Details: self.getParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        if let data = responseData?["data"] as? [String : Any]
                        {
                            debugPrint(data)
                            self.availableDays = data["selected_slot_days"] as? String ?? ""
                            self.calendarView.reloadData()
                            self.appointment = AppointmentDetail.init(slotTime: data["selected_time_slot"] as? String ?? "", availableDays: data["selected_slot_days"] as? String ?? "", availableFromHours: data["available_from_time"] as? String ?? "", availableToHours: data["available_to_time"] as? String ?? "", breakFromTime: data["lunch_from_time"] as? String ?? "", breakToTime: data["lunch_to_time"] as? String ?? "", notes: data["notes"] as? String ?? "", locationLat: data["latitude"] as? String ?? "", locationLong: data["longitude"] as? String ?? "",userID: "")
                        }
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }

    func getParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(doctorID ?? "", forKey: kUserID as NSCopying)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: "language" as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: "language" as NSCopying)
        }
        return dictUser
    }
}

extension MarkUnavailableViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var endDate = Date()
        if let date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) {
            endDate = date
        }
        parameters = ConfigurationParameters(startDate: Date(),
        endDate: endDate,
        numberOfRows: 8,
        generateInDates: .forAllMonths,
        generateOutDates: .tillEndOfGrid,
        hasStrictBoundaries: false)
        
        
        return parameters
    }
}


extension MarkUnavailableViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if  date < Date.yesterday
        {
            DispatchQueue.main.async {
                self.showAlert(message: "Please select today's or future date.".localized)
            }
        }else
        {
            if self.availableDays == "Weekdays"
            {
                if cellState.day == .friday || cellState.day == .saturday {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Doctor not available.".localized)
                    }
                }else
                {
                    handleCellSelected(view: cell, cellState: cellState)
                    handleCellTextColor(view: cell, cellState: cellState)
                    updateDateDetailLabel(date: date)
                }
            }else if self.availableDays == "Long Week"
            {
                if cellState.day == .saturday {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Doctor not available.".localized)
                    }
                }else
                {
                    handleCellSelected(view: cell, cellState: cellState)
                    handleCellTextColor(view: cell, cellState: cellState)
                    updateDateDetailLabel(date: date)
                }
            }else
            {
                handleCellSelected(view: cell, cellState: cellState)
                handleCellTextColor(view: cell, cellState: cellState)
                updateDateDetailLabel(date: date)
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let helper = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let this_date = calendar.visibleDates().monthDates.first(where: { (helper?.component(NSCalendar.Unit.day, from: $0.date))! == 1 })?.date as Any
        let localDate = Date(timeInterval: TimeInterval(Calendar.current.timeZone.secondsFromGMT()), since: this_date as! Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        else
        {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        currentMonthLabel.text = formatter.string(from: localDate)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: localDate)
        nextMonthLabel.text = formatter.string(from: nextMonth!)
    }
}

extension MarkUnavailableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                print("Appt Added")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            print("Appt Deleted")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                print("Appt Changed and updated")
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}
