//
//  NotificationPresenter.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/18/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import Foundation
import RxSwift

class NotificationPresenter: Presenter {
    var router: NotificationRouter?
    var apiManger: NotificationApiManager?
    var localManager:AuthLocalManager?
    var disposeBag = DisposeBag()
    //var notificationArray = [Notification]()
    var notificationArray = BehaviorSubject<[Notification]>(value: [])
    var currentNotification = BehaviorSubject<Notification>(value: Notification())
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    var currentNoti: Notification?
    var mobile: String!
    private var trans:Transaction?
    
    var qrDataDic: [String: String]?
    var qrReDataArr: [String]?
    
    var qrDataKeys: [String]?
    var qrDataValues: [String]?
    
    var qrUpdatedDataDic: [String: String] = [:]
    var qrFinalDataDic: [String: String] = [:]
    
    var qrFees: String?
    var qrFeesPerc: String?
    var qrTip: String?
    var qrFinalAmount: String?
    var qrMerchantId: String?
    var isQrDataEntered: [Bool]?
    var keyboardType: [UIKeyboardType]?
    
    var isQrDataComplete: Bool? = false
    
    var merCodeObserver = BehaviorSubject<String>(value:"")
    var merNameObserver = BehaviorSubject<String>(value:"")
    var merAmountObserver = BehaviorSubject<String>(value:"")
    var merBillRefObserver = BehaviorSubject<String>(value:"")
    
    
    override init(){
        super.init()
        self.apiManger = NotificationApiManager()
        self.localManager = AuthLocalManager()
        if (localManager?.userExist)! {
            mobile = localManager?.user?._mobile
            Util.debugMsg(mobile)
        }
        
        qrDataKeys = []
        qrDataValues = []
        isQrDataEntered = []
        keyboardType = []
    }
    
    func cellSelected(row: Int) {
//        self.router?.goToNotificationDetailController(self.notificationArray[row])
        notificationArray.bind {[weak self] (notifications) in
            guard notifications.count > row else {
                return
            }
            self?.currentNotification.onNext(notifications[row])
            }.disposed(by: disposeBag)
    }
    
    
    func selected(_ notification: Notification) {
        if notification.data.type == "INVITE TO GAMEYA" || notification.data.type == "GAM3EYA PAYMENT NOTIFICATION" {
//            self.router?.goToGam3yaInvitationController(notification)
        } else if notification.data.type == "REQUEST TO PAY NOTIFICATION" {
            if currentNoti?.data.r2PData?.keys.contains("QRCODE") ?? false {
                qrRequestAfterScanning(scanResult: currentNoti?.data.r2PData?["QRCODE"] ?? "")
            } else {
                qrMerchantId = currentNoti?.data.r2PData?["Merchant ID"]
                newQrSuccessifullScan(merId: currentNoti?.data.r2PData?["Merchant ID"], qrDataDic: currentNoti?.data.r2PData)
            }
        } else {
            self.router?.goToNotificationDetailController(notification)
        }
        
        self.apiManger?
            .setNotification(dateTime: notification.data.preFormattedDate, mobile: mobile, action: .read)
            .subscribe(onNext: { (response) in
                print(response.toJSON())
            })
            .disposed(by: self.disposeBag)
    }
    
    
    
    func getAllNotification(completed: (([Notification]) -> Void)? = nil) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.getAllNotification(mobile: mobile).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                completed?(response.notifications)
                return
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    
    func requestRateButton()->Bool{
        let rate =  localManager?.user?._rating ?? true
        return rate
    }
    
