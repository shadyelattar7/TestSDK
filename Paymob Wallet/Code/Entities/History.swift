//
//  History.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class History: Mappable {
    
    private var _time: String?
    private var _txnId: String?
    private var _amount: Double?
    private var _isRecieved: Bool?
    private var _fromTo: String?
    private var _status: String?
    private var _type: String?
    private var _preFormattedDate: String?
    
    var time: String {
        return self._time!
    }
    
    var txnId: String {
        return self._txnId!
    }
    
    var amount: Double {
        return self._amount!
    }
    
    var isRecieved: Bool {
        return self._isRecieved!
    }
    
    var fromTo: String {
        return self._fromTo!
    }
    
    var status: String {
        return self._status!
    }
    
    var type: String {
        return self._type!
    }
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self._preFormattedDate <- map["TIME"]
        self._txnId <- map["TXNID"]
        self._amount <- map["AMOUNT"]
        self._isRecieved <- map["ISRECIEVED"]
        self._fromTo <- map["FROMTO"]
        self._status <- map["STATUS"]
        self._type <- map["TYPE"]
        self._time = getDateFormated(foramte: "hh:mm a - EEEE, MMM dd, yyyy")
    }
    
    
    private func getDateFormated(foramte:String)->String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        let date = dateFormatter.date(from: self._preFormattedDate!)
        
        dateFormatter.dateFormat = foramte
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date!)
    }
}
