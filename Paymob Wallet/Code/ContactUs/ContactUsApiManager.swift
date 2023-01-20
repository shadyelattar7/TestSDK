//
//  ContactUsApiManager.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ContactUsApiManager: ApiManager {
    
    override init() {
        super.init()
        currentEncryptionState = .AES
    }
    
    public func sendMessage(message: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE":"CONTACTUSREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "MESSAGE":message
        ]
        return connect(with: params)
    }
}
