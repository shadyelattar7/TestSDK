//
//  UnregisterApiManager.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class UnregisterApiManager: ApiManager{
    
    override init() {
        super.init()
        self.currentEncryptionState = .AES
    }
    
    public func checkUnregister(pin: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "UNREGAUTHREQ",
            "MSISDN": mobile,
            "PIN": pin
        ]
        return   self.connect(with: params)
    }
    
    public func unregister(otp: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "UNREGREQ",
            "MSISDN": mobile,
            "OTP": otp
        ]
        return   self.connect(with: params)
    }
}
