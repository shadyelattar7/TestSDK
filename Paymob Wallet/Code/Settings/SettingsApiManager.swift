//
//  SettingsApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class SettingsApiManager: ApiManager {
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    public func resetMPin(pin: String, newPin: String, confPin: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE":"CCPNREQ",
            "MSISDN": mobile,
            "PIN":pin,
            "NEWPIN":newPin,
            "CONFIRMPIN":confPin,
            "BLOCKSMS":"N"
        ]
        return   self.connect(with: params)
    }
}
