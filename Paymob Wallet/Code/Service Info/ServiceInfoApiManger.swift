//
//  ServiceInfoApiManger.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ServiceInfoApiManger: ApiManager{
    
    override init() {
        super.init()
        self.currentEncryptionState = .AES
    }
    
    public func serviceInfo() -> Observable<Response>{
        let params=[
            "TYPE": "SIREQ",
            "BLOCKSMS": "N",
        ]
        return   self.connect(with: params)
    }
}

