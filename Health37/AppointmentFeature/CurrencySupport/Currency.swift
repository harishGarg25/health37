//
//  currency.swift
//  getCurrency
//
//  Created by Gazolla on 08/01/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class Currency {
    
    var countryName:String?
    var countryCode:String?
    var currencyCode:String?
    var currencyName:String?
    var countrySubName:String?
    var currencySymbol:String?
    
    func loadEveryCountryWithCurrency() -> [Currency] {
        var result:[Currency]=[]
        let currencies = Locale.commonISOCurrencyCodes
        for currencyCode in currencies {
            
            let currency = Currency()
            currency.currencyCode = currencyCode
            
            let currencyLocale = Locale(identifier: currencyCode)
            currency.currencyName = (currencyLocale as NSLocale).displayName(forKey:NSLocale.Key.currencyCode, value: currencyCode)
            currency.countryCode = String(currencyCode.prefix(2))
            currency.currencySymbol = (currencyLocale as NSLocale).displayName(forKey:NSLocale.Key.currencySymbol, value: currencyCode)
            
            let countryLocale  = Locale.current
            let countryLocaleEnglish = NSLocale(localeIdentifier: "en_US")
            currency.countryName = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: currency.countryCode!)
            currency.countrySubName = countryLocaleEnglish.displayName(forKey: NSLocale.Key.countryCode, value: currency.countryCode!)

            if currency.countryName != nil {
                result.append(currency)
            }
            
        }
        return result
    }
 }

extension Currency:CustomStringConvertible {
    var description: String {
        return "\nCountryCode   : \(self.countryCode!)\nName         : \(self.countryName!)\nCurrencyCode : \(self.currencyCode!)\ncurrencyName: \(self.currencyName!)\ncurrencySymbol: \(self.currencySymbol!)\ncurrencySubName: \(self.countrySubName!)\n----------------------------"
    }
}
