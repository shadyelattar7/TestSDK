//
//  FavBill.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/7/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class FavBill: Mappable {
    
    var billCode: String?
    var billReference: String?
    var billName: String?
    var amount: String?
    var isSelected: Bool = false
    var status: String?
    var fee: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.billCode <- map["BILLCODE"]
        self.billName <- map["BILLNAME"]
        self.billReference <- map["BILLREFERENCE"]
        self.amount <- map["AMOUNT"]
        self.status <- map["STATUS"]
        self.fee <- map["FEE"]
    }
    
}
