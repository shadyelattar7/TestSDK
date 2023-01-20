////
////  CashoutApiManager.swift
////  WalletsPaymob
////
////  Created by mahmoud gamal on 9/13/17.
////  Copyright © 2017 mahmoud gamal. All rights reserved.
////

import Foundation
import RxSwift

class CashoutApiManager: ApiManager{
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
    }
    
    public func cashout(pin: String, amount: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "OTTREQ",
            "MSISDN": mobile,
            "PIN": pin,
            "CEILAMOUNT": amount,
            "LANGUAGE1": "0",
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
}
