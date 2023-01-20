//
//  RegApiManager.swift
//  Paymob Wallet
//
//  Created by mahmoud on 1/9/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//


import Foundation
import RxSwift

class RegApiManager: ApiManager{
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .none
    }
    
    public func aesKeys(privateKey: Data, publicKey: Data) -> Observable<RSAResponse>{
        
        self.currentEncryptionState = .RSA
        
        self.privateKey = privateKey
        
        Util.debugMsg(self.privateKey?.base64EncodedString())
        
        let params=[
            "TYPE":"GETSSIONKEY",
            "P_KEY":SwKeyConvert.PublicKey.derToPKCS1PEM(publicKey)
        ]
        
        return   self.connect(with: params)
    }
    
    
    public func register(params: [String: String]) -> Observable<Response>{        
        self.currentEncryptionState = .AES
        return   self.connect(with: params)
    }
    
}
