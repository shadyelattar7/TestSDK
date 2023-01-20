//
//  Contact.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var _mobile: String?
    @objc dynamic var _name: String?
    @objc dynamic var _image: Data?
}
