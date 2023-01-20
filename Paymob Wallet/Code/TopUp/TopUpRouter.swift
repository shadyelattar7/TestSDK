//
//  TopUpRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 8/16/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class TopUpRouter: Router {
    var presenter = TopUpPresenter()
    let disposeBag = DisposeBag()
    var topupNav: UINavigationController?
    
    override init() {
        super.init()
        self.presenter.router = self
        let topUpController = initController(fromStoryboard: "TopUp", controllerName: "topUpController") as? TopUpController
        topUpController?.presenter = self.presenter
        self.pushToDrawer(controller: topUpController!)
        topupNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    override func goToDashboard(){
        Router.NavRouter?.goToDashboard()
    }
    
    func goToInquiryController() {
        let iquiryController = self.initController(fromStoryboard: "TopUp", controllerName: "TopupInquiryController") as! TopupInquiryController
        iquiryController.presenter = self.presenter
        topupNav?.pushViewController(iquiryController, animated: false)
       // self.push(into: topupNav!, childController: iquiryController)
    }
}
