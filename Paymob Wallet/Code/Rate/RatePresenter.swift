//
//  RatePresenter.swift
//  Paymob Wallet
//
//  Created by mac on 13/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//


import Foundation
import RxSwift

@available(iOS 13.0, *)
class RatePresenter: Presenter {
    var router: RateRouter?
    var viewController:rateVC?
    private var rateApi = RateApiManager()
    
    var disposeBag = DisposeBag()
    var localManager: AuthLocalManager?
    private var user: User {
        let authManager = AuthLocalManager()
        _ = authManager.userExist
        return authManager.user!
    }
    override init() {
        super.init()
        rateApi = RateApiManager()
        self.localManager = AuthLocalManager()
        if (self.localManager?.userExist)! {
        }
    }
    
    func rate(rateVal:Int, TXNID : String){
        
        self.router?.displayAlert(msg: "loading".localized)
        rateApi.rate(mobile: self.user._mobile!, TXNID: TXNID, RATING: "\(rateVal)")
            .subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    
                    self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.close()
                    })
                }
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.disposeBag)
    }
    
    func rateBeforeFeedback(rateVal:Int, TXNID : String){
            
        self.router?.displayAlert(msg: "loading".localized)
            rateApi.rate(mobile: self.user._mobile!, TXNID: TXNID, RATING: "\(rateVal)")
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        
//                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
    //                        NavigationPresenter.currentModule = "Dashboard"
    //                        self.router?.close()
                            self.viewController!.rateView.isHidden = true
                            self.viewController!.feedbackView.isHidden = false
                            
//                        })
                    }
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.disposeBag)
        }

    func feedback(message:String){
        self.router?.displayAlert(msg: "loading".localized)
        rateApi.Feedback(mobile: self.user._mobile!, MESSAGE: message)
            .subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    
                    self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.close()
                    })
                }
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.disposeBag)
    }
    
    func closeAction(){
        router?.close()
    }
}
