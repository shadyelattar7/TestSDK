//
//  ServiceInfoRouter.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit
import RxSwift
class ServiceInfoRouter: Router {
    
    var presenter = ServiceInfoPresenter()
    let disposeBag = DisposeBag()
    var notificationNav: UINavController?
    
    override init() {
       super.init()
       self.presenter.router = self
       let ServiceViewController = initController(fromStoryboard: "ServiceInfo", controllerName: "ServiceViewController") as? ServiceViewController
        ServiceViewController?.presenter = self.presenter
        presenter.view = ServiceViewController
       self.pushToDrawer(controller: ServiceViewController!)
        notificationNav = Router.drawerController?.centerViewController as? UINavController
   }
    
    
    func goToServiceInfoDetailController(_ serviceInfo: ServiceInfoEntity) {
        let detailService = initController(fromStoryboard: "ServiceInfo", controllerName: "ServiceInfoDetailsViewController") as? ServiceInfoDetailsViewController
        detailService?.presenter = presenter
        detailService?.serviceInfoDetails = serviceInfo
        self.push(into: notificationNav!, childController: detailService!)
    }
}
