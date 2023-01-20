//
//  LoadPresenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class LoadPresenter: Presenter {
    var router: LoadRouter?
    var apiManger:LoadAPiManager?
    var disposeBag = DisposeBag()
    let authManager = AuthLocalManager()
    var currentCard:CreditCard?
    var creditCards:[CreditCard] = []
    var trans:Transaction = Transaction()
    
    var creditCardsObservable = BehaviorSubject<[CreditCard]>(value:[])
    var loadViewObservable = BehaviorSubject<Bool>(value: true)
    var activityObservable = BehaviorSubject<Bool>(value: false)
    var cardNameObservable = BehaviorSubject<String>(value: "card")
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)

    
    override init() {
        super.init()
        self.apiManger = LoadAPiManager()
        
        
        
    }
    
    func getCreditCards() {
        guard self.userManager.userExist else {
            return
        }
        //router?.displayAlert(msg: "Loading...")
        self.apiManger?.getCreditCards(mobile: self.userManager.user!._mobile!)
            .subscribe(onNext: { (response) in
                //self.router?.hideMsg {
                guard response.txn == "200" else {
                    //self.router?.sweetAlertFail(message: response.message!, afterMsg: {
                        self.activityObservable.onNext(true)
                    //})
                    return
                }
                
                self.activityObservable.onNext(true)
                self.creditCards = response.cards
                self.creditCardsObservable.onNext(self.creditCards)
                
                //debug
                Util.debugMsg(self.creditCards)
                //}
                
            }, onError: { (error) in
                //self.router?.displayAlert(msg: (error as! Response).msg, title: "Error", hideAfter: MsgDuration.Short.rawValue)
                self.activityObservable.onNext(true)
                
            })
            .disposed(by: disposeBag)
    }
    
    
    func cardClicked(at:IndexPath){
        self.currentCard = self.creditCards[at.row]
        self.cardNameObservable.onNext(self.currentCard!.bankAlias1!)
        self.loadViewObservable.onNext(false)
    }
    
    
    func showFeedBack(service:Bool,TXNID:String){
        let rate =  authManager.user?._rating ?? true
        if(rate == true && service == true){
            if #available(iOS 13.0, *) {
                self.router?.showSetRateView(TXNID: TXNID)
            } else {
                // Fallback on earlier versions
            }
        }
        else{
            self.router?.closeModal()
            self.router?.goToDashboard()
        }
    }
    
    
    func loadAmount(amount:String){
        self.trans.amount = amount
        self.trans.title = "avl".localized
        self.trans.toWhom = ""
        self.trans.type = "CASHIN"
        self.confirm(transaction: trans).subscribe(onNext: { (pin) in
            self.router?.displayAlert(msg: "loading".localized)
            self.apiManger?.load(pin: pin, alias: self.currentCard!.bankAlias1!, amount: amount, mobile: self.userManager.user!._mobile!)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        
                        if self.userManager.userExist {
                            self.userManager.save(saveCall: { (user) in
                                user._balance = response.balance
                            })
                        }
                        
                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
                            self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
                        })
                        
                    }
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
    }
    
    func cashOutClicked(amount: String){
        self.trans = Transaction()
        self.trans.amount = amount
        self.trans.type = "OTT" //TODO:: hide in a constant
        self.trans.toWhom = ""
        self.trans.title = "cashout".localized
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                self.confirm(transaction: trans).subscribe(onNext: { (pin) in
                    self.router?.displayAlert(msg: "loading".localized)
                    self.apiManger?.cashout(pin: pin, amount: amount, mobile: mobile)
                        .subscribe(onNext: { (response) in
                            self.router?.hideMsg {
                                
                                
                                
                                guard response.txn == "200" else {
                                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                                    })
                                    return
                                }
                                
                                
                                
                                if self.userManager.userExist {
                                    self.userManager.save(saveCall: { (user) in
                                        user._balance = response.balance
                                    })
                                }
                                
                                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                                    NavigationPresenter.currentModule = "Dashboard"
                                    self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
                                })
                                
                            }
                        }, onError: { (error) in
                            self.router?.hideMsg {
                                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                                })
                            }
                        }).disposed(by: self.disposeBag)
                })
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
    
    
    func loadTapped() {
        router?.goToLoadController()
    }
    
    func cashoutTapped() {
        router?.goToCashoutController()
    }
    
    func mapInfoTapped() {
//        router?.sweetAlertWarning(message: NSLocalizedString("mapInfo", comment: "map info"), afterMsg: {
//
//        })
        router?.goToMapInfoController()
    }
    
    func closeLoadViewClicked(){
        self.loadViewObservable.onNext(true)
    }
    
    @objc func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    @objc func notificationClicked() {
        NavigationPresenter.currentModule = "Notifications"
        goToNotifications()
    }
    
    @objc func logoCliked() {
        NavigationPresenter.currentModule = "Dashboard"
        goToDashboard()
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuBtn.addTarget(self, action: #selector(LoadPresenter.menuClicked), for: .touchUpInside)
        menuBtn.setImage(#imageLiteral(resourceName: "Menu-23"), for: .normal)
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(LoadPresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
//            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
            
            numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
            }).disposed(by: disposeBag)
            
            numOfUnreadNoti.onNext( Int(userManager.user?._noOfUnreadNoti ?? "0") ?? 0 )
        }
        
        vc.navigationItem.leftBarButtonItems = [menuBarBtn, notificationBarBtn]
        */
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(LoadPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.rightBarButtonItems = [backBarBtn]
    }
    func getNumOfUnreadNotification() {
        self.apiManger?.getNumOfUnreadNotification(mobile: (userManager.user?._mobile)!).subscribe(onNext: { (response) in
            //self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            //self.router?.hideMsg {
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.authManager.save(saveCall: { (user) in
                user._noOfUnreadNoti = "\(response.numberOfUnreadNoti)"
            })
            self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            UIApplication.shared.applicationIconBadgeNumber = response.numberOfUnreadNoti
            //}
            
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
}
