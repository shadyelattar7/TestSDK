//
//  User.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object {
    @objc dynamic var _mobile:String?
    @objc dynamic var _noOfUnreadNoti:String?
    @objc dynamic var _name:String = "My Name"
    @objc dynamic var _image:Data?
    @objc dynamic var _aesKey:Data?
    @objc dynamic var _iv:Data?
    @objc dynamic var _session:String?
    @objc dynamic var _balance:String?
    @objc dynamic var _login:Bool = false
    @objc dynamic var _AppId:String?
    @objc dynamic var _watingForActCode: Bool = false
    @objc dynamic var _rating :Bool = true
}
