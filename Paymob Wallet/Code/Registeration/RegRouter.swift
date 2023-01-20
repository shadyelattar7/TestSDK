//
//  RegRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 1/9/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class RegRouter: Router {
    var presenter = RegPresenter()
    let disposeBag = DisposeBag()
    
    var regNav: UINavigationController?
    
    var mainController: MainController?
    
    var registerNav: UINavigationController!
    
    override init() {
        super.init()
        self.presenter.router = self
        mainController = initController(fromStoryboard: "Registeration", controllerName: "regMain") as? MainController
        mainController?.presenter = self.presenter
        
        regNav = self.initController(fromStoryboard: "Registeration", controllerName: "regNav") as? UINavigationController
        regNav?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        regNav?.navigationBar.shadowImage = UIImage()
        //regNav?.navigationBar.barTintColor = settings.primaryColor
        regNav?.setViewControllers([mainController!], animated: true)
        mainController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        mainController?.navigationController?.navigationBar.barTintColor = UIColor.red
        self.window.rootViewController = regNav!
        self.window.makeKeyAndVisible()
    }
    
    override func goToDashboard(){
        Router.NavRouter?.goToDashboard()
    }
    
    func goToAuth() {
        _ = AuthRouter()
    }
    
    func goToSelfReg() {
        let selfReg = initController(fromStoryboard: "Registeration", controllerName: "selfReg") as? SelfRegViewController
        selfReg?.presenter = self.presenter
        //self.regNav?.pushViewController(selfReg!, animated: true)
        
        registerNav = initController(fromStoryboard: "Registeration", controllerName: "regNavigation") as! UINavigationController
        registerNav.setViewControllers([selfReg!], animated: true)
        self.window.rootViewController = registerNav
        self.window.makeKeyAndVisible()
    }
    
    func goToFinalRegController() {
        let finalRegController = initController(fromStoryboard: "Registeration", controllerName: "finalReg") as! FinalRegController
        finalRegController.presenter = self.presenter
        registerNav.pushViewController(finalRegController, animated: true)
    }
    
}
