//
//  SettingsRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class SettingsRouter: Router {
    var presenter = SettingsPresenter()
    var settingsNav: UINavController?
    
    override init() {
        super.init()
        self.presenter.router = self
        let settingsTable = initController(fromStoryboard: "Settings", controllerName: "SettingTable") as? SettingsTableViewController
        settingsTable?.presenter = self.presenter
        pushToDrawer(controller: settingsTable!)
        settingsNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    func goToResetMPin() {
        let resetPinVC = initController(fromStoryboard: "Settings", controllerName: "ResetPinVC") as? ResetPinViewController
        resetPinVC?.presenter = self.presenter
        self.push(into: settingsNav!, childController: resetPinVC!)
    }
    
    func goToTips() {
        let tipsVC = initController(fromStoryboard: "Settings", controllerName: "TipsController") as? TipsViewController
        //resetPinVC?.presenter = self.presenter
        self.push(into: settingsNav!, childController: tipsVC!)
    }
}