    // read or delete notification
    func setNotification(dateTime: String, action: NotificatinAction, completed: (([Notification]) -> Void)? = nil) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.setNotification(dateTime: dateTime, mobile: mobile, action: action).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                if action == .delete {
                    self.getAllNotification(completed: completed)
                }
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
//    func getNumOfUnreadNotification() {
//        self.router?.displayAlert(msg: NSLocalizedString("loading", comment: "loading"))
//        self.apiManger?.getNumOfUnreadNotification(mobile: mobile).subscribe(onNext: { (response) in
//            self.router?.hideMsg {
//                guard response.txn == "200" else {
//                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
//                    })
//                    return
//                }
//                UIApplication.shared.applicationIconBadgeNumber = response.numberOfUnreadNoti
//            }
//
//        }, onError: { (error) in
//            self.router?.hideMsg {
//                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
//                })
//            }
//        }).disposed(by: disposeBag)
//    }
    
    func deleteAllNotifications() {
        router?.sweetAlertWarning(message: "youWantToDeleteAll".localized, afterMsg: {
            
            self.router?.displayAlert(msg: "loading".localized)
            self.apiManger?.deleteAllNotifications(mobile: self.mobile).subscribe(onNext: { (response) in
                
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    self.getAllNotification()
                    
                }
                
                
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.disposeBag)
        })
    }
    
