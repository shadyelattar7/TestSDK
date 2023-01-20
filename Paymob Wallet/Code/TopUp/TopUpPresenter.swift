//
//  TopUpPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 8/16/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class TopUpPresenter: Presenter {
    
    var router: TopUpRouter?
    var controller: TopUpController?
    var disposeBag = DisposeBag()
    var currentType: String?
    var localManager:AuthLocalManager?
    var apiManager: PayApiManager?
    var amount: String?
    var fees: String?
    var nationalId: String?
    var ref: String?
    var clientName: String?
    var merchantCode: String?
    var institution: Institution?
    
    let tasaheelnumber = "172735420"
    let mashroeynumber = "172642670"
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)

    
    override init(){
        super.init()
        localManager = AuthLocalManager()
        apiManager = PayApiManager()
        amount = nil
        fees = nil
        nationalId = nil
        ref = nil
        institution = nil
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
    
    func tsahelOrMashroeyTapped(institute: Institution) {
        currentType = institute.institution_code
        merchantCode = institute.merchant_id
        self.institution = institute
        router?.goToInquiryController()
    }
    
    func staticBillInquiry(billRef: String, completed: @escaping (Bool, Response?)-> ()){
        self.router?.displayAlert(msg: "loading".localized)
        Util.debugMsg(self.localManager?.user)
        guard self.localManager!.userExist else {
            return
        }
        
        self.apiManager?.staticBillIquiry(mobile: (localManager?.user?._mobile)!, type: self.currentType!, billRef: billRef).subscribe(onNext: { (response) in
//        self.apiManager?.staticBillIquiry(mobile: (localManager?.user?._mobile)!, type: (currentType ?? TopupType(rawValue: "")!).rawValue, billRef: billRef).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    print("not 200 respone , \(response.toJSON())")
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        completed(false, nil)
                    })
                    return
                }
                self.amount = response.amount
                self.fees = response.topUpFees
                self.ref = response.topUpRef
                self.clientName = response.clientName
                
                completed(true, response)
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
//    func staticBillFeesInquiry(amount: String, billRef: String, completed: @escaping (Bool)-> ()){
//        self.router?.displayAlert(msg: NSLocalizedString("loading", comment: "loading"))
//        Util.debugMsg(self.localManager?.user)
//        guard self.localManager!.userExist else {
//            return
//        }
//
//        self.apiManager?.staticBillFeesIquiry(amount: amount, mobile: (localManager?.user?._mobile)!, type: currentType ?? TopupType(rawValue: "")!, billRef: billRef).subscribe(onNext: { (response) in
//            self.router?.hideMsg {
//                guard response.txn == "200" else {
//                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
//                        completed(false)
//                    })
//                    return
//                }
//                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
//                    self.fees = response.topUpFees
//                    let amountFees = (Double(amount) ?? 0.0) + (Double(self.fees ?? "0.0") ?? 0.0)
//                    self.payBill(amount: String(amountFees), merCode: "700010")
//                    completed(true)
//                })
//            }
//        }, onError: { (error) in
//            self.router?.hideMsg {
//                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
//                })
//            }
//        }).disposed(by: disposeBag)
//    }
    
    func payBill(amount: String, merCode: String, billFees: String){
        let trans = Transaction()
        trans.toWhom = merCode
        trans.amount = amount
        trans.institution = self.institution
        trans.nationalID = self.nationalId
        trans.title = "pay installment".localized
        trans.type = "BILLPAYMENT"
        trans.staticBillFees = billFees
        
        self.confirm(transaction: trans).subscribe(onNext: { (pin) in
            
            self.router?.displayAlert(msg: "loading".localized)
            guard let currentType = self.currentType else { return }

            self.apiManager?
                .staticBillIPay(
                    mobile: self.userManager.user!._mobile!,
                    billRef: self.ref ?? "" ,
                    pin: pin,
                    amount: self.amount!,
//                    merchantCode: currentType == .tasahel ? self.tasaheelnumber : self.mashroeynumber,
                    merchantCode: self.merchantCode!,
                    billFees: billFees
                )
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        // good let's show a messsage then goto the dashbord
                        guard response.txn == "200" else {
//                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
//                            })
                            if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                                presentingController.transactionFinished(response: response)
                            }
                            return
                        }
                        
                        if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                            presentingController.transactionFinished(response: response)
                        }
                        
//                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
//                            self.router?.closeModal()
//                            self.router?.goToDashboard()
//                        })
                        
                    }
                    
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
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
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
        */
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if ("\(vc.classForCoder)" == "TopUpController"){
            backBtn.addTarget(self, action: #selector(PayPresenter.logoCliked), for: .touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(PayPresenter.goToPreviousVC), for: .touchUpInside)
        }
//        backBtn.addTarget(self, action: #selector(LoadPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.flipImage()
        backBtn.imageView?.contentMode = .scaleAspectFit
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    
    func getNumOfUnreadNotification() {
        self.apiManager?.getNumOfUnreadNotification(mobile: (userManager.user?._mobile)!).subscribe(onNext: { (response) in
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
    
    func viewDidLoad(_ view: TopUpController){

        controller = view

        self.router?.displayAlert(msg: "loading".localized)

        self.apiManager?
            .TopUpList(mobile: self.userManager.user!._mobile!)
            .subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    //If Success Here
                    self.controller!.institutesReceived( response.institutions)
                    
                }
                
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.preDisposeBag)

    }
    
    @objc func goToPreviousVC(){
        self.router?.topupNav?.popViewController(animated: true)
    }

}
