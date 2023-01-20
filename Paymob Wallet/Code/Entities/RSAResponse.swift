//
//  RSAResponse.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/17/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import ObjectMapper


class RSAResponse: Mappable {
     var symKey:String?
     var iv:String?
     var sessionID:String?
     var txnStatus:String?
     var msg:String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.symKey <- map["SYM_KEY"]
        self.iv <- map["IV"]
        self.sessionID <- map["SESSION_ID"]
        self.txnStatus <- map["TXNSTATUS"]
        self.msg <- map["MESSAGE"]
        
    }

}
