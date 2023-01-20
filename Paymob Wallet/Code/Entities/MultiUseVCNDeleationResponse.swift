//
//  MultiUseVCNDeleationResponse.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 9/21/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class MultiUseVCNDeleationResponse: Mappable {
    
    required init?(map: Map) {
        
    }
    
    var txn:String?
    var TXNID: String?
    var TRID: String?
    var EXTREFNUM: String?
    var MESSAGE: String?
    var TYPE: String?
    
    func mapping(map: Map) {
        self.txn <- map["TXNSTATUS"]
        self.TRID <- map["TRID"]
        self.TXNID <- map["TXNID"]
        self.EXTREFNUM <- map["EXTREFNUM"]
        self.MESSAGE <- map["MESSAGE"]
        self.TYPE <- map["TYPE"]
        
    }
}
