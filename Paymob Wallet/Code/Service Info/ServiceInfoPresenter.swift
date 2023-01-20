//
//  ServiceInfoPresenter.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ServiceInfoPresenter: Presenter {
    var router: ServiceInfoRouter?
    var apiManger: ServiceInfoApiManger?
    var disposeBag = DisposeBag()
    var view : ServiceViewController?
    var serviceInfo = [ServiceInfoEntity]()
    override init(){
        super.init()
        self.apiManger = ServiceInfoApiManger()
    }
    
    func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    func requestSerivceInfo(){
        router?.displayAlert(msg: "loading".localized)
        apiManger?.serviceInfo().subscribe(onNext: { (response) in
            Util.debugMsg(response)
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.closeModal()
                        self.router?.goToDashboard()
                    })
                    return
                }
                self.serviceInfo = response.ServiceInfo
                self.view?.reloadTableView()
              
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
        
    }
    
    func showDetailsServiceInfo(serviceInfo :ServiceInfoEntity){
        router?.goToServiceInfoDetailController(serviceInfo)
    }
}
