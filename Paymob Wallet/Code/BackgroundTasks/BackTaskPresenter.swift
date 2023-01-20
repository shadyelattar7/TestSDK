//
//  BackTaskPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/13/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

public var APP_VERSION = 2.0

class BackTaskPresenter: Presenter {
    var router: BackTaskRouter?
    var apiManager: BackTaskApiManager?
    var localManager: AuthLocalManager?
    var mobile: String?
    var disposeBag = DisposeBag()

    override init() {
        super.init()
        apiManager = BackTaskApiManager()
        self.localManager = AuthLocalManager()
        if (self.localManager?.userExist)! {
            mobile = localManager?.user?._mobile
        }
    }
    
    func login(pin:String){
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManager?.login(pin:pin, mobile: mobile!).subscribe(onNext:
            { (response) in
                
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                   // self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        self.router?.goBack()

                    //})
                    
                }
                
        }, onError:
            { (error) in
                // some error handleing
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
        }).disposed(by: disposeBag)
    }
    
    func getMinVersion(){
        self.apiManager?.getMinVersion(mobile: mobile!).subscribe(onNext:
            { (response) in
                Util.debugMsg(response.minVersion)
                
                if response.minVersion > self.settings.get(key: "appVersion") as! Double {
                    self.router?.goToUpdateAPP()
                }
                
                
        }, onError:
            { (error) in
                // some error handleing
        }).disposed(by: disposeBag)
    }
    
    func goToAppStore() {
        Util.debugMsg("going")
        let storeId = self.settings.get(key: "storeId") as! String
        if let url = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id\(storeId)?mt=8"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (_) in
                    
                }
            } else {
                //self.router?.displayAlert(msg: "You are using an older version of the Wallet please go to the app store and download the latest version.", title: "Update")
                self.router?.showAlert(message: "You are using an older version of the Wallet please go to the app store and download the latest version.", title: "Update")
            }
        }
        
        
    }
    
    
}
