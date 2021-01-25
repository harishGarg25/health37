//
//  ViewController.swift
//  WLAppleCalendar
//
//  Created by willard on 2017/9/17.
//  Copyright © 2017年 willard. All rights reserved.
//


import UIKit

class DoctorListTableViewController: UITableViewController {
    
    // MARK: - View Controller lifecycle
    var hospitalID : String = ""
    var doctorsList: [[String : Any]] = []
    var appointmentDetail : [String : Any]?
    var noAppLabel = UILabel()
    var selectedTab : Int = 0
    var tableArray: [[String : Any]] = []
    var appointments: [[String : Any]] = []
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var controlSegment: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctors List".localized
        
        controlSegment.segments = LabelSegment.segments(withTitles: ["Appointments".localized, "Doctors List".localized],normalFont: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,normalTextColor: .lightGray,selectedFont: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,selectedTextColor: .white)
        
        
        if hospitalID != ""
        {
            if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
            {
                if hospitalID == userid
                {
                    let logoutBarButtonItem = UIBarButtonItem(title: "ADD".localized, style: .done, target: self, action: #selector(editTapped))
                    self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
                }else
                {
                    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
                    selectedTab = 1
                }
            }
        }else
        {
            if UserDefaults.standard.cat_parent_id == "4"
            {
                let logoutBarButtonItem = UIBarButtonItem(title: "ADD".localized, style: .done, target: self, action: #selector(editTapped))
                self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
            }else
            {
                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
                selectedTab = 1
            }
        }
        
        
        let backItem = self.navigationItem.backButtonOnRight(title: "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        
        let myNib2 = UINib(nibName: "DoctorListTableViewCell", bundle: Bundle.main)
        self.tableView.register(myNib2, forCellReuseIdentifier: "DoctorListTableViewCell")
        let myNib = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        self.tableView.register(myNib, forCellReuseIdentifier: "ScheduleTableViewCell")
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            backItem.semanticContentAttribute = .forceLeftToRight
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @IBAction func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        print("The selected index is \(sender.index)")
        selectedTab = sender.index
        if sender.index == 0
        {
            tableArray = appointments
            sortDataWithDate()
        }else
        {
            tableArray = doctorsList
        }
        self.noAppLabel.isHidden = true
        if self.tableArray.count == 0
        {
            self.noAppLabel.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    @objc func backTapped(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if headerView.frame.size.height != 0
        {
            getAppointment()
        }
        getDoctorsList()
        addNoLabel()
    }
    
    func addNoLabel() {
        noAppLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 100, y: (UIScreen.main.bounds.height/2) - 100, width: 200, height: 26))
        noAppLabel.textAlignment = .center
        noAppLabel.text = "No Doctor Found".localized
        self.tableView.addSubview(noAppLabel)
    }
    
    @objc func editTapped(){
        let controller = SlotDetailForNewUserViewController.instantiate(fromAppStoryboard: .Appointment)
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    @IBAction func detailButton(_ sender: Any) {
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTab == 0
        {
            return tableArray.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0
        {
            if let arrayCount = self.tableArray[section]["appointments"] as? [[String : Any]]
            {
                return arrayCount.count
            }
            return 0
        }
        else
        {
            return tableArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedTab == 0
        {
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
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedTab == 0
        {
            return 30
        }
        else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .groupTableViewBackground
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedTab == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.moreInfoButton.isHidden = false
            cell.moreInfoButton.tag = indexPath.row
            if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
            {
                cell.sectionDate = self.tableArray[indexPath.section]["date"] as? String ?? ""
                cell.schedule = appointment[indexPath.row]
            }
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorListTableViewCell", for: indexPath) as! DoctorListTableViewCell
            cell.optionButton.isHidden = !(hospitalID == "")
            cell.optionButton.tag = indexPath.row
            cell.optionButton.addTarget(self, action: #selector(pressed), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            cell.detail = tableArray[indexPath.row]
            return cell
        }
    }
    
    @objc func pressed(sender: UIButton!) {
        let alert = UIAlertController(title: "Action".localized, message: nil, preferredStyle: .actionSheet)
        
//        alert.addAction(UIAlertAction(title: "Unavailable Slots".localized, style: .default, handler: { _ in
//            DispatchQueue.main.async {
//                let controller = MarkUnavailableViewController.instantiate(fromAppStoryboard: .Appointment)
//                controller.doctorID = self.tableArray[sender.tag]["user_id"] as? String ?? ""
//                self.navigationController?.pushViewController(controller, animated:true)
//            }
//        }))
        
        alert.addAction(UIAlertAction(title: "Edit".localized, style: .default, handler: { _ in
            DispatchQueue.main.async {
                let controller = AddUserScreen.instantiate(fromAppStoryboard: .Appointment)
                controller.isEdit = true
                controller.userDetail = self.tableArray[sender.tag]
                self.navigationController?.pushViewController(controller, animated:true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Delete".localized, style: .default, handler: { _ in
            self.showOptionAlert(title: "Alert".localized, message: "Are you sure you want to delete this doctor.".localized, button1Title: "Yes".localized, button2Title: "No".localized, completion: { (success) in
                if success
                {
                    self.deleteDoctor(doctorID: self.tableArray[sender.tag]["user_id"] as? String ?? "",index: sender.tag)
                }
            })
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTab == 0
        {
            if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
            {
                if let status : String = appointment[indexPath.row]["status"] as? String, status == "0"
                {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Appointment got cancelled or expired.".localized)
                    }
                }else
                {
                    if let status : String = appointment[indexPath.row]["is_offline"] as? String, status == "1"
                    {
                        DispatchQueue.main.async {
                            self.showOptionAlert(title: "".localized, message: "Its an offline booking done by you. You want to make it available again?".localized, button1Title: "Available".localized, button2Title: "Cancel".localized, completion: { (success) in
                                if success
                                {
                                    if let id = appointment[indexPath.row]["appointment_id"] as? String
                                    {
                                        self.cancelOfflineSlot(appointment_id: id)
                                    }
                                }
                            })
                        }
                    }else
                    {
                        
                        let controller = ApptDetailTVC.instantiate(fromAppStoryboard: .Appointment)
                        controller.appointmentType = 1
                        controller.dateString = self.tableArray[indexPath.section]["date"] as? String ?? ""
                        if let appointment = self.tableArray[indexPath.section]["appointments"] as? [[String : Any]]
                        {
                            controller.appointmentDetail = appointment[indexPath.row]
                        }
                        self.navigationController?.pushViewController(controller, animated:true)
                    }
                }
            }
        }
        else
        {
            if hospitalID != ""
            {
                let controller = NewApptTableViewController.instantiate(fromAppStoryboard: .Appointment)
                controller.doctorID = tableArray[indexPath.row]["user_id"] as? String ?? ""
                controller.appointmentDetail = appointmentDetail
                self.navigationController?.pushViewController(controller, animated:true)
            }else
            {
                let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
                controller.userType = "hospitalDoctor"
                controller.doctorID = tableArray[indexPath.row]["user_id"] as? String ?? ""
                self.navigationController?.pushViewController(controller, animated:true)
            }
        }
    }
}


extension DoctorListTableViewController{
    
    @objc func getAppointment()
    {
        self.appointments.removeAll()
        self.showActivity(text: "")
        
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "doctor_id" as NSCopying)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: "language" as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: "language" as NSCopying)
        }
        getallApiResultwithGetMethod(strMethodname: kMethodGetAppointment, Details: dictUser) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        debugPrint(responseData ?? "")
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
                                    self.appointments.append(appointmentIndex)
                                }
                            }
                        }
                        
                        self.sortDataWithDate()
                        self.noAppLabel.isHidden = true
                        debugPrint(self.tableArray)
                        if self.tableArray.count == 0
                        {
                            self.noAppLabel.isHidden = false
                        }
                        if self.selectedTab == 0
                        {
                            self.tableArray = self.appointments
                            self.sortDataWithDate()
                        }else
                        {
                            self.tableArray = self.doctorsList
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
    
    
    @objc func getDoctorsList()
    {
        self.doctorsList.removeAll()
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetDoctorsList, Details: self.getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        if let data = responseData?["doctor"] as? [[String : Any]]
                        {
                            debugPrint(data)
                            self.doctorsList = data
                        }
                        self.noAppLabel.isHidden = true
                        if self.doctorsList.count == 0
                        {
                            self.noAppLabel.isHidden = false
                        }
                        if self.selectedTab == 0
                        {
                            self.tableArray = self.appointments
                            self.sortDataWithDate()
                        }else
                        {
                            self.tableArray = self.doctorsList
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
    
    @objc func cancelOfflineSlot(appointment_id : String)
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodCancelOfflineSlot, Details: ["appointment_id" : appointment_id]) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        self.onShowAlertControllerAction(title: "" , message: "Marked Available".localized)
                        self.getAppointment()
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
        if hospitalID != ""
        {
            dictUser.setObject(hospitalID, forKey: kUserID as NSCopying)
        }else
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
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
    
    @objc func deleteDoctor(doctorID: String,index: Int)
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodDeleteDoctor, Details: ["user_id" : doctorID]) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        self.tableArray.remove(at: index)
                        self.noAppLabel.isHidden = true
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
}
