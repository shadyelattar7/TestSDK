//
//  HistoryApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class HistoryApiManager: ApiManager {
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    
    public func getAllHistory( mobile: String,page:Int) -> Observable<Response>{
        let params=[
            "TYPE":"CLTREQ",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "PAGE" : page
        ] as [String : Any]
        return   self.connect(with: params)
    }
    
    public func expoertPdf(email: String,mobile:String,pin:String) -> Observable<Response>{
        let params=[
            "TYPE":"EXPORTREQ",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "EMAIL":email,
            "PIN":pin
        ] as [String : Any]
        return   self.connect(with: params)
    }
}
