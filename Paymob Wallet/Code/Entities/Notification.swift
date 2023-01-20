//
//  Notification.swift
//  Paymob Wallet
//
//  Created by mahmoud on 9/28/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class Notification: Mappable {
    
    private var _read: Bool?
    private var _date = NotificationData()
    
    var read: Bool {
        get{
            return self._read ?? true
        }
    }
    
    var data: NotificationData {
        get{
            return self._date
        }
    }
    
    init() {
        
    }
    
    required init?(map: Map) {
        self._date = NotificationData(map: map["data"])!
    }
    
    func mapping(map: Map) {
        self._read <- map["read"]
        self._date <- map["data"]
    }
}

class NotificationData: Mappable {
    
    private var _type: String?
    private var _message: String?
    private var _dateTime: String?
    private var _agentId: String?
    private var _agentNum: String?
    private var _amount: String?
    private var _billerCode: String?
    private var _billerName: String?
    private var _billRefNum: String?
    private var _billStatus: String?
    private var _dueDate: String?
    private var _paymentDate: String?
    private var _preFormattedDate: String?
    private var _rrn: String?
    private var _r2PData: [String: String]?
    private var _TXNID: String?
    private var _SERVICE_RATING_ENABLED:Bool?
    var type: String {
        get {
            return self._type ?? "type is Empty"
        }
    }
    
    var message: String {
        get {
            return self._message ?? "Message is Empty"
        }
    }
    var SERVICE_RATING_ENABLED :Bool{
        get{
            return self._SERVICE_RATING_ENABLED ?? false
        }
    }
    var TXNID: String {
        get {
            return self._TXNID ?? ""
        }
    }
    var dateTime: String {
        get {
            return self._dateTime ?? "date is empty"
        }
    }
    
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
    
    var agentNum: String {
        get {
            return self._agentNum!
        }
    }
    
    var agentId: String {
        get {
            return self._agentId!
        }
    }
    
    var preFormattedDate: String {
        get {
            return self._preFormattedDate!
        }
    }
    
    var rnn: String {
        get {
            return self._rrn!
        }
    }
    var r2PData: [String: String]? {
        return _r2PData
    }
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self._type <- map["type"]
        self._message <- map["message"]
        self._preFormattedDate <- map["datetime"]
        self._dueDate <- map["due_date"]
        self._agentId <- map["agent_id"]
        self._agentNum <- map["agent_number"]
        self._amount <- map["amount"]
        self._billerCode <- map["biller_code"]
        self._billerName <- map["biller_name"]
        self._billRefNum <- map["bill_ref_no"]
        self._billStatus <- map["bill_status"]
        self._paymentDate <- map["payment_date"]
        self._rrn <- map["rrn"]
        self._r2PData <- map["r2p_data"]
        self._TXNID <- map["TXNID"]
        self._SERVICE_RATING_ENABLED <- map["SERVICE_RATING_ENABLED"]
        Util.debugMsg(self._amount)
        
        self._dateTime = getDateFormated(foramte: "h:mm a - EEEE, d MMM yyyy")
    }
    
//    func getDateFormated(foramte:String)->String{
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//
//        if let date = dateFormatter.date(from: self._preFormattedDate!) {
//            dateFormatter.dateFormat = foramte
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            return dateFormatter.string(from: date)
//        }
//        return ""
//  }
    
    func getDateFormated(foramte:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self._preFormattedDate!) {
            dateFormatter.dateFormat = foramte
            if (Date().hours(from: date) < 24){
                return Date().offset(from: date)
            }else{
                return dateFormatter.string(from: date)
            }
        } else {
            return ""
        }
    }

}
