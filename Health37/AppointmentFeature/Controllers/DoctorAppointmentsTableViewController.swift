//
//  ViewController.swift
//  WLAppleCalendar
//
//  Created by willard on 2017/9/17.
//  Copyright © 2017年 willard. All rights reserved.
//


import UIKit

class DoctorAppointmentsTableViewController: UITableViewController {
    
    // MARK: - View Controller lifecycle
    var appointments: [[String : Any]] = []
    var doctorID = String()
    var noAppLabel = UILabel()
    var otherAppointments: [[String : Any]] = []
    var selectedTab : Int = 0
    var tableArray: [[String : Any]] = []
    var userType = String()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var controlSegment: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Control 1: Created and designed in IB
        controlSegment.segments = LabelSegment.segments(withTitles: ["Appointments".localized, "My Appointments".localized],normalFont: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,normalTextColor: .lightGray,selectedFont: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,selectedTextColor: .white)
        
        if userType == "hospitalDoctor"
        {
            self.title = "My Appointments".localized
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
            
            let logoutBarButtonItem = UIBarButtonItem(title: "Edit".localized, style: .done, target: self, action: #selector(editTapped))
            self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        }
        else
        {
            if let userType : String = UserDefaults.standard.userType
            {
                if userType != "patient"
                {
                    let logoutBarButtonItem = UIBarButtonItem(title: "Edit".localized, style: .done, target: self, action: #selector(editTapped))
                    self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
                }else
                {
                    self.title = "My Appointments".localized
                    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
                }
            }
        }
        
        let backItem = self.navigationItem.backButtonOnRight(title: "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        
        let myNib2 = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        self.tableView.register(myNib2, forCellReuseIdentifier: "ScheduleTableViewCell")
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            backItem.semanticContentAttribute = .forceRightToLeft
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @objc func backTapped(sender : UIButton) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers
        {
            for controller in viewControllers
            {
                if controller.isKind(of: DoctorListTableViewController.self)
                {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func detailButton(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAppointment()
        addNoLabel()
    }
    
    func addNoLabel() {
        noAppLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 100, y: (UIScreen.main.bounds.height/2) - 100, width: 200, height: 26))
        noAppLabel.textAlignment = .center
        noAppLabel.text = "No Appointment Found".localized
        self.tableView.addSubview(noAppLabel)
    }
    
    @objc func editTapped(){
        let controller = SlotDetailViewController.instantiate(fromAppStoryboard: .Appointment)
        if userType == "hospitalDoctor"
        {
            controller.userID = doctorID
        }
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    @IBAction func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        print("The selected index is \(sender.index)")
        selectedTab = sender.index
        if sender.index == 0
        {
            tableArray = appointments
        }else
        {
            tableArray = otherAppointments
        }
        sortDataWithDate()
        self.noAppLabel.isHidden = true
        if self.tableArray.count == 0
        {
            self.noAppLabel.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dateString = self.tableArray[section]["date"] as? String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString)
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "ar") as Locale
                }
                else
                {
                    dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
                }
                dateFormatter.dateFormat = "dd MMM yyyy"
                return dateFormatter.string(from: date)
            }
            return ""
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .groupTableViewBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrayCount = self.tableArray[section]["appointments"] as? [[String : Any]]
        {
            return arrayCount.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.selectionStyle = .none
        cell.moreInfoButton.isHidden = false
        cell.moreInfoButton.tag = indexPath.row
        cell.moreInfoButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
        {
            cell.sectionDate = self.tableArray[indexPath.section]["date"] as? String ?? ""
            cell.schedule = appointment[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
        {
            if let status : String = appointment[indexPath.row]["status"] as? String, status == "0"
            {
                DispatchQueue.main.async {
                    self.showAlert(message: "Appointment got cancelled or expired.".localized)
                }
            }else
            {
                let controller = ApptDetailTVC.instantiate(fromAppStoryboard: .Appointment)
                controller.appointmentType = self.selectedTab
                controller.dateString = self.tableArray[indexPath.section]["date"] as? String ?? ""
                if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
                {
                    controller.appointmentDetail = appointment[indexPath.row]
                }
                self.navigationController?.pushViewController(controller, animated:true)
            }
        }
    }
    
    @objc func buttonTapped(sender : UIButton) {
    }
}


extension DoctorAppointmentsTableViewController{
    
    @objc func getAppointment()
    {
        self.appointments.removeAll()
        self.otherAppointments.removeAll()
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetAppointment, Details: self.getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        if self.title == "My Appointments".localized
                        {
                            if let data = responseData?["my_appointments"] as? [[String : Any]]
                            {
                                for appointment in data
                                {
                                    var filteredAppointments: [[String : Any]] = []
                                    if let appointments : [[String : Any]] = appointment["appointments"] as? [[String : Any]]
                                    {
                                        for item in appointments
                                        {
                                            if let status : String = item["status"] as? String, status == "1"
                                            {
                                                filteredAppointments.append(item)
                                            }
                                        }
                                    }
                                    if filteredAppointments.count > 0
                                    {
                                        let appointmentIndex : [String : Any] = ["date":appointment["date"] as? String ?? "","appointments":filteredAppointments]
                                        self.appointments.append(appointmentIndex)
                                    }
                                }
                            }
                        }
                        else
                        {
                            if let data = responseData?["my_appointments"] as? [[String : Any]]
                            {
                                for appointment in data
                                {
                                    var filteredAppointments: [[String : Any]] = []
                                    if let appointments : [[String : Any]] = appointment["appointments"] as? [[String : Any]]
                                    {
                                        for item in appointments
                                        {
                                            if let status : String = item["status"] as? String, status == "1"
                                            {
                                                filteredAppointments.append(item)
                                            }
                                        }
                                    }
                                    if filteredAppointments.count > 0
                                    {
                                        let appointmentIndex : [String : Any] = ["date":appointment["date"] as? String ?? "","appointments":filteredAppointments]
                                        self.appointments.append(appointmentIndex)
                                    }
                                }
                            }
                            if let data = responseData?["other_appointments"] as? [[String : Any]]
                            {
                                for appointment in data
                                {
                                    var filteredAppointments: [[String : Any]] = []
                                    if let appointments : [[String : Any]] = appointment["appointments"] as? [[String : Any]]
                                    {
                                        for item in appointments
                                        {
                                            if let status : String = item["status"] as? String, status == "1"
                                            {
                                                filteredAppointments.append(item)
                                            }
                                        }
                                    }
                                    if filteredAppointments.count > 0
                                    {
                                        let appointmentIndex : [String : Any] = ["date":appointment["date"] as? String ?? "","appointments":filteredAppointments]
                                        self.otherAppointments.append(appointmentIndex)
                                    }
                                }
                            }
                        }
                        
                        if self.selectedTab == 0
                        {
                            self.tableArray = self.appointments
                        }else
                        {
                            self.tableArray = self.otherAppointments
                        }
                        self.sortDataWithDate()
                        self.noAppLabel.isHidden = true
                        debugPrint(self.tableArray)
                        if self.tableArray.count == 0
                        {
                            self.noAppLabel.isHidden = false
                        }
                        self.tableView.reloadData()
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
    
    
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if userType == "hospitalDoctor"
        {
            dictUser.setObject(doctorID, forKey: "doctor_id" as NSCopying)
        }
        else
        {
            if let userType : String = UserDefaults.standard.userType
            {
                if userType != "patient"
                {
                    if UserDefaults.standard.object(forKey: kUserID) != nil
                    {
                        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "doctor_id" as NSCopying)
                    }else
                    {
                        if UserDefaults.standard.object(forKey: kUserID) != nil
                        {
                            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                        }
                    }
                }else
                {
                    if UserDefaults.standard.object(forKey: kUserID) != nil
                    {
                        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                    }
                }
            }else
            {
                if UserDefaults.standard.object(forKey: kUserID) != nil
                {
                    dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                }
            }
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
    
    func sortDataWithDate()  {
        let sortedArray = sortArrayDictDescending(dict: self.tableArray)
        if sortedArray.count > 0
        {
            self.tableArray = sortedArray
        }
    }
    
    func sortArrayDictDescending(dict: [[String : Any]]) -> [[String : Any]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dict.sorted{[dateFormatter] one, two in
            return dateFormatter.date(from: one["date"] as? String ?? "" )! < dateFormatter.date(from: two["date"] as? String ?? "")!}
    }
}