    func cashoutAcceptClicked(pin: String, notification: Notification, vc: UIViewController) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.acceptCashout(pin: pin, mobile: mobile, notification: notification).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        vc.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                
                if self.userManager.userExist {
                    self.userManager.save(saveCall: { (user) in
                        user._balance = response.balance
                    })
                }
                
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    vc.navigationController?.popViewController(animated: true)
                })
            }
            
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func cashoutCancelClicked(pin: String, notification: Notification, vc: UIViewController) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.rejectCashout(pin: pin, mobile: mobile, notification: notification).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        vc.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    vc.navigationController?.popViewController(animated: true)
                })
            }
            
            Util.debugMsg(response.txn)
            Util.debugMsg(response.msg)
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func cashInAcceptClicked(pin: String, notification: Notification, vc: UIViewController) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.acceptCashIn(pin: pin, mobile: mobile, notification: notification).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        vc.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    vc.navigationController?.popViewController(animated: true)
                })
            }
            
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func cashInCancelClicked(pin: String, notification: Notification, vc: UIViewController) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.rejectCashIn(pin: pin, mobile: mobile, notification: notification).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        vc.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    vc.navigationController?.popViewController(animated: true)
                })
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func billPaymentAcceptClicked(notification: Notification){
        self.trans = Transaction()
        self.trans?.amount = notification.data.amount
        self.trans?.type = "BILLPAYMENT" //TODO:: hide in a constant
        self.trans?.toWhom = notification.data.billerCode
        self.trans?.title = "pay".localized
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                self.confirm(transaction: trans!).subscribe(onNext: { (pin) in
                    self.router?.displayAlert(msg: "loading".localized)
                    self.apiManger?.billPayment(pin: pin, amount: notification.data.amount, mobile: mobile, notification: notification)
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
                                    self.router?.closeModal()
                                    self.router?.goToDashboard()
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
    
    func consumerPullAcceptClicked(notification: Notification){
        self.trans = Transaction()
        self.trans?.amount = notification.data.amount
        self.trans?.type = "BILLPAYMENT" //TODO:: hide in a constant
        self.trans?.toWhom = notification.data.billerCode
        self.trans?.title = "pay".localized
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                self.confirm(transaction: trans!).subscribe(onNext: { (pin) in
                    self.router?.displayAlert(msg: "loading".localized)
                    self.apiManger?.consumerPull(pin: pin, amount: notification.data.amount, mobile: mobile, notification: notification)
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
                                    self.router?.closeModal()
                                    self.router?.goToDashboard()
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
    
    
    
    func displayVerifiy(vc: UIViewController) -> Observable<String> {
        return Observable.create({ (pin) -> Disposable in
            let popup=UIAlertController(title: "", message:"enterYourPin".localized , preferredStyle: UIAlertController.Style.alert)
            
            popup.addAction(UIAlertAction(title: "verify".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                pin.onNext((popup.textFields?.first?.text)!)
            }))
            
            popup.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                //pin.onNext("")
            }))
            popup.addTextField(configurationHandler: { (name) in
                name.placeholder="pin".localized
                name.isSecureTextEntry = true
                name.keyboardType=UIKeyboardType.numberPad
                name.textAlignment=NSTextAlignment.center
            })
            vc.present(popup, animated: true, completion: nil)
            return Disposables.create()
        })
    }
    
    func goBack(vc: UIViewController) {
        router?.goBack(vc: vc)
    }
    
    @objc func toPreviousVC() {
        router?.notificationNav?.popViewController(animated: true)
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
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(NotificationPresenter.notificationClicked), for: .touchUpInside)
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
        if ("\(vc.classForCoder)" == "NotificationViewController"){
            backBtn.addTarget(self, action: #selector(NotificationPresenter.logoCliked), for: .touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(NotificationPresenter.toPreviousVC), for: .touchUpInside)
        }
//        backBtn.addTarget(self, action: #selector(NotificationPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.flipImage()
        backBtn.imageView?.contentMode = .scaleAspectFit
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    func getNumOfUnreadNotification() {
        self.apiManger?.getNumOfUnreadNotification(mobile: (self.mobile ?? localManager?.user?._mobile)!).subscribe(onNext: { (response) in
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
    
    func qrUpdatedData() {
        qrUpdatedDataDic = [:]
        var i = 0
        for key in self.qrDataKeys! {
            qrUpdatedDataDic.updateValue((qrDataValues?[i])!, forKey: key)
            i = i+1
        }
    }
    
    func generateQRFinalDicAndAmount () {
        if currentNoti?.data.r2PData?.keys.contains("QRCODE") ?? false {
            for key in self.qrReDataArr ?? [] {
                if self.qrUpdatedDataDic.keys.contains(key) {
                    qrFinalDataDic.updateValue(qrUpdatedDataDic[key]!, forKey: key)
                }
            }
            
            var finalFees = 0.0
            self.qrMerchantId = self.qrUpdatedDataDic["Merchant ID"]
            self.qrFees = self.qrUpdatedDataDic["Convenience Fees"]
            self.qrFeesPerc = self.qrUpdatedDataDic["Convenience Fees (%)"]
            let enteredAmount = self.qrUpdatedDataDic["Amount"]
            self.qrTip = self.qrUpdatedDataDic["Tip"]
            
            if let tips = qrTip {
                if let dTip = Double(tips){
                    finalFees = dTip
                }
            } else if let convFees = qrFees {
                if let dFees = Double(convFees) {
                    finalFees = dFees
                }
            } else if let conFeesPerc = qrFeesPerc, let amo = enteredAmount {
                if let dfee = Double(conFeesPerc), let dAmo = Double(amo) {
                    let cfee = (dfee/100) * dAmo
                    finalFees = cfee + dAmo
                }
            }
            
            qrFinalAmount = "0"
            if let finalAmo = Double(enteredAmount ?? "0") {
                let final = finalAmo + finalFees
                qrFinalAmount = String(final)
            }
        } else {
            qrFinalDataDic = qrUpdatedDataDic
            var finalFees = 0.0
            self.qrMerchantId = self.qrUpdatedDataDic["Merchant ID"]
            self.qrFees = self.qrUpdatedDataDic["Convenience Fees"]
            self.qrFeesPerc = self.qrUpdatedDataDic["Convenience Fees (%)"]
            let enteredAmount = self.qrUpdatedDataDic["Amount"]
            self.qrTip = self.qrUpdatedDataDic["Tip"]
            
            if let tips = qrTip {
                if let dTip = Double(tips){
                    finalFees = dTip
                }
            } else if let convFees = qrFees {
                if let dFees = Double(convFees) {
                    finalFees = dFees
                }
            } else if let conFeesPerc = qrFeesPerc, let amo = enteredAmount {
                if let dfee = Double(conFeesPerc), let dAmo = Double(amo) {
                    let cfee = (dfee/100) * dAmo
                    finalFees = cfee + dAmo
                }
            }
            
            qrFinalAmount = "0"
            if let finalAmo = Double(enteredAmount ?? "0") {
                let final = finalAmo + finalFees
                qrFinalAmount = String(final)
            }
        }
    }
    
    func pay(amount: String?, orderNumber: String?, ref1: String?, ref2: String?) {
        let trans = Transaction()
        guard amount != nil &&  orderNumber != nil else{
            self.router?.sweetAlertFail(message: "You should enter the amount and the reciet no.", afterMsg: {
            })
            return
        }
        
        trans.amount = amount
        trans.title = "pay".localized
        trans.toWhom = qrMerchantId ?? ""
        trans.type = "P2M"
        
        self.sendPayRequest(amount: amount, orderNumber: orderNumber, merchantCode: qrMerchantId ?? "", trans: trans, ref1: ref1, ref2: ref2)
    }
    
    
    func sendPayRequest(amount:String?,orderNumber:String?, merchantCode: String, trans: Transaction, ref1: String?, ref2: String?) {
        self.confirm(transaction: trans).subscribe(onNext: { (pin) in
            self.merCodeObserver.onNext(merchantCode)
            self.router?.displayAlert(msg: "loading".localized)
            
            self.apiManger?.merchantPayf(pin: pin, myMobile: self.userManager.user!._mobile!, amount: amount!, merchOrder: orderNumber!, merchNo: merchantCode, additionalData: self.qrFinalDataDic, ref1: ref1, ref2: ref2)
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
                            self.router?.closeModal()
                            self.router?.goToDashboard()
                        })
                        
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: preDisposeBag)
    }
    
    
    
    func convertQRDicToArrays(qrDataDic: [String: String]?) {
        isQrDataEntered = []
        keyboardType = []
        for (key, value) in qrDataDic ?? [:] {
            self.qrDataKeys?.append(key)
            self.qrDataValues?.append(value)
            if value == "***" {
                isQrDataEntered?.append(true)
            } else {
                isQrDataEntered?.append(false)
            }
            
            if key == "Bill number" || key == "Purpose" {
                keyboardType?.append(.default)
            } else {
                keyboardType?.append(.decimalPad)
            }
        }
    }
    
    func newQrSuccessifullScan(merId: String?, merName: String? = "", qrDataDic: [String: String]?) {
        guard !merId!.isEmpty else {
            self.router?.sweetAlertFail(message: "Brand Code is empty", afterMsg: {
            })
            return
        }
        merCodeObserver.onNext(merId!)
        merNameObserver.onNext(merName!)
        convertQRDicToArrays(qrDataDic: qrDataDic)
        
        self.router?.goToQrDetailsController()
    }
    
    
    func qrRequestAfterScanning(scanResult: String) {
        merCodeObserver = BehaviorSubject<String>(value:"")
        merNameObserver = BehaviorSubject<String>(value:"")
        merAmountObserver = BehaviorSubject<String>(value:"")
        merBillRefObserver = BehaviorSubject<String>(value:"")
        self.router?.displayAlert(msg: "loading".localized)
        apiManger?.parseQR(qrCode: scanResult).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                self.qrDataDic = [:]
                self.qrReDataArr = []
                self.qrDataValues = []
                self.qrDataKeys = []
                
                self.qrDataDic = response.qrDataDic
                self.qrReDataArr = response.qrReDataArr
                
                self.qrFees = response.qrFees
                self.qrFeesPerc = response.qrFeesPerc
                self.qrTip = response.qrTip
                self.newQrSuccessifullScan(merId: response.qrMerCode, merName: response.qrMerchantName, qrDataDic: self.qrDataDic)
            }
            
        }, onError: { (error) in
            // usally an internet error
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: preDisposeBag)
    }
    
    
    
}
