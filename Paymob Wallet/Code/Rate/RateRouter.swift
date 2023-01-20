//
//  RateRouter.swift
//  Paymob Wallet
//
//  Created by mac on 13/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class RateRouter: Router {
    var presenter = RatePresenter()
    var viewController = UIViewController()
    var ratNav: UINavController?
    var TXNID = String()
    init(TXNID:String) {
        super.init()
        self.presenter.router = self
        let rateVC = initController(fromStoryboard: "Rate", controllerName: "rateVC") as! rateVC
        rateVC.presenter = self.presenter
        self.presenter.viewController = rateVC
        self.viewController = rateVC
        rateVC.TXNID =  TXNID
//        pushToDrawer(controller: rateVC)
//        ratNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    func close(){
        ViewAnimation().removeTermsAndConditions(controller: self.viewController)
        viewController.dismiss(animated: true)
//        self.closeModal()
//        self.goToDashboard()
    }
    
}
