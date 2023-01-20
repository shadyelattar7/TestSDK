//
//  VCNType.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/5/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class VCNType: Mappable {
    
    var name: String?
    var desc: String?
    var color: String?
    var type: String?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.name <- map["NAME"]
        self.desc <- map["DESCRIPTION"]
        self.color <- map["COLOR"]
        self.type <- map["TYPE"]
    }
    
}
