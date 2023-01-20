////
////  CashoutRouter.swift
////  WalletsPaymob
////
////  Created by mahmoud gamal on 9/11/17.
////  Copyright © 2017 mahmoud gamal. All rights reserved.
////

import UIKit
import RxSwift

class CashoutRouter: Router {
    var presenter = CashoutPresenter()
    let disposeBag = DisposeBag()
    var cashoutNav: UINavController?
    var cashOutController: CashoutController?

     override init() {
         super.init()
         self.presenter.router = self
         let cashOutController = initController(fromStoryboard: "Cashout", controllerName: "CashoutController") as? CashoutController
         cashOutController?.viewDidLoadObserver.subscribe(onNext: {
             UpperViewRouter(embeddIn: (cashOutController?.upperView)! , containerVC: cashOutController!)
         })
         .disposed(by: disposeBag)
         cashOutController?.presenter = self.presenter
         self.pushToDrawer(controller: cashOutController!)
         cashoutNav = Router.drawerController?.centerViewController as? UINavController

    }
    
    init(type: String){
        super.init()
        self.presenter.router = self
        cashOutController = initController(fromStoryboard: "Cashout", controllerName: "CashoutController") as? CashoutController
        cashOutController?.viewDidLoadObserver.subscribe(onNext: {
            UpperViewRouter(embeddIn: (self.cashOutController?.upperView)! , containerVC: self.cashOutController!)
        })
        .disposed(by: disposeBag)
        cashOutController?.presenter = self.presenter
        self.presenter.type = type
        self.pushToDrawer(controller: cashOutController!)
        cashoutNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    override func goToDashboard(){
        Router.NavRouter?.goToDashboard()
    }
    
    func goToCashoutOtpViewController(){
        let cashoutOtpVC = initController(fromStoryboard: "Cashout", controllerName: "CashoutOtpController") as! CashoutOtpController
        cashoutOtpVC.presenter = self.presenter
        cashoutNav?.navigationItem.title = "Scan Details"
        self.push(into: (cashOutController?.navigationController)!, childController: cashoutOtpVC)
        
        cashoutOtpVC.viewDidLoadObserver.subscribe(onNext: {
            UpperViewRouter(embeddIn: cashoutOtpVC.upperView, containerVC: cashoutOtpVC)
        })
        .disposed(by: disposeBag)
    }
    
    func goToCashoutTimeOutViewController(){
        let cashoutTimeOutVC = initController(fromStoryboard: "Cashout", controllerName: "CashoutTimeOutViewController") as! CashoutTimeOutViewController
        cashoutTimeOutVC.presenter = self.presenter
        cashoutNav?.navigationItem.title = "Scan Details"
        self.push(into: (cashOutController?.navigationController)!, childController: cashoutTimeOutVC)
    }
}
