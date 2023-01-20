//
//  NotificationApiManager.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/18/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import Foundation
import RxSwift

enum NotificatinAction: String {
    case delete = "DELETE"
    case read = "READ"
}

class NotificationApiManager: ApiManager {
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    public func getAllHistory( mobile: String) -> Observable<Response>{
        let params=[
            "TYPE":"CLTREQ",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "NOOFTXN": 3,
            "PAGE" : 1
        ] as [String : Any]
        return   self.connect(with: params)
    }
    
    public func getAllNotification(mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "GETUSERNOTI",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
    public func setNotification(dateTime: String, mobile: String, action: NotificatinAction) -> Observable<Response>{
        let params=[
            "TYPE": "SETUSERNOTI",
            "MSISDN": mobile,
            "DATETIME": dateTime,
            "ACTION": action.rawValue,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
    public func deleteAllNotifications(mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "DELALLNOTI",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
    public func acceptCashout(pin: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE": "RCORREQ",
            "MSISDN": mobile,
            "MSISDN2": notification.data.agentNum,
            "AMOUNT": notification.data.amount,
            "PIN": pin,
            "DATETIME": notification.data.preFormattedDate,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
    public func rejectCashout(pin: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE": "RCORREQ",
            "MSISDN": mobile,
            "MSISDN2": notification.data.agentNum,
            "AMOUNT": notification.data.amount,
            "PIN": pin,
            "DATETIME": notification.data.preFormattedDate,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT",
            "REJECT" : "Y"
        ]
        return   self.connect(with: params)
    }
    
    public func acceptCashIn(pin: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE": "ARCICREQ",
            "MSISDN": mobile,
            "MSISDN2": notification.data.agentNum,
            "AMOUNT": notification.data.amount,
            "PIN": pin,
            "DATETIME": notification.data.preFormattedDate,
            "RRN": notification.data.rnn,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT",
            "REJECT" : "N"
        ]
        return   self.connect(with: params)
    }
    
    public func rejectCashIn(pin: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE": "ARCICREQ",
            "MSISDN": mobile,
            "MSISDN2": notification.data.agentNum,
            "AMOUNT": notification.data.amount,
            "PIN": pin,
            "DATETIME": notification.data.preFormattedDate,
            "RRN": notification.data.rnn,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT",
            "REJECT" : "Y"
        ]
        return   self.connect(with: params)
    }
    
    public func billPayment(pin: String, amount: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE":"ONLNBPREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "AMOUNT":amount,
            "BILLREFNO":notification.data.billRefNum,
            "MERCODE":notification.data.billerCode
        ]
        return   self.connect(with: params)
    }
    
    public func consumerPull(pin: String, amount: String, mobile: String, notification: Notification) -> Observable<Response>{
        let params=[
            "TYPE":"CONPLLREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "AMOUNT":amount,
            "BILLREFNO":notification.data.billRefNum,
            "BILLERCODE":notification.data.billerCode
        ]
        return   self.connect(with: params)
    }
    
    
    public func merchantPayf(pin: String, myMobile: String, amount: String, merchOrder: String, merchNo: String, additionalData: [String: String], ref1: String?, ref2: String?) -> Observable<Response> {
        var params: [String: Any] = [:]
        let params1 = [
            "TYPE": "CMPREQ",
            "MSISDN": myMobile,
            "BLOCKSMS": "N",
            "PIN": pin,
            "AMOUNT": amount,
            "ORDERNO": merchOrder,
            "MERCODE": merchNo,
            "ADDITIONALDATA": additionalData
            ] as [String : Any]
        params = params1
        if let ref1 = ref1, let ref2 = ref2 {
            params["REF1"] = ref1
            params["REF2"] = ref2
        }
        return connect(with: params)
    }
    
    
    public func parseQR(qrCode: String) -> Observable<Response>{
        let params=[
            "TYPE":"SCNQRREQ",
            "QRCODE":qrCode
        ]
        return self.connect(with: params)
    }
    
    func getVCNList(pin:String,mobile:String)-> Observable<Response>{
        let params: [String: Any] = [
            "TYPE":"ACTIVEVCNREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "PIN":pin
        ]
        return connect(with: params)
    }
}
