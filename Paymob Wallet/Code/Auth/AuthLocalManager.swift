//
//  AuthLocalManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RealmSwift

class AuthLocalManager {

    private var realm:Realm?
   
    var user:User?
    
    var userExist:Bool {
        get{
//            self.realm = try! Realm()
//            self.user = nil
//            if let user = self.realm?.objects(User.self).first {
//                self.user = user
//            }
//
//            guard user != nil else {
//                return false
//            }
//            return true
            
            self.realm = try! Realm()
            guard let user = self.realm?.objects(User.self).first else{
                self.user = nil
                return false
            }
            
            self.user = user
            return true
        }
    }

   
    func save(saveCall:(_ user:User) -> Void ){
        guard userExist else {
            
            self.user = User()
            
            try! realm!.write {
                realm!.add(self.user!)
                saveCall(self.user!)
            }
            return
        }
        
        try! realm!.write {
            saveCall(self.user!)
        }
    }

    func deleteAll(){
        if (realm != nil){
            try! realm!.write {
                realm!.deleteAll()
            }
        }else{
            self.realm = try! Realm()
            try! realm!.write {
                realm!.deleteAll()
            }
            
        }
    }


}
