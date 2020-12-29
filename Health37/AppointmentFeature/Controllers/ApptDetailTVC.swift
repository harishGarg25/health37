//
//  ApptDetailTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class ApptDetailTVC: UITableViewController {
    
    var appointment: Appointment?
    var dateString : String?
    var appointmentType : Int = 0
    var segueEditAppt = "SegueEditAppt"
    var appointmentDetail : [String : Any]?
    var discountAmount = String()
    var doctorNote = String()
    var notificationID = String()
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var editApptButton: UIButton!
    @IBOutlet weak var cancelApptButton: UIButton!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var doctorNoteLabel: UILabel!
    @IBOutlet weak var noteHeading: UILabel!
    @IBOutlet weak var note1Label: UILabel!
    @IBOutlet weak var note2Label: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noLargeTitles()
        
        let backItem = self.navigationItem.backButtonOnRight(title: "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        editApptButton.setTitle(editApptButton.titleLabel?.text?.localized, for: .normal)

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            backItem.semanticContentAttribute = .forceRightToLeft
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            doctorNoteLabel.textAlignment = .right
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            doctorNoteLabel.textAlignment = .left
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        
        if notificationID != ""
        {
            getAppointmentDetail()
        }else
        {
            fillAppointmentDetail()
        }
    }
    
    func fillAppointmentDetail()  {
        if let userType : String = UserDefaults.standard.userType
        {
            if userType != "patient"
            {
                if appointmentType == 0
                {
                    editApptButton.isHidden = true
                }else
                {
                    editApptButton.isHidden = false
                }
            }
        }
        if notificationID != ""
        {
            if let patient_id : String = appointmentDetail?["patient_id"] as? String
            {
                if let user_id : String = UserDefaults.standard.object(forKey: kUserID) as? String
                {
                    editApptButton.isHidden = !(patient_id == user_id)
                }
            }
        }
        if let status : String = appointmentDetail?["status"] as? String, status == "1"
        {
            cancelApptButton.setTitle("Cancel".localized, for: .normal)
        }else
        {
            editApptButton.setTitle("Reschedule".localized, for: .normal)
            if notificationID != ""
            {
                cancelApptButton.isHidden = true
                self.showOptionAlert(title: "Alert".localized, message: "Appointment Cancelled".localized, button1Title: "Ok".localized, button2Title: "") { (success) in
                    if success
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        setupUI()
    }
    
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func noLargeTitles(){
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            tableView.dragDelegate = self as? UITableViewDragDelegate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.showOptionAlert(title: "Alert".localized, message: "Are you sure you want to cancel the Appointment?".localized, button1Title: "Yes".localized, button2Title: "No".localized, completion: { (success) in
            if success
            {
                self.cancelAppointment()
            }
        })
    }
    
    @IBAction func editAppt(_ sender: UIButton) {
        let controller = NewApptTableViewController.instantiate(fromAppStoryboard: .Appointment)
        controller.isEdit = "true"
        controller.dateString = self.dateString
        controller.appointmentDetail = appointmentDetail
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    func setupUI() {
        patientNameLabel.text = (appointmentDetail?["patient_name"] as? String ?? appointmentDetail?["doctor_name"] as? String)?.capitalized
        let dateFormatter = DateFormatter()
        if let time_slot = appointmentDetail?["time_slot"] as? String
        {
            hourLabel.text = time_slot
            dateFormatter.dateFormat = "hh:mm a"
            if let date = dateFormatter.date(from: time_slot)
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "ar") as Locale
                }
                else
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                }
                hourLabel.text = dateFormatter.string(from: date)
            }
        }
        if let dateStr = dateString
        {
            dateLabel.text = dateStr
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateStr)
            {
                dateFormatter.dateFormat = "dd MMM yyyy"
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "ar") as Locale
                }
                else
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                }
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
        discountAmount = appointmentDetail?["discount_amount"] as? String ?? ""
        doctorNote = appointmentDetail?["doctor_notes"] as? String ?? ""
        hospitalName.text = appointmentDetail?["hospital_name"] as? String ?? ""
        discountLabel.text = "%\(discountAmount) \(discountLabel.text?.localized ?? "")"
        doctorNoteLabel.text = doctorNote
        noteHeading.text = noteHeading.text?.localized
        note1Label.text = note1Label.text?.localized
        note2Label.text = note2Label.text?.localized
        
        self.tableView.reloadData()
    }
    
}


