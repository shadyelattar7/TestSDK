//
//  TopUpApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 11/15/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

enum TopupType: String{
    case mashroey = "MSHRY"
    case tasahel  = "TSAHL"
}

class TopUpApiManager: ApiManager{

    override init() {
        super.init()

        self.currentEncryptionState = .AES
    }

//    public func staticBillIquiry(amount: String?, mobile: String, type: TopupType) -> Observable<Response>{
//        let params=[
//            "TYPE": "STATICBILLINQREQ",
//            "MSISDN": mobile,
//            "BILLREFERENCE": pin,
//            "BILLER": type.rawValue,
//            "AMOUNT": amount ?? "",
//            "BLOCKSMS": "N",
//            "SERVICECODE": "ACSOT"
//        ]
//        return   self.connect(with: params)
//    }
}
extension PayApiManager {
    
    public func staticBillIquiry(mobile: String, type: String, billRef: String) -> Observable<Response>{
        let params = [
            "TYPE": "STATICBILLINQREQ",
            "MSISDN": mobile,
            "BILLREFERENCE": billRef,
            "BILLER": type,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT",
        ]
        return   self.connect(with: params)
    }
    
    public func staticBillIPay(mobile: String, billRef: String, pin: String, amount: String, merchantCode: String, billFees: String) -> Observable<Response>{
        //            "TYPE": "ONLNBPREQ",
        let params: [String: Any] = [
            "IS_RASEEDY_BILLER": true,
            "TYPE": "CMPREQ",
            "MSISDN": mobile,
            "PIN": pin,
            "AMOUNT": amount,
            "MERCODE": merchantCode,
            "BILLREFNO": billRef,
            "CONVFEES": billFees,
            "ORDERNO" : billRef
//            "ORDERNO": billRef,
        ]
        return self.connect(with: params)
    }
    
    
    
    
    public func staticBillFeesIquiry(amount: String, mobile: String, type: String, billRef: String) -> Observable<Response>{
        let params = [
            "TYPE": "STATICFEESINQREQ",
            "MSISDN": mobile,
            "REF": billRef,
            "AMOUNT": amount,
            "BILLER": type,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT",
            
            ]
        return   self.connect(with: params)
    }
    
    public func TopUpList(mobile: String) -> Observable<Response>{
        let params: [String: Any] = [
            "MSISDN":mobile,
            "TYPE":"DYNINSREQ"
        ]
        return self.connect(with: params)
    }
}






