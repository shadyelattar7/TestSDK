//
//  Response.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/28/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import ObjectMapper

class Response:Mappable,Error {
    private var _msg:String?
    private var _txn:String?
    private var _type:String?
    private var _preFormattedDate: String?
    private var _dateTime:String?
    var fees:Double?
    var topUpFees: String?
    var topUpRef: String?
    private var _notifications: [Notification]?
    private var _numberOfUnreadNoti: Int?
    private var _featuredMert: [FeatMerchant]?
    var appId:String?
    private var _histories: [History]?
    private var _balance: Double?
    private var _minVer: Double?
    
    private var _qrAmount: String?
    private var _qrMerCode: String?
    private var _qrBillRefNumber: String?
    private var _SERVICE_RATING_ENABLED: Bool?
    private var _isPinSet: Bool?
    private var _isActivated: Bool?
    private var _preBalance: String?
    private var _vcns: [VirtualCard]?


    /// new qr code
    
    private var _qrCRC :String?
    private var _qrMerchantName: String?
    private var _qrMerchantId: String?
    
    /// consumer pull
    
    private var _amount: String?
    private var _billerCode: String?
    private var _billerName: String?
    private var _billRefNum: String?
    private var _billStatus: String?
    private var _dueDate: String?
    private var _paymentDate: String?
    
    // new registeration
    
    private var _pKey: String?
    
    // new vcn card types
    
    var vcnTypes: [VCNType]?
    
    var favBills: [FavBill]?
    
    // bill payment aliases
    var bankAlias1: String?
    var bankAlias2: String?
    
    // vcn ads
    var _adImage: String?
    var _adUrl: String?
    private var _TXNID: String?
    private var _TRID: String?
    // profile data
    var userName: String?
    var userMail: String?
    var userAddress: String?
    var userGender: String?
    var userNationalId: String?
    var userDateOfBirth: String?
    
    var clientName: String?
    
    /// new qr code
    private var _qrDataDic: [String: String]?
    private var _qrReDataarr: [String]?
    private var _qrFees: String?
    private var _qrFeesPercentage: String?
    private var _qrTip: String?
    private var _ServiceInfo : [ServiceInfoEntity]?
    private var _NUMPAGES : Int?
    /// Top Up
    var _institutions: [Institution]?
    //Cashout
    private var _OTP: String?


    
    var msg:String{
        get{
            if self._msg == nil {
                return "Service is unavailable, please try again later "
            }
            return self._msg!
        }
    }
    
    var dateTime:String{
        get{
            if self._preFormattedDate == nil {
                return "Date is unavailable"
            }
            return getDateFormated(foramte: "d MMM yyyy, EEEE h:mm a")
        }
    }
    
    var qrDataDic: [String: String]? {
        get {
            return self._qrDataDic
        }
    }
    
    var qrReDataArr: [String]? {
        get {
            return self._qrReDataarr
        }
    }
    var NUMPAGES:Int{
        get{
            return self._NUMPAGES ?? 0
        }
    }
    var qrFees: String? {
        get {
            return self._qrFees
        }
    }
    
    var qrFeesPerc: String? {
        get {
            return self._qrFeesPercentage
        }
    }
    
    var qrTip: String? {
        get {
            return self._qrTip
        }
    }
    
    var vcns: [VirtualCard] {
            get{
                return self._vcns ?? []
            }
        }
    
    var minVersion: Double{
        get{
            if self._minVer == nil {
                return 0.0
            }
            return self._minVer!
        }
    }
    
    var SERVICE_RATING_ENABLED: Bool {
        get{
            return (self._SERVICE_RATING_ENABLED ?? false)
        }
    }
    
    var ServiceInfo : [ServiceInfoEntity] {
        get{
            return self._ServiceInfo!
        }
    }
    
    var TXNID: String{
        get{
            if self._TXNID == nil {
                return ""
            }
            return self._TXNID!
        }
    }
    
    var TRID: String{
        get{
            if self._TRID == nil {
                return ""
            }
            return self._TRID!
        }
    }
    
    
    var balance:String{
        get{
            if let balance = self._balance {
            let doubleStr = String(format: "%.2f", ceil(_balance!*100)/100)
            return doubleStr
            } else {
                return self._preBalance ?? "0"
            }
        }
    }
    
    var txn:String?{
        get{
            if self._txn == nil {
                return "001"
            }
            return self._txn!
        }
    }
    var type:String?{
        get{
            return self._type!
        }
    }
    
    var notifications: [Notification] {
        get{
            if self._notifications == nil {
                return []
            }
            return self._notifications!
        }
    }
    
    var featMerchants: [FeatMerchant] {
        get{
            return self._featuredMert!
        }
    }
    
    var histories: [History] {
        get{
            return self._histories!
        }
    }
    
    var numberOfUnreadNoti: Int {
        get{
            return self._numberOfUnreadNoti!
        }
    }
    
    var qrAmount: String {
        get{
            return self._qrAmount!
        }
    }

    
    var qrMerCode: String {
        get{
            return self._qrMerCode!
        }
    }

    
    var qrBillRefNumber: String {
        get{
            return self._qrBillRefNumber!
        }
    }

    
    var isPinSet: Bool {
        get{
            return self._isPinSet!
        }
    }
    
