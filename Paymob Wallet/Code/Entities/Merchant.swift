//
//  Merchant.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RealmSwift

class Merchant: Object {
    @objc dynamic var _merchantName: String?
    @objc dynamic var _merchantCode: String?
}
