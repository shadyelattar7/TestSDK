//
//  RateApiManager.swift
//  Paymob Wallet
//
//  Created by mac on 13/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

class RateApiManager: ApiManager {
    
    override init() {
        super.init()
        currentEncryptionState = .AES
    }
    
    public func rate( mobile: String, TXNID: String?, RATING: String?) -> Observable<Response> {
        var params = [
            "TYPE": "RATINGREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N"
        ]
        
        if TXNID != nil {
            params["TXNID"]=TXNID
        }
        
        if RATING != nil {
            params["RATING"]=RATING
        }
        return connect(with: params)
    }
    
    public func Feedback( mobile: String, MESSAGE: String?) -> Observable<Response> {
        var params = [
            "TYPE": "CONTACTUSREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N"
        ]
        
        
        if MESSAGE != nil {
            params["MESSAGE"]=MESSAGE
        }
        return connect(with: params)
    }
}
