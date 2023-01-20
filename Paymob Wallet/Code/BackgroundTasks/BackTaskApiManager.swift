//
//  BackTaskApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/13/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class BackTaskApiManager: AuthApiManager {
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .none
        
    }
    
    public func getMinVersion(mobile: String) -> Observable<Response>{
        let params=[
            "TYPE":"GETMINVERSIONREQ",
            "MSISDN": mobile,
            "LANGUAGE1": "1",
            "BLOCKSMS": "N",
            "OS": "iOS"
        ]
        return   self.connect(with: params)
    }
    
}