extension ApptDetailTVC {
    @objc func cancelAppointment()
    {
        self.showActivity(text: "")
        let dictUser = NSMutableDictionary()
        dictUser.setObject(appointmentDetail?["appointment_id"] as? String ?? "", forKey: "appointment_id" as NSCopying)
        dictUser.setObject(UserDefaults.standard.cat_parent_id == "4" ? "doctor" : "patient", forKey: "type" as NSCopying)
        dictUser.setObject(appointmentDetail?["doctor_id"] as? String ?? "", forKey: "user_id" as NSCopying)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: "language" as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: "language" as NSCopying)
        }
        
        getallApiResultwithGetMethod(strMethodname: kMethodCancelSlot, Details: dictUser) { (responseData, error) in
            self.hideActivity()
            if error == nil
            {
                DispatchQueue.main.async {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        self.showOptionAlert(title: "Alert".localized, message: "Appointment Cancelled".localized, button1Title: "OK".localized, button2Title: "", completion: { (success) in
                            if success
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    else
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }
    
    @objc func getAppointmentDetail()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodAppointmentDetail, Details: self.getProfileParams()) { (responseData, error) in
            self.hideActivity()
            if error == nil
            {
                    DispatchQueue.main.async {
                        self.hideActivity()
                        if let response = responseData?["response"] as? String, response == "1"
                        {
                            if let data = responseData?["my_appointments"] as? [[String : Any]]
                            {
                                debugPrint(data)
                                for appointment in data
                                {
                                    var filteredAppointments: [[String : Any]] = []
                                    if let appointments : [[String : Any]] = appointment["appointments"] as? [[String : Any]]
                                    {
                                        for item in appointments
                                        {
                                            filteredAppointments.append(item)
                                        }
                                    }
                                    if filteredAppointments.count > 0
                                    {
                                        self.dateString = appointment["date"] as? String ?? ""
                                        self.appointmentDetail = filteredAppointments[0]
                                        self.fillAppointmentDetail()
                                    }
                                }
                            }
                        }
                    }
            }
            else
            {
                DispatchQueue.main.async {
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }
    
    
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        if notificationID != ""
        {
            dictUser.setObject(notificationID , forKey: "not_id" as NSCopying)
        }else
        {
            dictUser.setObject(appointmentDetail?["appointment_id"] as? String ?? "", forKey: "appointment_id" as NSCopying)
        }
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


extension ApptDetailTVC
{
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width-40, height: 30))
        //label.textAlignment = .center
        if section == 0
        {
            label.text = "Hospital/Clinic Name".localized
        }
        else if section == 1
        {
            label.text = "Appointment Info".localized
        }else if section == 2
        {
            label.text = "Discount".localized
        }else
        {
            return nil
        }
        view.addSubview(label)
        if (section == 2) {
            return discountAmount == "0" ? nil : view
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return hospitalName.text?.count == 0 ? 0 : 50
        }
        if (indexPath.section == 1) {
            return 120
        }
        if (indexPath.section == 2) {
            if indexPath.row == 1
            {
                return doctorNote.height() + 15
            }else
            {
                return 150
            }
        }
        if (indexPath.section == 3) {
            return 40
        }
        else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return hospitalName.text?.count == 0 ? 0 : 30
        }
        if (section == 2) {
            return discountAmount == "0" ? 0 : 30
        }
        if (section == 5) {
            return editApptButton.isHidden ? 0 : 40
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return hospitalName.text?.count == 0 ? 0 : 1
        }
        if (section == 2) {
            return discountAmount == "0" ? 0 : doctorNote == "" ? 1 : 2
        }
        if (section == 5) {
            return editApptButton.isHidden ? 0 : 1
        }
        else {
            return 1
        }
    }
}


