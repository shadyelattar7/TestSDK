//
//  VirtualCard.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

class VirtualCard: Object,Mappable {
    @objc dynamic var number:String?
    @objc dynamic var cvv:String?
    @objc dynamic var date:String?
    @objc dynamic var validity:String?
    @objc dynamic var expireDay:String?
//    @objc dynamic var amount:String?
    @objc dynamic var txn:String?
    @objc dynamic var msg:String?
    @objc dynamic var validityDate: String?
    private var _preBalance: String?
    private var _balance: Double?
    private var _preFormattedDate: String?
    private var _TXNID: String?
    private var _amountDouble:Double?
    private var _amountString:String?
    @objc dynamic var isMultiUse: Bool = true
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    var balance:String{
        get{
            if let balance = self._balance {
                let doubleStr = String(format: "%.2f", ceil(_balance!*100)/100)
                return doubleStr
            } else {
                return self._preBalance!
            }
        }
    }
    
    var amount:String?{
        get{
            if _amountString != nil{
                return _amountString
            }else if _amountDouble != nil{
                return "\(_amountDouble ?? 0.0 )"
            }else{
                return "0.0"
            }
        }
        set{
            _amountString = newValue
        }
    }
    
    var dateTime:String{
        get{
            if self._preFormattedDate == nil {
                return "Date is unavailable"
            }
            return getDateTimeFormated(foramte: "d MMM yyyy, EEEE h:mm a")
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
    
    func mapping(map: Map) {
        self.cvv <- map["CARDCVV"]
        self.number <- map["CARDNUM"]
        self._TXNID <- map["TXNID"]
        self._preFormattedDate <- map["DATETIME"]
        self.validity <- map["VALIDITY"]
        self.expireDay <- map["CARDEXPIRY"]
        self.txn <- map["TXNSTATUS"]
        self.msg <- map["MESSAGE"]
//        self.amount <- map["AMOUNT"]
        self._amountDouble <- map["AMOUNT"]
        self._amountString <- map["AMOUNT"]
        self._preBalance <- map["BALANCE"]
        self._balance <- map["BALANCE"]
        self.validityDate = getDateFormated(foramte: "MMM dd, yyyy, hh:mm a")

    }
    
    func getDateFormated(foramte:String)->String{
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        if let valid = validity {
            Util.debugMsg(valid)
            if let date = dateFormatter.date(from: valid) {
            dateFormatter.dateFormat = foramte
            dateFormatter.locale = Locale(identifier: "en_EG")
            return dateFormatter.string(from: date)
            }
        }
        return ""
    }
    func getDateTimeFormated(foramte:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self._preFormattedDate!) {
            dateFormatter.dateFormat = foramte
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    
}
