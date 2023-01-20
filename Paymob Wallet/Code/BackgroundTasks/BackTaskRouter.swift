//
//  BackTaskRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/13/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import DrawerController

class BackTaskRouter: Router {
    var presenter = BackTaskPresenter()
    var requireAuthController: RequireAuthViewController?
    var updateAppController: UpdateAppViewController?
    override init() {
        super.init()
        self.presenter.router = self
        
    }
    
    func goToRequireAuth() {
        requireAuthController = initController(fromStoryboard: "BackgroundTasks", controllerName: "RequireAuthVC") as? RequireAuthViewController
        requireAuthController?.presenter = self.presenter
        let nav = self.window.rootViewController as? DrawerController
        nav?.children[0].present(requireAuthController!, animated: true, completion: nil)
    }
    
    func goToUpdateAPP() {
        updateAppController = initController(fromStoryboard: "BackgroundTasks", controllerName: "UpdateAppVC") as? UpdateAppViewController
        updateAppController?.presenter = self.presenter
        let nav = self.window.rootViewController
        nav?.children[0].present(updateAppController!, animated: true, completion: nil)
    }
    
    func goBack() {
        requireAuthController?.dismiss(animated: true, completion: nil)
    }
}