    var isActivated: Bool {
        get{
            return self._isActivated!
        }
    }
    
    var qrCRC: String?{
        get{
            return self._qrCRC
        }
    }
    
    var qrMerchantId: String {
        get{
            return self._qrMerchantId!
        }
    }
    
    var qrMerchantName: String {
        get{
            return self._qrMerchantName ?? "merchant name is empty"
        }
    }
    

    /// consumer pull
    var amount: String {
        get {
            return self._amount!
        }
    }
    
    var billerName: String {
        get {
            return self._billerName!
        }
    }
    
    var billerCode: String {
        get {
            return self._billerCode!
        }
    }
    
    var billStatus: String {
        get {
            return self._billStatus!
        }
    }
    
    var billRefNum: String {
        get {
            return self._billRefNum!
        }
    }
    
    var dueDate: String {
        get {
            return self._dueDate!
        }
    }
    
    // new registeration
    var pKey: String {
        get {
            return self._pKey!
        }
    }
    
    //vcn ads
    var adImage: String {
        get {
            return self._adImage!
        }
    }
    
    var adUrl: String {
        get {
            return self._adUrl!
        }
    }
    
    var duePenalty: Double?
    
    var installmentId: String?
    
    required init?(map: Map) {
        
    }
    
    var institutions: [Institution] {
        get{
            return self._institutions!
        }
    }
    
    var OTP: String {
        get{
            return self._OTP ?? "      "
        }
    }
    
    init(errorMsg:String,txn:String){
        self._msg = errorMsg
        self._txn = txn
    }
    
    
    
    
    
    func mapping(map: Map) {
        self._msg <- map["MESSAGE"]
        self._preFormattedDate <- map["DATETIME"]
        self._txn <- map["TXNSTATUS"]
        self._type <- map["TYPE"]
        self.appId <- map["APP_ID"]
        self.fees <- map["FEES"]
        self.topUpFees <- map["FEES"]
        self.topUpRef <- map["REF"]
        self._notifications <- map["Objects"]
        self._numberOfUnreadNoti <- map["NUMBER_OF_NOTIFICATIONS"]
        self._histories <- map["DATA"]
        self._preBalance <- map["BALANCE"]
        self._balance <- map["BALANCE"]
        //self._balance <- map["BALANCE"]
        self._minVer <- map["Minimum_Version"]
        self._qrAmount <- map["AMOUNT"]
        self._qrMerCode <- map["MERCODE"]
        self._qrBillRefNumber <- map["BILLREFNO"]
        self._isPinSet <- map["IS_PIN_SET"]
        self._isActivated <- map["IS_VERIFIED"]
        self._featuredMert <- map["ARRAY"]
        self._qrCRC <- map["CRC"]
        self._qrMerchantName <- map["Merchant_Name"]
        self._qrMerchantId <- map["Masterpass_QR_Merchant_ID"]
        
        ///consumer pull
        self._dueDate <- map["DUE_DATE"]
        self._amount <- map["AMOUNT"]
        self._billerCode <- map["BILLERCODE"]
        self._billerName <- map["BILLERNAME"]
        self._billRefNum <- map["BILLREFNO"]
        self._billStatus <- map["BILL_STATUS"]
        
        ///new Registeration
        self._pKey <- map["KEY"]
        
        // new vcn types
        self.vcnTypes <- map["OBJECTS"]
        self._vcns <- map["VCNS"]
        
        self.favBills <- map["OBJECTS"]
        
        //new Billpayment aliases
        self.bankAlias1 <- map["BANKALIAS1"]
        self.bankAlias2 <- map["BANKALIAS2"]

        // vcn ads
        self._adImage <- map["IMAGE"]
        self._adUrl <- map["URL"]
        
        // user profile
        self.userName <- map["FULLNAME"]
        self.userMail <- map["EMAIL"]
        self.userAddress <- map["ADDRESS"]
        self.userGender <- map["GENDER"]
        self.userNationalId <- map["NATIONALID"]
        self.userDateOfBirth <- map["DATEOFBIRTH"]
        self._NUMPAGES <- map["NUMPAGES"]
        self._ServiceInfo <- map["INFO"]
        self._TXNID <- map["TXNID"]
        self._TRID <- map["TRID"]
        self._qrDataDic <- map["DATA"]
        self._qrReDataarr <- map["RETURNED_DATA"]
        self._qrTip <- map["Tip"]
        self._qrFees <- map["Convenience Fees"]
        self._qrFeesPercentage <- map["Convenience Fees (%)"]
        self.clientName <- map["CLIENT_NAME"]
        self._SERVICE_RATING_ENABLED <- map["SERVICE_RATING_ENABLED"]
        self.duePenalty <- map["DUE_PENALTY"]
        self.installmentId <- map["INSTALLMENT_ID"]
        
        self._institutions <- map["INSTITUTIONS"]
        self._OTP <- map["OTTVAL"]
    }
    
    func getDateFormated(foramte:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self._preFormattedDate!) {
            dateFormatter.dateFormat = foramte
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
