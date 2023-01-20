//
//  FeatMerchant.swift
//  Paymob Wallet
//
//  Created by mahmoud on 11/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class FeatMerchant: Mappable {
    private var _merName: String?
    private var _merCode: String?
    private var _imageUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self._merName <- map["merchant_name"]
        self._merCode <- map["mpg_macro_merchant_id"]
        self._imageUrl <- map["merchant_image"]
    }
    
    var merName: String {
        return _merName!
    }
    
    var merCode: String {
        return _merCode!
    }
    
    var imageUrl: String {
        return _imageUrl!
    }
}
