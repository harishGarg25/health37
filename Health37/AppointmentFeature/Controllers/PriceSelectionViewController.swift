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
import Frames


class PriceSelectionViewController: UIViewController,CardViewControllerDelegate {
    
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var priceSavingLabel: UILabel!
    @IBOutlet weak var doctorCountInfoLabel: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyText: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var countLable: UILabel!
    @IBOutlet weak var freeTrialButton: UIButton!
    @IBOutlet weak var freeTrialLable: UILabel!
    @IBOutlet weak var trialDurationLable: UILabel!

    var planPrice: [Slot] = []
    let timeslotecellID = "timeslotecell"
    var selectedDurationIndex: Int = -1
    var selectedPlan: String?
    var selectedCurrency: String?
    var cardTokenString = String()
    var amount = String()
    var packageMonths = String()
    var currencyRates = [String : Any]()
    var selected6MonthPrice = String()
    var selectedYearPrice = String()
    
    var appointmentDetail: AppointmentDetail?
    lazy var currencyCtrl:CurrencyController = {
        return CurrencyController()
    }()
    
    
    var cardViewController: CardViewController {
        let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_test_1a28ff38-51e9-4d27-a799-d15ba678a420",environment: .sandbox)
        let b = CardViewController(checkoutApiClient: checkoutAPIClient, cardHolderNameState: .normal, billingDetailsState: .hidden)
        //b.billingDetailsAddress = CkoAddress(addressLine1: "Test line1", addressLine2: "Test line2", city: "London", state: "London", zip: "N12345", country: "GB")
        //b.billingDetailsPhone = CkoPhoneNumber(countryCode: "44", number: "77 1234 1234")
        //b.addressViewController.setFields(address: b.billingDetailsAddress!, phone: b.billingDetailsPhone!)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            b.cardView.cardNumberInputView.textField.textAlignment = .left
            b.cardView.cardHolderNameInputView.textField.textAlignment = .left
            b.cardView.expirationDateInputView.textField.textAlignment = .left
            b.cardView.cvvInputView.textField.textAlignment = .left
        }
        b.navButton.setTitle("Pay".localized, for: .normal)
        b.title = "Payment".localized
        b.cardView.acceptedCardLabel.text = "Accepted Cards".localized
        b.cardView.cardNumberInputView.label.text = "Card Number*".localized
        b.cardView.cardHolderNameInputView.label.text = "Cardholder's Name".localized
        b.cardView.expirationDateInputView.label.text = "Expiration Date*".localized
        b.cardView.cvvInputView.label.text = "CVV*".localized
        b.delegate = self
        return b
    }
    
    
    @IBAction func selectCurrency(_ sender: Any) {
        let navCtrl = UINavigationController(rootViewController: self.currencyCtrl)
        self.navigationController!.present(navCtrl, animated: true) {}
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if selectedDurationIndex < 0
        {
            self.onShowAlertController(title: "Alert".localized , message: "Please Select Plan".localized)
        }else
        {
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch status {
        case .success:
            print(cardToken!.token)
            if let token = cardToken?.token
            {
                cardTokenString = token
                paymentAPI()
            }
        case .failure:
            print("failure")
        }
    }
    
    func onSubmit(controller: CardViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.cat_parent_id != "4"
        {
            doctorCountInfoLabel.text = ""
        }
        self.navigationItem.addSettingButtonOnRight(title: "Back")
        self.title = "Subscription".localized
        titleLable.text = "SELECT PLAN".localized
        countLable.text = "You can add up to 100 doctors".localized
        continueButton.setTitle("SUBSCRIBE".localized, for: .normal)
        freeTrialLable.text = "Free Trial".localized
        trialDurationLable.text = "2 Months".localized
        cardViewController.delegate = self
        cardViewController.availableSchemes = [.visa, .mastercard, .maestro]
        continueButton.disableButton()
        planPrice = Slot.planPrice()
        timeSlotCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: timeslotecellID)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            countLable.textAlignment = .right
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(PriceSelectionViewController.selectedCurrency(_:)), name: NSNotification.Name(rawValue: "selectedCurrency"), object: nil)
        
        if let currencyRate = appDelegate.currencyRates as? [String : Any]
        {
            if currencyRate.count > 0
            {
                currencyRates = currencyRate
            }else
            {
                self.showActivity(text: "")
                getCurrencyValue()
            }
        }
    }
    
    
    @objc func selectedCurrency(_ notification:Notification){
        if let currencies = notification.object as? Currency
        {
            selectedCurrency = currencies.currencyCode
            currencyText.text = currencies.currencyName
            debugPrint("\(currencies.countryCode ?? "").png")
            currencyImage.image = UIImage.init(named: "\(currencies.countryCode ?? "").png")
            print(getSymbolForCurrencyCode(code: currencies.currencyCode ?? "")!)
            if let currency = self.currencyRates["\(currencies.currencyCode ?? "")"] as? String
            {
                selected6MonthPrice = String(format: "%.2f", (currency as NSString).floatValue * 187)
                selectedYearPrice = String(format: "%.2f", (currency as NSString).floatValue * 347)
                let priceFirst = "\(getSymbolForCurrencyCode(code: currencies.currencyCode ?? "")!) \(selected6MonthPrice)"
                let priceSecond = "\(getSymbolForCurrencyCode(code: currencies.currencyCode ?? "")!) \(selectedYearPrice)"
                updatePlanPrice(first: priceFirst,second: priceSecond)
            }
        }
    }
    
    func updatePlanPrice(first: String,second: String){
        if first != ""
        {
            let t1 = Slot(title: first, descrition: "6 Months", days: "6")
            let t2 = Slot(title: second, descrition: "1 Year", days: "12")
            planPrice = [t1,t2]
            self.timeSlotCollectionView.reloadData()
        }
    }
    
    func getSymbolForCurrencyCode(code: String) -> String?
    {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardViewController.addressViewController.setCountrySelected(country: "GB", regionCode: "GB")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [timeSlotCollectionView].forEach { (collectionView) in
            collectionView?.layer.borderColor = Color.theme.cgColor
            collectionView?.layer.borderWidth = 1
            collectionView?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func paymentAPI()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodPayment, Details: self.paymentParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        self.enableAppointment()
                    }
                    else
                    {
                        self.hideActivity()
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
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
    
    @objc func enableAppointment()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodEnableAppointment, Details: self.getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        if UserDefaults.standard.cat_parent_id != "4"
                        {
                            self.setTimeSlotsInformation()
                        }else
                        {
                            self.hideActivity()
                            let alertController = UIAlertController(title: "", message: "Appointment Feature Enabled.".localized as String?, preferredStyle: .alert)
                            let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            alertController.addAction(yesAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        self.hideActivity()
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
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
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
        if UserDefaults.standard.object(forKey: "catID") != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: "catID")!, forKey: "user_cat_id" as NSCopying)
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
    
    func paymentParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
        dictUser.setObject(cardTokenString, forKey: "token" as NSCopying)
        dictUser.setObject(packageMonths == "6" ? selected6MonthPrice : selectedYearPrice, forKey: "amount" as NSCopying)
        dictUser.setObject(selectedCurrency ?? "", forKey: "currency" as NSCopying)
        dictUser.setObject(packageMonths, forKey: "package_months" as NSCopying)
        
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
    
    
    func setTimeSlotsInformation()
    {
        
        if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
        {
            self.showActivity(text: "")
            let originalString = "&user_id=\(userid)&availablFromTime=\(appointmentDetail?.availableFromHours ?? "")&availablToTime=\(appointmentDetail?.availableToHours ?? "")&lunchFromTime=\(appointmentDetail?.breakFromTime ?? "")&lunchToTime=\(appointmentDetail?.breakToTime ?? "")&selectedSlotTime=\(appointmentDetail?.slotTime ?? "")&selectedDays=\(appointmentDetail?.availableDays ?? "")&locationTextfield=&locationLatitude=&locationLongitude=&notes=\(appointmentDetail?.notes ?? "")"
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
                        let alertController = UIAlertController(title: "", message: "Appointment Feature Enabled.".localized as String?, preferredStyle: .alert)
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
    
    
    func getCurrencyValue()  {
        var request = URLRequest(url: URL(string: "https://api.currencyfreaks.com/latest?apikey=cef977aac8ef41358975a0363e5c3a07")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.hideActivity()
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                if let jsonString = String(data: data, encoding: .utf8)
                {
                    let dict = self.convertToDictionary(text: jsonString)
                    if let rates = dict?["rates"] as? [String : Any]
                    {
                        debugPrint(rates)
                        self.currencyRates = rates
                        self.appDelegate.currencyRates = rates
                    }
                }
            }
        }
        task.resume()
    }
}


extension PriceSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeSlotCollectionView{
            return planPrice.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeSlotCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeslotecellID, for: indexPath) as! SlotsCollectionViewCell
            selectedDurationIndex == indexPath.row ? cell.selectCell() : cell.deSelectCell()
            cell.configure(with: planPrice[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == timeSlotCollectionView{
            selectedDurationIndex = indexPath.row
        }
        selectedPlan = planPrice[indexPath.row].title
        packageMonths = planPrice[indexPath.row].days
        priceSavingLabel.isHidden = indexPath.row == 0 ? true : false
        continueButton.enableButton()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionviewwidth = collectionView.frame.width
        if collectionView == timeSlotCollectionView{
            let multiplier = (2*(planPrice.count-1))/planPrice.count
            let w = (collectionviewwidth)/CGFloat(planPrice.count) * CGFloat(multiplier)
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


extension PriceSelectionViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
