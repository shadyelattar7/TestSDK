//
//  ContactUsPresenter.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ContactUsPresenter: Presenter {
    var router: ContactUsRouter?
    var apiManger: ContactUsApiManager?
    var disposeBag = DisposeBag()
    var localManager: AuthLocalManager?
    let number = "15171"
    var mobile: String?

    override init() {
        super.init()
        apiManger = ContactUsApiManager()
        localManager = AuthLocalManager()
        if (localManager?.userExist)! {
            mobile = localManager?.user?._mobile
        }
    }
    
    func callClicked() {
        guard let url = URL(string: "tel://" + number) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func sendMessageClicked(message: String) {
        router?.displayAlert(msg: "loading".localized)
        apiManger?.sendMessage(message: message, mobile: mobile!).subscribe(onNext: { (response) in
            Util.debugMsg(response)
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.goToDashboard()
                    })
                    return
                }
                //MARK: - If Success
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    NavigationPresenter.currentModule = "Dashboard"
                    self.router?.goToDashboard()
                })            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func menuClicked()  {
        router?.toogleDrawer()
    }
}
