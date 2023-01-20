//
//  MerchantsRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class MerchantsRouter: Router {
    var presenter = MerchantsPresenter()
    var merchantNav: UINavController?
    var merVc: MerchantsViewController?

    override init() {
        super.init()
        self.presenter.router = self
        let merchantVc = initController(fromStoryboard: "Merchants", controllerName: "merchantsVC") as? MerchantsViewController
        merchantVc?.presenter = self.presenter
        pushToDrawer(controller: merchantVc!)
    }
    
    init(fromPay: Bool) {
        super.init()
        self.presenter.router = self
        merchantNav = Router.drawerController?.centerViewController as? UINavController
        merVc = initController(fromStoryboard: "Merchants", controllerName: "merchantsVC") as? MerchantsViewController
        merVc?.presenter = MerchantsPresenter(fromPay: fromPay)
        self.push(into: merchantNav!, childController: merVc!)
    }
    
    
}
