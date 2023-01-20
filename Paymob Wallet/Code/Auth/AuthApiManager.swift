//
//  AuthApiManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class AuthApiManager: ApiManager{
    
    
    override init() {
        super.init()
        
        self.currentEncryptionState = .none
        
    }
    
    
    public func validate(mobile:String) -> Observable<Response>{
        self.currentEncryptionState = .none
        let params=[
            "TYPE":"GETACTREQ",
            "MSISDN": mobile,
        ]
        
        return self.connect(with: params)
        
    }
    
    public func activate(code:String,mobile:String) -> Observable<Response>{
        self.currentEncryptionState = .none
        let params=[
            "TYPE":"CHKACTREQ",
            "MSISDN": mobile,
            "ACTIVATION_CODE":code
        ]
        return   self.connect(with: params)
        
    }
    
    public func login(pin:String,mobile:String) -> Observable<Response>{
        self.currentEncryptionState = .AES
        let params=[
            "TYPE":"CBEREQ",
            "MSISDN": mobile,
            "PIN":pin,
            "BLOCKSMS":"N"
        ]
        return   self.connect(with: params)
        
    }
    
    public func appReg(token:String, mobile:String, publicKey:Data) -> Observable<RSAResponse>{
        self.currentEncryptionState = .RSA
        
        let params=[
            "TYPE":"REGGCMTREQ",
            "MSISDN": mobile,
            "OS":"iOS",
            "TOKEN":token,
            "ENCRYPTION_VERSION":2,
            "P_KEY":SwKeyConvert.PublicKey.derToPKCS1PEM(publicKey),
        ] as [String : Any]
        return   self.connect(with: params)
        
    }
    
    public func setPin(newPin: String,confirmPin: String, mobile: String) -> Observable<Response>{
        self.currentEncryptionState = .none
        let params=[
            "TYPE":"PINSETREQ",
            "MSISDN": mobile,
            "NEWPIN":newPin,
            "CONFIRMPIN":confirmPin,
            "BLOCKSMS":"N"
            
        ]
        return   self.connect(with: params)
        
    }
    
    func profileDetails(mobile: String)-> Observable<Response>{
        let params=[
            "TYPE":"GETUSERDATAREQ",
            "MSISDN":mobile
        ]
        
        return self.connect(with: params)
    }
    
    public func resetMPin(pin: String, newPin: String, confPin: String, mobile: String) -> Observable<Response>{
        let params=[
            "TYPE":"CCPNREQ",
            "MSISDN": mobile,
            "PIN":pin,
            "NEWPIN":newPin,
            "CONFIRMPIN":confPin,
            "BLOCKSMS":"N"
        ]
        return   self.connect(with: params)
    }
    
    public func setExpiredPin(oldPin:String ,newPin: String, confirmPin: String, mobile: String) -> Observable<Response> {
        currentEncryptionState = .none
        let params = [
            "TYPE": "CCPNREQ",
            "MSISDN": mobile,
            "PIN": oldPin,
            "NEWPIN": newPin,
            "CONFIRMPIN": confirmPin,
        ]
        return connect(with: params)
    }
}
