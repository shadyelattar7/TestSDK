//
//  AuthRouter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AuthRouter: Router {
    
    private var authPresenter: AuthPresenter?
    private var authUINav: UINavigationController?
    private var currentController: UIViewController?
    private var confirmViewController:ConfirmationViewController?
    
    
    // use this init when it's the first time to validate the mobile number so we don't need any data
    override init() {
        super.init()
        // get the auth UINavController and customize it
        
        self.authUINav = self.initController(fromStoryboard: "Auth", controllerName: "AuthUINavigation") as? UINavigationController
        self.authUINav?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.authUINav?.navigationBar.shadowImage = UIImage()
        self.authUINav?.navigationBar.tintColor = self.settings.primaryColor
        
        
        // init the presenter
        self.authPresenter = AuthPresenter()
        self.authPresenter?.router = self
        self.authPresenter?.go()
        
        
        
    }
    
    init(withLogout:Bool = true){
        // logut routing
        // init presenter for logout
        
        super.init()
        self.authUINav = self.initController(fromStoryboard: "Auth", controllerName: "AuthUINavigation") as? UINavigationController
        self.authUINav?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.authUINav?.navigationBar.shadowImage = UIImage()
        self.authUINav?.navigationBar.tintColor = self.settings.primaryColor
        Router.drawerController = nil
        // init the presenter
        self.authPresenter = AuthPresenter()
        self.authPresenter?.router = self
        self.authPresenter?.go()
        //openLogin()
        
    }
    
    init(goToSetPin:Bool = true){
        // logut routing
        // init presenter for logout
        super.init()
        
        self.authUINav = self.initController(fromStoryboard: "Auth", controllerName: "AuthUINavigation") as? UINavigationController
        self.authUINav?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.authUINav?.navigationBar.shadowImage = UIImage()
        self.authUINav?.navigationBar.tintColor = self.settings.primaryColor
        Router.drawerController = nil
        // init the presenter
        self.authPresenter = AuthPresenter()
        self.authPresenter?.router = self
        
        /*
         let currentController = self.initController(fromStoryboard: "Auth", controllerName: "SetPinController")
         let setPin = currentController as! FirstTimeSetPinViewController
         setPin.presenter = AuthPresenter()
         setPin.navigationItem.hidesBackButton = true
         //main?.present(setPin, animated: true, completion: nil)
         authUINav?.pushViewController(setPin, animated: true)
         */
        //self.authPresenter?.go()
        //openLogin()
        
    }
    
    func goToSetPin(forPinExpiry:Bool = false) -> UIViewController {
        let currentController = initController(fromStoryboard: "Auth", controllerName: "SetPinController")
        let setPin = currentController as! FirstTimeSetPinViewController
        setPin.isPinExpiry = forPinExpiry
        setPin.presenter = AuthPresenter()
        setPin.presenter?.router = self
        setPin.navigationItem.hidesBackButton = true
        return setPin
    }
    
    func goToMobileVerfication(){
        // get the current page
        self.currentController = self.authUINav!.viewControllers[0]
        // wire the presenter
        let mobileValidation = self.currentController as! MobileValidation
        mobileValidation.presenter = self.authPresenter        
        // add it as rootview
        self.openAsRootView(controller: self.authUINav!)
        
    }
    
    func closeConfirmationPage(){
        self.confirmViewController!.dismiss(animated: true, completion: nil)
    }
    
    func goToValidationText(){
        self.currentController = self.initController(fromStoryboard: "Auth", controllerName: "ActivationView")
        let mobileActivation  = self.currentController as! ActivateViewController
        mobileActivation.presenter = self.authPresenter
        self.authUINav!.pushViewController(mobileActivation, animated: true)
    }
    
    func openLogin(){
        
        self.currentController = self.initController(fromStoryboard: "Auth", controllerName: "LoginView")
        let login = self.currentController as! LoginViewController
        login.presenter = self.authPresenter
        login.navigationItem.hidesBackButton = true
        self.authUINav?.pushViewController(login, animated: false)
        
    }
    
    func goToSetPinView() {
        self.currentController = self.initController(fromStoryboard: "Auth", controllerName: "SetPinController")
        let setPin = self.currentController as! FirstTimeSetPinViewController
        setPin.presenter = self.authPresenter
        setPin.navigationItem.hidesBackButton = true
        self.authUINav?.pushViewController(setPin, animated: true)
    }
    
    override func goToDashboard(){
        _ = NavigationRouter()
    }
    
    func openHowToRegPage(){
        var howToRegViewController = self.initController(fromStoryboard: "Auth", controllerName: "HowToRegViewController") as! HowToRegViewController
        howToRegViewController.presenter = self.authPresenter
        self.addModally(controller: howToRegViewController, transition: .coverVertical, presentation: .overCurrentContext)
        
    }
}
