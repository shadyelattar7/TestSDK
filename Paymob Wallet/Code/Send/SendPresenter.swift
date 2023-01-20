//
//  SendPresenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class SendPresenter: Presenter {
    var router:SendRouter?
    
    //init for the first time we use the app
    private var currentPage = 1
    var currentPageObserver = BehaviorSubject<Int>(value: 1)
    let authManager = AuthLocalManager()
    var mobile:String?
    var contactName:String?
    var mobileObserver = BehaviorSubject<String>(value: "")
    
    var amount:String?
    var amountObserver = BehaviorSubject<String>(value: "")
    
    private var msg:String?
    var msgObserver = BehaviorSubject<String>(value:"")
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)

    private var trans:Transaction?
    private var disposeBag = DisposeBag()
    
    var localManager:AuthLocalManager?
    private var apiManager:SendApiManager?
    var contactsArray = BehaviorSubject<[Contact]>(value: [])
    var currentContact = BehaviorSubject<Contact>(value: Contact())
    
    override init(){
        super.init()
        self.apiManager = SendApiManager()
        self.localManager = AuthLocalManager()
        self.localManager?.userExist
        self.mobileObserver.subscribe(onNext: { (mobile) in
            self.mobile = mobile
        }).disposed(by: disposeBag)
        
        self.currentContact.subscribe (onNext: {(mobile) in
            self.mobile = mobile._mobile
        }).disposed(by: disposeBag)
        
        self.amountObserver.subscribe(onNext: { (amount) in
            self.amount = amount
        }).disposed(by: disposeBag)
        self.msgObserver.subscribe(onNext: { (msg) in
            self.msg = msg
        }).disposed(by: disposeBag)
    }
    func set(mobile:String){
        self.mobile = mobile
        self.mobileObserver.onNext(mobile)
    }
    
    func set(amount:String){
        self.amount = amount
        self.amountObserver.onNext(amount)
    }
    func set(contact:String){
    
    }
    
    func onNext() {
        self.currentPage += 1
        self.currentPageObserver.onNext(self.currentPage)
    }
    
    func onPrev(){
        self.currentPage -= 1
        self.currentPageObserver.onNext(self.currentPage)
    }
    
    func embeddContactsVC(into vc: UIViewController, container: UIView) {
        router?.embeddContactsView(into: vc, container: container)
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
    
    
    func sendMoneyClicked(msg: String?){
        self.trans = Transaction()
        self.trans?.amount = self.amount
        self.trans?.type = "P2P" //TODO:: hide in a constant
        self.trans?.toWhom = self.mobile
        self.trans?.name = self.contactName
        self.trans?.msg = msg
        self.trans?.title = "send".localized
        
        self.confirm(transaction: trans!).subscribe(onNext: { (pin) in
            let mobileClean = self.mobile?.getOnly(charSet: CharacterSet.decimalDigits)
            Util.debugMsg(mobileClean)
            self.router?.displayAlert(msg: "loading".localized)
            self.apiManager?.send(pin: pin, mobile: self.localManager!.user!._mobile!, toMobile: mobileClean!, amount: self.amount!, msg: msg)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
//                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
//                            })
                            if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                                presentingController.transactionFinished(response: response)
                            }
                            return
                        }
                        
                        if self.userManager.userExist {
                            self.userManager.save(saveCall: { (user) in
                                user._balance = response.balance
                            })
                        }
                        
                        if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                            presentingController.transactionFinished(response: response)
                        }
                        

//                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
                            self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
//                        })
                        
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

    @objc func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    @objc func notificationClicked() {
        NavigationPresenter.currentModule = "Notifications"
        goToNotifications()
    }
    
    @objc func goBack() {
        self.router?.sendController?.navigationController?.popViewController(animated: true)
    }
    
    @objc func logoCliked() {
        NavigationPresenter.currentModule = "Dashboard"
        goToDashboard()
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(SendPresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
//            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
            
            numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
            }).disposed(by: disposeBag)
            
            numOfUnreadNoti.onNext( Int(localManager?.user?._noOfUnreadNoti ?? "0") ?? 0 )
        }
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
         */
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if ("\(vc.classForCoder)" == "SendAmountController"){
            backBtn.addTarget(self, action: #selector(SendPresenter.goBack), for: .touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(SendPresenter.logoCliked), for: .touchUpInside)
        }
        backBtn.setImage(ImageProvider.image(named:"back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.imageView?.flipImage()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    
    func getNumOfUnreadNotification() {
        self.apiManager?.getNumOfUnreadNotification(mobile: (self.mobile ?? localManager?.user?._mobile)!).subscribe(onNext: { (response) in
            //self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            //self.router?.hideMsg {
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.localManager?.save(saveCall: { (user) in
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
    
    func goToAmountVC(){
        self.router?.goToSendAmountViewController()
    }
}

