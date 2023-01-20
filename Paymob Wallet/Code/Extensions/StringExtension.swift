//
//  StringExtension.swift
//  Paymob Wallet
//
//  Created by Al-attar on 26/09/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation


extension String{
    var toPhoneFormate: String{
        let str = Array(self)
        var res = self
        
        if str.count > 11{
            if str[0] == "+" && str[1] == "2"{
                res = String(res.dropFirst(2))
            }else if str[0] == "2"{
                res = String(res.dropFirst(1))
            }
        }
        return res
        
    }
    
    var merchantIDIsValid: Bool{
        if self.count >= 9 && self.count <= 14{
            return true
        }
        return false
    }
 
    var localized: String {
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        let localizedString = NSLocalizedString(self, tableName: nil, bundle: bundle!, value: self, comment: "")
        return localizedString
    }
}

