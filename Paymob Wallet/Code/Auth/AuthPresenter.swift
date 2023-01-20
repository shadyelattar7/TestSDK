//
//  AuthPresenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift
//import Firebase
//import FirebaseInstanceID

class AuthPresenter:Presenter {
    var router:AuthRouter?
    var apiManger:AuthApiManager?
    var localManager:AuthLocalManager?
    var disposeBag = DisposeBag()
    var canAuthenticateNumber = true
    
    override init(){
        super.init()
        self.localManager = AuthLocalManager()
        self.apiManger = AuthApiManager()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.regApp), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
    }
    
    func go(){
        if localManager!.userExist {
            Util.debugMsg(localManager?.user)
            if userManager.user?._watingForActCode == true {
                self.router?.goToValidationText()
                //return
            }
            
            guard localManager!.user!._login else {
                self.router?.goToMobileVerfication()
                return
            }
            
                        if true{
                            bypassLogin()
                            return
                        }
            
            self.router?.openLogin()
            
        }
        self.router?.goToMobileVerfication()
        
    }
    
    
    func bypassLogin(){
        self.localManager?.save(saveCall: { (user) in
            user._balance = "5000.25"
            user._name = "Ghonem"
        })
        self.router?.goToDashboard()
    }
    
    
    func submitMobileNumber(mobile:String){
        self.router?.displayAlert(msg: "loading".localized)
        let mobileClean = mobile.getOnly(charSet: CharacterSet.decimalDigits)
        self.apiManger!.validate(mobile: mobileClean).subscribe(onNext:
                                                                    { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.canAuthenticateNumber = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                        self.canAuthenticateNumber = true
                    }
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                if self.localManager!.userExist {
                    if self.userManager.user?._mobile != mobileClean{
                        LocalVirtualCardManager().deleteAllCards()
                    }
                }
                self.localManager?.save(saveCall: { (user) in
                    user._mobile = mobileClean
                    user._watingForActCode = true
                })
                Util.debugMsg(self.localManager?.user)
                self.router!.goToValidationText()
            }
        },onError:
                                                                    { (error) in
            self.canAuthenticateNumber = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                self.canAuthenticateNumber = true
            }
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func activationCode(code:String){
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.activate(code:code, mobile: self.localManager!.user!._mobile!)
            .subscribe(onNext:
                        { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    
                    guard response.isActivated else {
                        self.router?.sweetAlertFail(message: "Wrong code", afterMsg: {
                            
                        })
                        return
                    }
                    
                    //self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    self.localManager!.save(saveCall: { (user) in
                        user._login = true
                        user._AppId = response.appId
                        user._watingForActCode = false
                    })
                    self.regApp()
                    // go to login page
                    
                    guard response.isPinSet else {
                        
                        //// go to set pin view controller
                        self.router?.goToSetPinView()
                        
                        return
                    }
                    
                    self.router?.openLogin()
                    //debug
                    Util.debugMsg(response.txn)
                    // })
                    
                    
                }
                
            }, onError:
                        { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            })
            .disposed(by: disposeBag)
        
    }
    @objc func regApp(){
        
        guard self.localManager!.userExist else {
            return
        }
        //        Messaging.messaging().token { token, error in
        //            if let error = error {
        //                print("FCM registration token: Error fetching FCM registration token: \(error)")
        
        self.regRequest(token: "replacement_for_Unprovided_Token\(self.localManager!.user!._mobile!)")
        //            } else if let token = token {
        //                print("FCM registration token: \(token)")
        //
        //                self.regRequest(token: token)
        //            }
        //        }
        
        
    }
    
    func regRequest(token: String){
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(2048)
        
        self.apiManger!.privateKey = privateKey
        Util.debugMsg(token)
        self.apiManger?.appReg(token: token, mobile: self.localManager!.user!._mobile!, publicKey: publicKey)
            .subscribe(onNext: { (response) in
                
                guard response.txnStatus == "200" else {
                    return
                }
                
                self.localManager?.save(saveCall: { (user) in
                    user._aesKey = response.symKey?.data(using: .utf8)
                    user._iv = response.iv?.data(using: .utf8)
                    user._session = response.sessionID
                })
                ApiManager.aes = (response.iv?.data(using: .utf8),response.symKey?.data(using: .utf8),response.sessionID!)
                //debug
                Util.debugMsg(response.iv)
                Util.debugMsg(response.sessionID)
                Util.debugMsg(response.symKey)
                
            })
            .disposed(by: disposeBag)
    }
    
    func login(pin:String){
        guard pin.count > 0 else {
            router?.sweetAlertFail(message: "pin6Digits".localized, afterMsg: {
                
            })
            return
        }
        self.router?.displayAlert(msg: "loading".localized)
        Util.debugMsg(self.localManager?.user)
        guard self.localManager!.userExist else {
            self.router?.goToMobileVerfication()
            return
        }
        self.apiManger?.login(pin:pin, mobile: self.localManager!.user!._mobile!).subscribe(onNext:
                                                                                                { (response) in
            self.router?.hideMsg {
                
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                
                self.setProfileName(profileName: response.userName ?? "")
                
                self.localManager?.save(saveCall: { (user) in
                    user._balance = response.balance
                    
                    
                    //user._balance = "5554.0"
                })
                EntryPoint.inApp = true
                // go to dashboard page
                self.router?.goToDashboard()
                
            }
            
        }, onError:
                                                                                                { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        })
        .disposed(by: disposeBag)
        
    }
    func setPin(newPin: String, confirmPin: String){
        
        self.router?.displayAlert(msg: "loading".localized)
        Util.debugMsg(self.localManager?.user)
        guard self.localManager!.userExist else {
            self.router?.goToMobileVerfication()
            return
        }
        self.apiManger?.setPin(newPin: newPin, confirmPin: confirmPin,mobile: self.localManager!.user!._mobile!).subscribe(onNext:
                                                                                                                            { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    self.go()
                })
                
            }
            
        }, onError:
                                                                                                                            { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        })
        .disposed(by: disposeBag)
    }
    
    
    func showTermsTapped() {
        router?.showAlert(message: "termsAndConditionsBody".localized, title: "termsAndConditionsTitle".localized)
    }
    
    func showTermsForFirstTime() {
        if (localManager?.userExist)! {
            if let userFirstTime = userManager.user?._login {
                if userFirstTime == false {
                    if let actCode = userManager.user?._watingForActCode {
                        if actCode == false {
                            router?.showAlertWithAcceptAndReject(message: "termsAndConditionsBody".localized, title: "termsAndConditionsTitle".localized)
                        } else {
                            
                        }
                    }
                    
                }
            }
        } else {
            router?.showAlertWithAcceptAndReject(message: "termsAndConditionsBody".localized, title: "termsAndConditionsTitle".localized)
            
        }
    }
    
    func showThrottleMessage() {
        router?.showAlert(message: "throttleMessage".localized, title: "")
    }
    
    func setExpiredPin(oldPin: String, newPin: String, confirmPin: String) {
        router?.displayAlert(msg: "loading".localized)
        guard localManager!.userExist else {
            router?.goToMobileVerfication()
            return
        }
        apiManger?.setExpiredPin(oldPin:oldPin, newPin: newPin, confirmPin: confirmPin,mobile: self.localManager!.user!._mobile!).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    self.go()
                })
            }
        }, onError:
                                                                                                                                                { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func goToHowToReg(){
        self.router?.openHowToRegPage()
    }
    
    //MARK: - Firebase subscription configuration
    
    func setProfileName(profileName: String){
        let oldProfileType = localManager?.user?._name
        if ((profileName.isEmpty) || profileName == oldProfileType ){
            return;
        }
        self.localManager?.save(saveCall: { (user) in
            user._name = profileName
        })
        
        //        Messaging.messaging().subscribe(toTopic: profileName);
        //        if ( !(oldProfileType?.isEmpty ?? true) ){
        //            Messaging.messaging().unsubscribe(fromTopic: oldProfileType!);
        //        }
    }
    
}
