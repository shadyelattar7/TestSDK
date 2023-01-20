//
//  SendApiManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation

import RxSwift
class SendApiManager: ApiManager{
    
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    
    public func send(pin:String,mobile:String,toMobile:String, amount:String, msg: String?) -> Observable<Response>{
        
        var params=[
            "TYPE":"CTMREQ",
            "MSISDN":mobile,
            "MSISDN2":toMobile,
            "PIN":pin,
            "AMOUNT":amount,
            "BLOCKSMS":"N"
        ]
        if msg != nil && msg != "" {
            params["MESSAGE"] = msg!
        }
        
        return self.connect(with: params)
        
    }
    
    
}
