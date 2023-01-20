//
//  ConfirmationApiManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/29/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation

import RxSwift
class ConfirmApiManager: ApiManager{
    
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    
    public func getFees(type:String,mobile:String,toMobile:String?, amount:String?, isMultiUseVCN: Bool = false) -> Observable<Response>{
        var params: [String: Any] = [
            "TYPE":"FEEINQREQ",
            "SERVICETYPE": type,
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "IS_MULTIUSE": isMultiUseVCN
        ]
        
        if toMobile != nil {
            params["MSISDN2"]=toMobile
        }
        if amount != nil {
            params["AMOUNT"]=amount
        }
        
        return self.connect(with: params)
        
    }
    
    
}
