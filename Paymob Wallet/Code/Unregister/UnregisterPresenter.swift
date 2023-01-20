//
//  UnregisterPresenter.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class UnregisterPresenter: Presenter {
    var router: UnregisterRouter?
    var controller: UnregisterViewController?
    var localManager: AuthLocalManager?
    var apiManager: UnregisterApiManager?
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        localManager = AuthLocalManager()
        apiManager = UnregisterApiManager()
    }
    
    func sendVerificationTapped(pin: String, mobile: String){
        router?.displayAlert(msg: "loading".localized)
        guard localManager!.userExist else {
            return
        }
        self.apiManager?.checkUnregister(pin: pin, mobile: mobile).subscribe(onNext:
            { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        //If Fail
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    //If Successfull
                    self.controller?.showUnregisterStackView()
                    
                }
        }, onError:
            { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
        }).disposed(by: disposeBag)
        
    }
    
    func UnregisterTapped(otp: String, mobile: String){
        router?.displayAlert(msg: "loading".localized)
        guard localManager!.userExist else {
            return
        }
        self.apiManager?.unregister(otp: otp, mobile: mobile).subscribe(onNext:
            { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        //If Fail
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    //If Successfull
                    self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        //close app and delete saved data
                        self.deleteAllData()
                        self.router?.closeApp()
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
    
    func deleteAllData(){
        self.localManager?.deleteAll()
    }
}
