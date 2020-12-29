//
//  CurrencyController.swift
//  getCurrency
//
//  Created by Gazolla on 08/01/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class CurrencyController: UIViewController{
    
    // PRAGMA MARK: - Properties
    lazy var searchController:UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.alpha = 0
        self.definesPresentationContext = true
        search.searchBar.sizeToFit()
        return search
    }()
    
    let supportingCurrencyCode = ["AFN",
                                  "DZD",
                                  "ARS",
                                  "AMD",
                                  "AWG",
                                  "AUD",
                                  "AZN",
                                  "BSD",
                                  "BHD",
                                  "THB",
                                  "PAB",
                                  "BBD",
                                  "BYN",
                                  "BZD",
                                  "BMD",
                                  "VEF",
                                  "BOB",
                                  "BRL",
                                  "BND",
                                  "BGN",
                                  "BIF",
                                  "CAD",
                                  "CVE",
                                  "KYD",
                                  "GHS",
                                  "XOF",
                                  "XAF",
                                  "XPF",
                                  "CLP",
                                  "COP",
                                  "KMF",
                                  "CDF",
                                  "BAM",
                                  "NIO",
                                  "CRC",
                                  "HRK",
                                  "CUP",
                                  "CZK",
                                  "GMD",
                                  "DKK",
                                  "MKD",
                                  "DJF",
                                  "STD",
                                  "DOP",
                                  "VND",
                                  "XCD",
                                  "EGP",
                                  "SVC",
                                  "ETB",
                                  "EUR",
                                  "FKP",
                                  "FJD",
                                  "HUF",
                                  "GIP",
                                  "HTG",
                                  "PYG",
                                  "GNF",
                                  "GYD",
                                  "HKD",
                                  "UAH",
                                  "ISK",
                                  "INR",
                                  "IRR",
                                  "IQD",
                                  "JMD",
                                  "JOD",
                                  "KES",
                                  "PGK",
                                  "LAK",
                                  "EEK",
                                  "KWD",
                                  "MWK",
                                  "AOA",
                                  "MMK",
                                  "GEL",
                                  "LVL",
                                  "LBP",
                                  "ALL",
                                  "HNL",
                                  "SLL",
                                  "LRD",
                                  "LYD",
                                  "SZL",
                                  "LTL",
                                  "LSL",
                                  "MGA",
                                  "MYR",
                                  "TMT",
                                  "MUR",
                                  "MZN",
                                  "MXN",
                                  "MDL",
                                  "MAD",
                                  "NGN",
                                  "ERN",
                                  "NAD",
                                  "NPR",
                                  "ANG",
                                  "ILS",
                                  "RON",
                                  "TWD",
                                  "NZD",
                                  "BTN",
                                  "KPW",
                                  "NOK",
                                  "PEN",
                                  "MRO",
                                  "TOP",
                                  "PKR",
                                  "MOP",
                                  "UYU",
                                  "PHP",
                                  "GBP",
                                  "BWP",
                                  "QAR",
                                  "GTQ",
                                  "ZAR",
                                  "OMR",
                                  "KHR",
                                  "MVR",
                                  "IDR",
                                  "RUB",
                                  "RWF",
                                  "SHP",
                                  "SAR",
                                  "RSD",
                                  "SCR",
                                  "SGD",
                                  "SBD",
                                  "KGS",
                                  "SOS",
                                  "TJS",
                                  "LKR",
                                  "SDG",
                                  "SRD",
                                  "SEK",
                                  "CHF",
                                  "SYP",
                                  "BDT",
                                  "WST",
                                  "TZS",
                                  "KZT",
                                  "TTD",
                                  "MNT",
                                  "TND",
                                  "TRY",
                                  "AED",
                                  "UGX",
                                  "CLF",
                                  "USD",
                                  "UZS",
                                  "VUV",
                                  "KRW",
                                  "YER",
                                  "JPY",
                                  "CNY",
                                  "ZMW",
                                  "ZWL",
                                  "PLN"]
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .plain)
        tv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tv.dataSource = self
        tv.delegate = self
        tv.keyboardDismissMode = .onDrag
        tv.register(CurrencyCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    lazy  var leftButton:  UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(CurrencyController.dismissTapped(_:)))
    }()
    
    lazy var searchButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(CurrencyController.searchCurrency(_:)))
    }()
    
    var supportingCurrencies = [Currency]()
    var filteredCurrencies:[Currency] = []
    var selectedCurrencies:[String:Currency] = [:]
    
    
    // PRAGMA MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currencies:[Currency] = Currency().loadEveryCountryWithCurrency()
        for i in 0...currencies.count - 1
        {
            if supportingCurrencyCode.contains(currencies[i].currencyCode ?? "")
            {
                if (currencies[i].currencyCode ?? "") != "ILS"
                {
                    supportingCurrencies.append(currencies[i])
                }
            }
        }
        debugPrint(supportingCurrencies)
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.searchBar.alpha = 0
        self.navigationItem.rightBarButtonItem = self.searchButton
        self.title = "Select Currency"
    }
}


extension CurrencyController:UISearchBarDelegate, UISearchResultsUpdating {
    // PRAGMA MARK: - UISearchBarDelegate
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isAlphanumeric {
            self.filteredCurrencies = supportingCurrencies.filter{ currency in
                let stringMatch = currency.countrySubName!.lowercased().range(of: searchText.lowercased())
                return (stringMatch != nil)
            }
        }
        else {
            self.filteredCurrencies = supportingCurrencies.filter{ currency in
                let stringMatch = currency.countryName!.lowercased().range(of: searchText.lowercased())
                return (stringMatch != nil)
            }
        }
        self.tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismissSearchBar()
    }
    
    func dismissSearchBar(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.searchController.searchBar.alpha = 0
        }) { (Bool) -> Void in
            self.title = "Select one currency:"
            self.navigationItem.rightBarButtonItem = self.searchButton
        }
    }
    
    
    //PRAGMA MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //PRAGMA MARK: - search event Method
    @objc func searchCurrency(_ sender:UIButton){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = self.searchController.searchBar
            self.searchController.searchBar.alpha = 1
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.searchBar.text = ""
        })
    }
    
    @objc func dismissTapped(_ sender:UIBarButtonItem){
        self.searchController.isActive = false
        
        self.dismiss(animated: true) {
            let currencies:[Currency] =  self.selectedCurrencies.map{ $0.1 }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedCurrency"), object:currencies)
        }
    }
}

//PRAGMA MARK: - TableView Methods
extension CurrencyController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredCurrencies.count
        }
        return self.supportingCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyCell
        
        let currency:Currency
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = self.filteredCurrencies[(indexPath as NSIndexPath).row]
        } else {
            currency = self.supportingCurrencies[(indexPath as NSIndexPath).row]
        }
        
        if selectedCurrencies.count > 0 {
            let selected = selectedCurrencies[currency.currencyCode!]
            if selected != nil {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.currency = currency
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency:Currency
        
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = self.filteredCurrencies[(indexPath as NSIndexPath).row]
        } else {
            currency = self.supportingCurrencies[(indexPath as NSIndexPath).row]
        }
        
        selectCurrency(tableView, indexPath, currency)
    }
    
    func selectCurrency(_ tableView: UITableView, _ indexPath: IndexPath, _ currency: Currency){
        self.searchController.isActive = false
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedCurrency"), object:currency)
        }
    }
    
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
