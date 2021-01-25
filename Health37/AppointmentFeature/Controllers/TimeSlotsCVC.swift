//
//  TimeSlotsCVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit


class TimeSlotsCVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "TimeSlotCell"
    
    @IBOutlet weak var slotCollectionView: UICollectionView!
    
    var timeSlotter = TimeSlotter()
    var appointmentDate = Date()
    var nameString = String()
    var formatter = DateFormatter()
    var timeSlots = [Date]()
    let currentDate = Date()
    var currentAppointments: [Appointment]?
    var bookedSlots = [String]()
    var appointmentDetail: AppointmentDetail?
    var doctorID: String?
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDateDetailLabel(date: appointmentDate)
        
        let backItem = self.navigationItem.backButtonOnRight(title: nameString)
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        getBookedAppointmentDetail()
        
    }
    
    @objc func backTapped(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateDateDetailLabel(date: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        else
        {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        self.title = formatter.string(from: date)
    }
    
    func setupTimeSlotter(openTime : String, closeTime : String) {
        let openTimeArray = openTime.components(separatedBy: ":")
        let closeTimeArray = closeTime.components(separatedBy: ":")
        let timeSlot = (appointmentDetail?.slotTime ?? "").components(separatedBy: " ")
        if openTimeArray.count > 1
        {
            let openTimeHour = openTimeArray[1].contains("AM") ? openTimeArray[0].toInt() : openTimeArray[0].toInt() == 12 ? openTimeArray[0].toInt() : openTimeArray[0].toInt() + 12
            let closeTimeHour = closeTime == "12:00AM" ? 24 : closeTimeArray[1].contains("AM") ? closeTimeArray[0].toInt() : closeTimeArray[0].toInt() == 12 ? closeTimeArray[0].toInt() : closeTimeArray[0].toInt() + 12
            
            timeSlotter.configureTimeSlotter(openTimeHour: openTimeHour, openTimeMinutes: openTimeArray[1].components(separatedBy: " ")[0].toInt(), closeTimeHour: closeTimeHour, closeTimeMinutes: closeTimeArray[1].components(separatedBy: " ")[0].toInt(), appointmentLength: 15, appointmentInterval: timeSlot[0].toInt())
            if let appointmentsArray = currentAppointments {
                timeSlotter.currentAppointments = appointmentsArray.map { $0.date }
            }
            guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: appointmentDate) else {
                print("There is no appointments")
                return }
            for slot in timeSlots {
                self.timeSlots.append(slot)
            }
            slotCollectionView.reloadData()
        }else
        {
            self.showOptionAlert(title: "Alert".localized, message: "Might be user has not enabled his/her appointment feature.".localized, button1Title: "OK".localized, button2Title: "", completion: { (success) in
                if success
                {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
        cell.isUserInteractionEnabled = true
        let timeSlot = timeSlots[indexPath.row]
        formatter.dateFormat = "hh:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        let time = formatter.string(from: timeSlot)
        cell.timeLabel.textColor = .black
        if self.bookedSlots.contains(time)
        {
            cell.timeLabel.textColor = .red
            cell.isUserInteractionEnabled = false
        }
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        else
        {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        let finalTime = formatter.string(from: timeSlot)
        cell.timeLabel.text = finalTime
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if timeSlots[indexPath.row] <= Date()
        {
            self.onShowAlertController(title: "Alert" , message: "Please Select Future Time".localized)
        }else
        {
            if let destinationVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 2) - 2] as?  NewApptTableViewController {
                destinationVC.selectedTimeSlot = timeSlots[indexPath.row]
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/3) - 24, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
}

extension TimeSlotsCVC{
    
    @objc func getBookedAppointmentDetail()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetBookedSlot, Details: self.getParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        if let booked_appointment = responseData?["booked_appointment"] as? [[String : Any]]
                        {
                            debugPrint(booked_appointment)
                            for item in booked_appointment
                            {
                                if let string : String = item["start"] as? String
                                {
                                    self.bookedSlots.append(string)
                                }
                            }
                        }
                    }
                }
                else
                {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
                
                let closeTimeDate = self.getDate(date: self.appointmentDetail?.availableToHours ?? "")
                let lunchTimeDate = self.getDate(date: self.appointmentDetail?.breakToTime ?? "")
                if (closeTimeDate ?? Date()) <= (lunchTimeDate ?? Date())
                {
                    self.setupTimeSlotter(openTime: self.appointmentDetail?.availableFromHours ?? "", closeTime: self.appointmentDetail?.availableToHours ?? "")
                }else
                {
                    self.setupTimeSlotter(openTime: self.appointmentDetail?.availableFromHours ?? "", closeTime: self.appointmentDetail?.breakFromTime ?? "")
                    self.setupTimeSlotter(openTime: self.appointmentDetail?.breakToTime ?? "", closeTime: self.appointmentDetail?.availableToHours ?? "")
                }
                self.getLunchInterwal(startFrom: self.appointmentDetail?.breakFromTime ?? "", end: self.appointmentDetail?.breakToTime ?? "")
            }
        }
    }
    
    
    func getParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(doctorID ?? "", forKey: "doctor_id" as NSCopying)
        dictUser.setObject(selectedDate ?? "", forKey: "date" as NSCopying)
        
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
    
    func getLunchInterwal(startFrom: String, end: String){
        
        let array: [String] = ["07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM","12:00AM"]
        if let startIndex : Int = array.index(of: startFrom)
        {
            if let endindex : Int = array.index(of: end)
            {
                if (startIndex < endindex)
                {
                    for index in startIndex...endindex - 1
                    {
                        bookedSlots.append(array[index])
                    }
                }
            }
        }
        slotCollectionView.reloadData()
    }
    
}







