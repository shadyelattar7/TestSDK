//
//  PayApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift


class PayApiManager: ApiManager {
    
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .AES
        
    }
    
    
    public func parseQR(qrCode:String) -> Observable<Response>{
        let params=[
            "TYPE":"SCNQRREQ",
            "QRCODE":qrCode
        ]
        
        return self.connect(with: params)
        
    }

    public func inquireBill(pin:String,mobile:String,billNo:String,billerCode:String) -> Observable<Response>{
        let params=[
            "TYPE":"CONPLLREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "BILLREFNO":billNo,
            "BILLERCODE":billerCode,
            "NEW_APP": true
            ] as [String : Any]
        
        return self.connect(with: params)
        
    }
    
    public func rechargeMobile(pin:String,myMobile:String,toMobile:String,merchCode:String,amount:String) -> Observable<Response>{
        let params=[
            "TYPE":"CTMMREQ",
            "MSISDN":myMobile,
            "MSISDN2":toMobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "AMOUNT":amount,
            "MERCODE":merchCode
        ]
        return self.connect(with: params)
    }

    public func payBill(pin:String,amount:String,mobile:String,billNo:String,merchantCode:String, billName: String) -> Observable<Response>{
//        let params=[
//            "TYPE":"ONLNBPREQ",
//            "MSISDN":mobile,
//            "BLOCKSMS":"N",
//            "PIN":pin,
//            "AMOUNT":amount,
//            "BILLREFNO":billNo,
//            "MERCODE":merchantCode,
//            "SAVEBILL": Presenter.isFav,
//            "BILLNAME": billName
//
//            ] as [String : Any]
        
        let params=[
            "TYPE":"CMPREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "AMOUNT":amount,
            "ORDERNO":billNo,
            "MERCODE":merchantCode,
            "IS_RASEEDY_BILLER": true
            ] as [String : Any]
        
        return self.connect(with: params)
        
    }
    
    public func merchantPayf(pin:String,myMobile:String,amount:String,merchOrder:String,merchNo:String, bankAlias: String, additionalData: [String: String]) -> Observable<Response>{
        let params=[
            "TYPE":"CMPREQ",
            "MSISDN":myMobile,
            "BLOCKSMS":"N",
            "PIN":pin,
            "AMOUNT":amount,
            "ORDERNO":merchOrder,
            "BANKALIAS": bankAlias,
            "MERCODE":merchNo,
            "ADDITIONALDATA": additionalData
            ] as [String : Any]
        return self.connect(with: params)
    }
    
    func createVCN(pin:String,amount:String,mobile:String, type: String)-> Observable<VirtualCard>{
        
//        return dummyVCNS()
        
        let params: [String: Any] = [
            "TYPE":"VCNREQ",
            "MSISDN":mobile,
            "BLOCKSMS":"N",
            "AMOUNT":amount,
            "PIN":pin,
            "IS_MULTIUSE": true
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

    
//    private func dummyVCNS() ->  Observable<VirtualCard> {
//        let vcnObservable = PublishSubject<VirtualCard>()
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            let vcnDummy = VirtualCard(JSON: [
//                "CARDCVV":"123",
//                "CARDNUM":"\(Int.random(in: 1234...4321))\(Int.random(in: 1234...4321))\(Int.random(in: 1234...4321))\(Int.random(in: 1234...4321))",
//                "VALIDITY":"10/12/2020",
//                "CARDEXPIRY":"12/12/2020",
//                "TXNSTATUS":"200",
//                "MESSAGE":"Hello This iS Dummy VCN",
//                "BALANCE":1200.15,
//                "isMultiUse" : true
//            ])
//            vcnObservable.onNext(vcnDummy!)
//        }
//        return vcnObservable.asObservable()
//    }
    
    func deleteMultiUseVCN(pin: String, cardNumber: String, mobileNumber: String)-> Observable<MultiUseVCNDeleationResponse> {
        
//        return dummyDeletion()
        
        let params: [String: Any] = [
            "PIN" : pin,
            "MSISDN" : mobileNumber,
            "TYPE" : "VCNDELETEREQ",
            "CARD_NUMBER" : cardNumber,
        ]
        return connect(with: params)
    }
    
    private func dummyDeletion()-> Observable<MultiUseVCNDeleationResponse> {
        let obs = PublishSubject<MultiUseVCNDeleationResponse>()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            obs.onNext(MultiUseVCNDeleationResponse(JSON: ["TXNSTATUS":"200"])!)
        }
        return obs.asObservable()
    }
    
    
    func getVCNTypes(mobile: String)-> Observable<Response>{
        let params=[
            "TYPE":"GETVCNTYPEREQ",
            "MSISDN":mobile
            ]
        
        return self.connect(with: params)
    }
    
    func getFMer()-> Observable<Response>{
        let params=[
            "TYPE":"FEATMERREQ",
        ]
        
        return self.connect(with: params)
    }
    
    func getFavBills(mobile: String)-> Observable<Response>{
        let params=[
            "TYPE":"GETFAVBILLREQ",
            "MSISDN":mobile
            ]
        
        return self.connect(with: params)
    }
    
    func deleteFavBill(mobile: String, bill: FavBill)-> Observable<Response>{
        let params=[
            "TYPE":"DELFAVBILLREQ",
            "MSISDN":mobile,
            "BILL_CODE": bill.billCode!,
            "BILL_REFERENCE": bill.billReference!,
            "BILL_NAME": bill.billName!
        ]
        
        return self.connect(with: params)
    }
    
    func sendInqBills(mobile: String, selectedBills:[[String: Any]])-> Observable<Response>{
        let params=[
            "TYPE":"BULKBILLREQ",
            "MSISDN":mobile,
            "BILLS": selectedBills,
            "ACTION": "INQUIRE"
            ] as [String : Any]
        
        return self.connect(with: params)
    }
    
    func sendPayBills(mobile: String, selectedBills:[[String: Any]], pin: String)-> Observable<Response>{
        let params=[
            "TYPE":"BULKBILLREQ",
            "MSISDN":mobile,
            "BILLS": selectedBills,
            "ACTION": "PAY",
            "PIN": pin
            ] as [String : Any]
        
        return self.connect(with: params)
    }
    
    func getBillsStatus(mobile: String)-> Observable<Response>{
        let params=[
            "TYPE":"BULKBILLSTATUSREQ",
            "MSISDN":mobile
        ]
        
        return self.connect(with: params)
    }
    
    func cancelBulkInquiry(mobile: String)-> Observable<Response>{
        let params=[
            "TYPE":"CANCELBILLINQREQ",
            "MSISDN":mobile
        ]
        
        return self.connect(with: params)
    }
    
    func getAdImage()-> Observable<Response> {
        let params=[
            "TYPE":"GETADREQ",
            "NAME":"RaseedyVCN"
        ]
        
        return self.connect(with: params)
    }

}
