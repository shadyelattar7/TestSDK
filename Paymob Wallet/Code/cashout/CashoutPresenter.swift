////
////  CashoutPresenter.swift
////  WalletsPaymob
////
////  Created by mahmoud gamal on 9/11/17.
////  Copyright © 2017 mahmoud gamal. All rights reserved.
////

import Foundation
import RxSwift

class CashoutPresenter: Presenter {
    
    var router: CashoutRouter?
    var apiManger:CashoutApiManager?
    var disposeBag = DisposeBag()
    let authManager = AuthLocalManager()
    var trans:Transaction = Transaction()
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    var OTP: String?
    
    var type: String = "cashout".localized

    override init(){
        super.init()
        self.apiManger = CashoutApiManager()
    }
    
    func cashOutClicked(amount: String){
        self.trans = Transaction()
        self.trans.amount = amount
        self.trans.type = "OTT" //TODO:: hide in a constant
        self.trans.toWhom = ""
        self.trans.title = self.type
        
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
                                
//                                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
//                                    NavigationPresenter.currentModule = "Dashboard"
//                                    self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
//                                })
                                self.router?.closeModal()
                                self.OTP = response.OTP
                                self.router?.goToCashoutOtpViewController()
                                
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
    
    @objc func logoCliked() {
        NavigationPresenter.currentModule = "Dashboard"
        goToDashboard()
    }
    
    @objc func goToPreviousVC(){
//        self.router?.cashoutNav?.popViewController(animated: true)
        let viewControllers: [UIViewController] = self.router?.cashoutNav?.viewControllers as [UIViewController]
        self.router?.cashoutNav?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(ProfilePresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
            //            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
                        
                        numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                            notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
                        }).disposed(by: disposeBag)
                        
            numOfUnreadNoti.onNext( Int(userManager.user?._noOfUnreadNoti ?? "0") ?? 0 )
                }
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
         */
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        print("BLA: \(vc.classForCoder)")
//        if ("\(vc.classForCoder)" == "CashoutTimeOutViewController"){
//            backBtn.addTarget(self, action: #selector(ProfilePresenter.goToPreviousVC), for: .touchUpInside)
//        }else{
//            backBtn.addTarget(self, action: #selector(ProfilePresenter.logoCliked), for: .touchUpInside)
//        }
        backBtn.addTarget(self, action: #selector(ProfilePresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.flipImage()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    
    func goToOtpVC(){
        self.router?.goToCashoutOtpViewController()
    }
    
    func goToTimeOutVC(){
        self.router?.goToCashoutTimeOutViewController()
    }
}
