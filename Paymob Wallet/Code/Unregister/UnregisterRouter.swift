//
//  UnregisterRouter.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation

class UnregisterRouter: Router {
    weak var unregisterController: UnregisterViewController?
    var presenter = UnregisterPresenter()
    
    override init() {
        super.init()
        print("\n\nUnregister Router")
        presenter = UnregisterPresenter()
        self.presenter.router = self
        unregisterController = initController(fromStoryboard: "Unregister", controllerName: "UnregisterVC") as? UnregisterViewController
        unregisterController?.presenter = presenter
        self.presenter.controller = unregisterController
    }
    
    func closeApp(){
//        exit(0);
        _ = AuthRouter(withLogout: true)
    }
}
