//
//  TimeSlotsCVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit


class TimeSlotsController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var slotCollectionView: UICollectionView!
    
    private let reuseIdentifier = "TimeSlotCell"
    var timeSlotter = TimeSlotter()
    var appointmentDate = Date()
    var formatter = DateFormatter()
    var timeSlots = [Date]()
    let currentDate = Date()
    var currentAppointments: [Appointment]?
    var appointmentDetail: AppointmentDetail?
    var lunchTiming: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeTimeDate = getDate(date: appointmentDetail?.availableToHours ?? "")
        let lunchTimeDate = getDate(date: appointmentDetail?.breakToTime ?? "")
        if (closeTimeDate ?? Date()) <= (lunchTimeDate ?? Date())
        {
            setupTimeSlotter(openTime: appointmentDetail?.availableFromHours ?? "", closeTime: appointmentDetail?.availableToHours ?? "")
        }else
        {
            setupTimeSlotter(openTime: appointmentDetail?.availableFromHours ?? "", closeTime: appointmentDetail?.breakFromTime ?? "")
            setupTimeSlotter(openTime: appointmentDetail?.breakToTime ?? "", closeTime: appointmentDetail?.availableToHours ?? "")
        }
        getLunchInterwal(startFrom: appointmentDetail?.breakFromTime ?? "", end: appointmentDetail?.breakToTime ?? "")
        slotCollectionView.reloadData()

        self.title = "Appointment Slots".localized
        
        if UserDefaults.standard.getAppointmentStatus == "1"
        {
            continueButton.setTitle("Update".localized, for: .normal)
        }else
        {
            continueButton.setTitle("Continue".localized, for: .normal)
        }
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if continueButton.titleLabel?.text == "Continue".localized
        {
            let controller = PriceSelectionViewController.instantiate(fromAppStoryboard: .Appointment)
            controller.appointmentDetail = self.appointmentDetail
            self.navigationController?.pushViewController(controller, animated:true)
        }else
        {
            setTimeSlotsInformation()
        }
    }
    
    func setupTimeSlotter(openTime : String, closeTime : String) {
        
        let openTimeArray = openTime.components(separatedBy: ":")
        let closeTimeArray = closeTime.components(separatedBy: ":")
        let timeSlot = (appointmentDetail?.slotTime ?? "").components(separatedBy: " ")
        
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
    }
    
    func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
        
        let timeSlot = timeSlots[indexPath.row]
        formatter.dateFormat = "hh:mm a"
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        else
        {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        let time = formatter.string(from: timeSlot)
        cell.timeLabel.textColor = .black
        if self.lunchTiming.contains(time)
        {
            cell.timeLabel.textColor = .red
            cell.isUserInteractionEnabled = false
        }
        cell.timeLabel.text = time
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    func setTimeSlotsInformation()
    {
        if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
        {
            self.showActivity(text: "")
            let originalString = "&user_id=\(appointmentDetail?.userID ?? userid)&availablFromTime=\(appointmentDetail?.availableFromHours ?? "")&availablToTime=\(appointmentDetail?.availableToHours ?? "")&lunchFromTime=\(appointmentDetail?.breakFromTime ?? "")&lunchToTime=\(appointmentDetail?.breakToTime ?? "")&selectedSlotTime=\(appointmentDetail?.slotTime ?? "")&selectedDays=\(appointmentDetail?.availableDays ?? "")&locationTextfield=&locationLatitude=&locationLongitude=&notes=\(appointmentDetail?.notes ?? "")"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            var request = URLRequest(url: URL(string: Base_URL + kMethodSetTimeSlot + escapedString)!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              DispatchQueue.main.async {
                  self.hideActivity()
                  guard let data = data else {
                      print(String(describing: error))
                      return
                  }
                  let dict = self.convertToDictionary(text: String(data: data, encoding: .utf8)!)
                  if let response = dict?["response"] as? String, response == "1"
                  {
                      let alertController = UIAlertController(title: "", message: "Time Slot Modified Successfully.".localized as String?, preferredStyle: .alert)
                      let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                          self.navigationController?.popToRootViewController(animated: true)
                      }
                      alertController.addAction(yesAction)
                      self.present(alertController, animated: true, completion: nil)
                  }
                  else
                  {
                      print("response_Else",dict?["message"] as? String ?? "")
                  }
              }
            }
            task.resume()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getLunchInterwal(startFrom: String, end: String){
        
        let array: [String] = ["07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM","12:00AM"]
        if let startIndex = array.index(of: startFrom)
        {
            if let endindex = array.index(of: end)
            {
                for index in startIndex...endindex - 1
                {
                    lunchTiming.append(array[index])
                }
            }
        }
    }
    
}




