//
//  localVirtualCardManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RealmSwift

class LocalVirtualCardManager {
    
    private var realm:Realm?

    var cards:[VirtualCard]{
        let result = self.realm!.objects(VirtualCard.self)
        
        if result.count > 0 {
            return result.toArray()
        } else {
            return []
        }
    }
    
    
    init() {
        self.realm = try! Realm()
    }
    
    func save(vCard:VirtualCard){
        try! realm!.write {
            realm!.add(vCard)
        }
    }
    
    func delete(vCard:VirtualCard){
        let cNumber = vCard.number!
        let num = cNumber.replacingOccurrences(of: " ", with: "")
        Util.debugMsg(num)
        let card = realm?.objects(VirtualCard.self).filter("number = %@", num)
        Util.debugMsg(card)
        try! realm!.write {
            
            self.realm?.delete(card!)
        }
    }
    
    func deleteCards(){
        try! realm!.write {
            self.realm?.delete(self.cards.filter({!$0.isMultiUse}))
        }
        
    }
    
    func deleteAllCards(){
        try! realm!.write {
            self.realm?.delete(self.cards)
        }
        
    }
    
    
    
}
