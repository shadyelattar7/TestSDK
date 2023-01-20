//
//  WebViewTransaction.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import ObjectMapper

class WebViewTransaction: Mappable {
    var msgType:String?
    var merchantId:String?
    var receipientMobile:String?
    var amount:Double?
    var merchantName:String?
    var billReference:String?
    
    required  init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.msgType <- map["message_type"]
        self.merchantId <- map["merchant_id"]
        self.amount <- map["amount"]
        self.receipientMobile <- map["receipient_mobile"]
        self.merchantName <- map["merchant_name"]
        self.billReference <- map["bill_reference"]
        
    }
 
}
