//
//  ViewController.swift
//  Appt
//
//  Created by user on 02/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import UIKit
import LocationPickerViewController
import CoreLocation

class SlotDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    @IBOutlet weak var availableDaysCollectionView: UICollectionView!
    @IBOutlet weak var availableHourBtn1: UIButton!
    @IBOutlet weak var availableHourBtn2: UIButton!
    @IBOutlet weak var lunchHourBtn1: UIButton!
    @IBOutlet weak var lunchHourBtn2: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var notesTextfield: UITextField!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var dateViews: [UIView]!
    @IBOutlet weak var timeslotLabel: UILabel!
    @IBOutlet weak var availableDays: UILabel!
    @IBOutlet weak var availableHours: UILabel!
    @IBOutlet weak var lunchTime: UILabel!
    @IBOutlet weak var workLocation: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var to1Label: UILabel!
    @IBOutlet weak var from1Label: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var durationAvailable: [Slot] = []
    var daysAvailable: [Slot] = []
    lazy var dateTimeUtility: DateTimeUtility = DateTimeUtility()
    let timeslotecellID = "timeslotecell"
    let availableHourslotecellID = "availableHourslotecell"
    var selectedDurationIndex: Int?
    var selectedDaysIndex: Int?
    var availablFromTime: String?
    var lunchFromTime: String?
    var availablToTime: String?
    var lunchToTime: String?
    var selectedSlotTime: String?
    var selectedDays: String?
    var selectedLocationLat: String?
    var selectedLocationLong: String?
    var userID: String?

    var timePicker: UIDatePicker?
    lazy var locationPicker : LocationPicker = {
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = {
            (location) in
            if let address = location.addressDictionary?["FormattedAddressLines"] as? [String]{
                let add = address.joined(separator: ", ")
                self.notesTextfield.text = add
                self.selectedLocationLat = location.coordinate?.latitude.description
                self.selectedLocationLong = location.coordinate?.latitude.description
            }
        }
        locationPicker.addBarButtons()
        return locationPicker
    }()
    
    
    @IBAction func fromDate(_ sender: UIButton){
        DropDownVC.show(present: self, anchorView: sender, dataSet: dateTimeUtility.getTimeInterwal()) { (string, index) in
            sender.setTitleColor(.black, for: .normal)
            sender.setTitle(string, for: .normal)
            self.availablFromTime = string
            self.availableHourBtn2.setTitle("00:00", for: .normal)
            self.availablToTime = ""
        }
    }
    @IBAction func toDate(_ sender: UIButton){
        DropDownVC.show(present: self, anchorView: sender, dataSet: dateTimeUtility.getTimeInterwal(startFrom: availablFromTime)) { (string, index) in
            self.availablToTime = string
            sender.setTitleColor(.black, for: .normal)
            sender.setTitle(string, for: .normal)
        }
    }
    
    @IBAction func lunchFromDate(_ sender: UIButton){
        DropDownVC.show(present: self, anchorView: sender, dataSet: dateTimeUtility.getLunchTimeInterwal()) { (string, index) in
            sender.setTitleColor(.black, for: .normal)
            sender.setTitle(string, for: .normal)
            self.lunchFromTime = string
            self.lunchHourBtn2.setTitleColor(.black, for: .normal)
            let totime = self.dateTimeUtility.timeAfter(mints: 30, time: string)
            self.lunchToTime = totime
            self.lunchHourBtn2.setTitle(totime, for: .normal)
        }
    }
    
    @IBAction func lunchToDate(_ sender: UIButton){
        DropDownVC.show(present: self, anchorView: sender, dataSet: dateTimeUtility.getLunchTimeInterwal(startFrom: lunchFromTime)) { (string, index) in
            self.lunchToTime = string
            sender.setTitleColor(.black, for: .normal)
            sender.setTitle(string, for: .normal)
        }
    }
    
    @IBAction func continueButton(_ sender: Any) {
        
//        let closeTimeDate = getDate(date: availablToTime ?? "")
//        let lunchTimeDate = getDate(date: lunchFromTime ?? "")
        
        if selectedSlotTime?.isEmpty ?? true
        {
            self.onShowAlertController(title: "Alert" , message: "Please Select Time Slot".localized)
        }else if selectedDays?.isEmpty ?? true
        {
            self.onShowAlertController(title: "Alert" , message: "Please Select Available Days".localized)
        }
        else if availablFromTime?.isEmpty ?? true || availablToTime?.isEmpty ?? true
        {
            self.onShowAlertController(title: "Alert" , message: "Please Select Available Hours".localized)
        }
        else if lunchFromTime?.isEmpty ?? true || lunchToTime?.isEmpty ?? true
        {
            self.onShowAlertController(title: "Alert" , message: "Please Select Lunch Time".localized)
        }
//        else if (closeTimeDate ?? Date()) <= (lunchTimeDate ?? Date())
//        {
//            self.onShowAlertController(title: "Alert" , message: "Lunch Time Should Be Between Office Time.".localized)
//        }
//        else if self.locationTextfield.text?.isEmpty ?? true
//        {
//            self.onShowAlertController(title: "Alert" , message: "Please Select Health Care Location".localized)
//        }
        else
        {
            let appointment = AppointmentDetail.init(slotTime: selectedSlotTime, availableDays: selectedDays, availableFromHours: availablFromTime, availableToHours: availablToTime, breakFromTime: lunchFromTime, breakToTime: lunchToTime, notes: notesTextfield.text ?? "", locationLat: selectedLocationLat ?? "", locationLong: selectedLocationLong ?? "", userID: userID ?? "")
            let controller = TimeSlotsController.instantiate(fromAppStoryboard: .Appointment)
            controller.appointmentDetail = appointment
            self.navigationController?.pushViewController(controller, animated:true)
        }
    }
    
    func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
    
    @IBAction func location(_ sender: UIButton){
        let navigationController = UINavigationController(rootViewController: locationPicker)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Appointment Slots Detail".localized
        self.navigationItem.addSettingButtonOnRight(title: "Back")

        durationAvailable = Slot.duretionSlot()
        daysAvailable = Slot.availbleDays()
        
        timeSlotCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: timeslotecellID)
        availableDaysCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: availableHourslotecellID)
        
        if (userID == nil || userID == "")
        {
            if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
            {
                userID = userid
            }
        }
        
        getAppointmentDetail()
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            notesTextfield.textAlignment = .right
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            notesTextfield.textAlignment = .left
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        setupView()
    }
    
    func setupView()
    {
        timeslotLabel.text = timeslotLabel.text?.localized
        availableDays.text = availableDays.text?.localized
        availableHours.text = availableHours.text?.localized
        lunchTime.text = lunchTime.text?.localized
        workLocation.text = workLocation.text?.localized
        toLabel.text = toLabel.text?.localized
        fromLabel.text = fromLabel.text?.localized
        to1Label.text = to1Label.text?.localized
        from1Label.text = from1Label.text?.localized
        notesTextfield.placeholder = "Add notes".localized
        continueButton.setTitle("Continue".localized, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [timeSlotCollectionView,availableDaysCollectionView].forEach { (collectionView) in
            collectionView?.layer.borderColor = Color.theme.cgColor
            collectionView?.layer.borderWidth = 1
            collectionView?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


extension SlotDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeSlotCollectionView{
            return durationAvailable.count
        }
        else if collectionView == availableDaysCollectionView{
            return daysAvailable.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeSlotCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeslotecellID, for: indexPath) as! SlotsCollectionViewCell
            selectedDurationIndex == indexPath.row ? cell.selectCell() : cell.deSelectCell()
            cell.configure(with: durationAvailable[indexPath.row])
            return cell
        }
        else if collectionView == availableDaysCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: availableHourslotecellID, for: indexPath) as! SlotsCollectionViewCell
            selectedDaysIndex == indexPath.row ? cell.selectCell() : cell.deSelectCell()
            cell.configure(with: daysAvailable[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == timeSlotCollectionView{
            selectedDurationIndex = indexPath.row
            selectedSlotTime = durationAvailable[indexPath.row].title
        }
        else if collectionView == availableDaysCollectionView{
            selectedDaysIndex = indexPath.row
            selectedDays = daysAvailable[indexPath.row].title
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionviewwidth = collectionView.frame.width
        
        if collectionView == timeSlotCollectionView{
            let multiplier = (2*(durationAvailable.count-1))/durationAvailable.count
            let w = (collectionviewwidth)/CGFloat(durationAvailable.count) * CGFloat(multiplier)
            let h = collectionView.frame.height
            return CGSize(width: w, height: h)
        }
        else if collectionView == availableDaysCollectionView{
            let multiplier = (2*(daysAvailable.count-1))/daysAvailable.count
            let w = (collectionviewwidth)/CGFloat(daysAvailable.count) * CGFloat(multiplier)
            let h = collectionView.frame.height
            return CGSize(width: w, height: h)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SlotDetailViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension SlotDetailViewController{
    
    @objc func getAppointmentDetail()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetTimeSlot, Details: self.getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        if let data = responseData?["data"] as? [String : Any]
                        {
                            self.selectedSlotTime = data["selected_time_slot"] as? String ?? ""
                            self.selectedDays = data["selected_slot_days"] as? String ?? ""
                            self.availablFromTime = data["available_from_time"] as? String ?? ""
                            self.lunchFromTime = data["lunch_from_time"] as? String ?? ""
                            self.availablToTime = data["available_to_time"] as? String ?? ""
                            self.lunchToTime = data["lunch_to_time"] as? String ?? ""
                            self.notesTextfield.text = data["notes"] as? String ?? ""
                            self.selectedLocationLat = data["latitude"] as? String ?? ""
                            self.selectedLocationLong = data["longitude"] as? String ?? ""
                            
                            
                            for i in 0...self.durationAvailable.count-1
                            {
                                if self.durationAvailable[i].title == self.selectedSlotTime
                                {
                                    self.selectedDurationIndex = i
                                }
                            }
                            
                            for i in 0...self.daysAvailable.count-1
                            {
                                if self.daysAvailable[i].title == self.selectedDays
                                {
                                    self.selectedDaysIndex = i
                                }
                            }
                            
                            self.availableHourBtn1.setTitle(self.availablFromTime, for: .normal)
                            self.availableHourBtn2.setTitle(self.availablToTime, for: .normal)
                            self.lunchHourBtn1.setTitle(self.lunchFromTime, for: .normal)
                            self.lunchHourBtn2.setTitle(self.lunchToTime, for: .normal)
                            self.availableHourBtn1.setTitleColor(.black, for: .normal)
                            self.availableHourBtn2.setTitleColor(.black, for: .normal)
                            self.lunchHourBtn1.setTitleColor(.black, for: .normal)
                            self.lunchHourBtn2.setTitleColor(.black, for: .normal)

                            self.timeSlotCollectionView.reloadData()
                            self.availableDaysCollectionView.reloadData()
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
    
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if userID != nil
        {
            dictUser.setObject(userID ?? "", forKey: kUserID as NSCopying)
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
