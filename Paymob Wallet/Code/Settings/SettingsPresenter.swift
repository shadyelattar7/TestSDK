//
//  SettingsPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class SettingsPresenter: Presenter {
    var router: SettingsRouter?
    var apiManger: SettingsApiManager?
    //var localManager:AuthLocalManager?
    var disposeBag = DisposeBag()
    var mobile: String?
    var localManager: AuthLocalManager?
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)

    override init() {
        super.init()
        apiManger = SettingsApiManager()
        self.localManager = AuthLocalManager()
        if (self.localManager?.userExist)! {
            mobile = localManager?.user?._mobile
        }
    }
    
    func cellClicked(row: Int) {
        if row == 0 {
        router?.goToResetMPin()
        } else {
            router?.goToTips()
        }
    }
    
    func setUpRatingSwitch() ->Bool{
       return localManager?.user?._rating ?? true
    }
    
    func ratingSwitch(rating:Bool){
        localManager?.save(saveCall: { user in
            user._rating = rating
        })
    }
    
    func resetMpin(pin: String, newPin: String, confPin: String) {
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.resetMPin(pin: pin, newPin: newPin, confPin: confPin, mobile: mobile!).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
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
        }).disposed(by: disposeBag)
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
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuBtn.addTarget(self, action: #selector(SettingsPresenter.menuClicked), for: .touchUpInside)
        menuBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(SettingsPresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(ImageProvider.image(named: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
            //            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
                        
                        numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                            notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
                        }).disposed(by: disposeBag)
                        
                        numOfUnreadNoti.onNext( Int(localManager?.user?._noOfUnreadNoti ?? "0") ?? 0 )
                }
        
        vc.navigationItem.leftBarButtonItems = [menuBarBtn, notificationBarBtn]
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(SettingsPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.rightBarButtonItems = [backBarBtn]
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
}
