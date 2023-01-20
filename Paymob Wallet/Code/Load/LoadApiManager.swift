//
//  LoadApiManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class LoadAPiManager: ApiManager {
   
        
        
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    
    public func getCreditCards(mobile:String) -> Observable<CreditCard>{
        let params=[
            "TYPE":"AVLINQREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"Y",
            ]
        return self.connect(with: params)
        
    }
    
    public func load(pin:String,alias:String,amount:String,mobile:String) -> Observable<Response>{
    
        let params=[
            "TYPE":"AVLREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "BANKALIAS":alias,
            "PIN":pin,
            "AMOUNT":amount
        ]
        return self.connect(with: params)
    }
    
    public func cashout(pin: String, amount: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "OTTREQ",
            "MSISDN": mobile,
            "PIN": pin,
            "CEILAMOUNT": amount,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
    public func cashin(pin: String, amount: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "OTTREQ",
            "MSISDN": mobile,
            "PIN": pin,
            "CEILAMOUNT": amount,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
}
