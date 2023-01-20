//
//  ServiceInfoEntity.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class ServiceInfoEntity: Mappable {
    private var _name: String?
    private var _url: String?
    private var _content_text: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self._name <- map["name"]
        self._url <- map["url"]
        self._content_text <- map["content_text"]
    }
    
    var name: String {
        return _name!
    }
    
    var url: String {
        return _url!
    }
    
    var content_text: String {
        return _content_text!
    }
}
