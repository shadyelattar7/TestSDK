//
//  MerchantsLocalManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RealmSwift

class MerchantsLocalManager {
    private var realm: Realm?
    
    init() {
        self.realm = try? Realm()
    }
    
    func save(merchant: Merchant) {
        try? realm?.write {
            realm?.add(merchant)
        }
    }
    
    func delete(merchant: Merchant) {
        try? realm?.write {
            realm?.delete(merchant)
        }
    }
    
    func update(merchant: Merchant, name: String, code: String) {
        try? realm?.write {
            merchant._merchantName = name
            merchant._merchantCode = code
        }
    }
    
    func getMerchants() -> [Merchant] {
        if let merchants = self.realm?.objects(Merchant.self) {
            Util.debugMsg(merchants.toArray())
            return merchants.toArray()
        }
        return []
    }
    
    
}

extension Results {
    
    func toArray() -> [Element] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [Element] {
        return self.map{$0}
    }
}
