//
//  File.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 6/17/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class Institution: Mappable {
    
    private var _Institution_code: String?
    private var _Logo_url: String?
    private var _Merchant_id: String?
    private var _Name_ar: String?
    private var _Name_en: String?
    private var _Customer_Identifier_Name_Ar: String?
    private var _Customer_Identifier_Name_En: String?
    private var _Customer_Identifier_Length: Int?
    private var _bill_reference_is_numeric: String?
    private var _bill_reference_length: Int?

    var institution_code: String {
        return self._Institution_code!
    }
    
    var logo_url: String {
        return self._Logo_url!
    }
    
    var merchant_id: String {
        return self._Merchant_id!
    }
    
    var name_ar: String {
        return self._Name_ar!
    }
    
    var name_en: String {
        return self._Name_en!
    }
    
    var name: String {
        return EntryPoint.langId == "en" ? self._Name_en! : self._Name_ar!
    }
    
    var identifierName: String {
        return EntryPoint.langId == "en" ? self._Customer_Identifier_Name_En! : self._Customer_Identifier_Name_Ar!
    }
    
    var identifierLength: Int {
        return self._Customer_Identifier_Length!
    }
    
    var bill_reference_is_numeric: String {
        return self._bill_reference_is_numeric!
    }
    
    var bill_reference_length: Int {
        return self._bill_reference_length!
    }
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self._Institution_code <- map["Institution_code"]
        self._Logo_url <- map["Logo_url"]
        self._Merchant_id <- map["Merchant_id"]
        self._Name_ar <- map["Name_ar"]
        self._Name_en <- map["Name_en"]
        self._Customer_Identifier_Name_En <- map["customer_identifier_name_en"]
        self._Customer_Identifier_Name_Ar <- map["customer_identifier_name_ar"]
        self._Customer_Identifier_Length <- map["customer_identifier_length"]
        self._bill_reference_is_numeric <- map["bill_reference_is_numeric"]
        self._bill_reference_length <- map["bill_reference_length"]
    }
}
