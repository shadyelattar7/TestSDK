//
//  transaction.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/22/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation

// holds one transaction data
class Transaction {
    var type:String?
    var toWhom:String?
    var name:String? = ""
    var msg:String? = ""
    var amount:String?
    var image:String = "man"
    var title:String = ""
    var isMultiUseVCN: Bool = false
    var staticBillFees: String?
    
    //Bill Installement
    var institution: Institution?
    var nationalID: String?
    
    //Scan QR Extra Parameter
    var extraParameterName: String?
    var extraParameterValue: String?

}
