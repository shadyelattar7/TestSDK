//
//  CreditCard.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import ObjectMapper

class CreditCard: Mappable {
    var bankAlias1:String?
    var bankAlias2:String?
    var sc1:String?
    var sc2:String?
    var txn: String?
    var message: String?
    
    
    var cards:[CreditCard]{
        get{
            guard bankAlias1 != nil else {
                return []
            }
            guard bankAlias2 != nil && !bankAlias2!.isEmpty else {
                return [CreditCard(alias: self.bankAlias1!,sc: self.sc1)]
            }
            return [CreditCard(alias: self.bankAlias1!,sc: self.sc1),CreditCard(alias: self.bankAlias2!,sc: self.sc2)]
        }
    }
    
    
   
    
    init(alias:String,sc:String?){
        self.bankAlias1 = alias
        self.sc1 = sc
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.bankAlias1 <- map["BANKALIAS1"]
        self.bankAlias2 <- map["BANKALIAS2"]
        self.sc1 <- map["SC1"]
        self.sc2 <- map["SC2"]
        self.txn <- map["TXNSTATUS"]
        self.message <- map["MESSAGE"]
        
    }
    




}
