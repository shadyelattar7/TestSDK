//
//  IntroRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/14/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import Foundation

class IntroRouter: Router {
    var presenter = IntroPresenter()
    var pageController: PageController?
    
    override init() {
        super.init()
        self.presenter.router = self
        
        pageController = initController(fromStoryboard: "Intro", controllerName: "pageController") as? PageController
        pageController?.presenter = self.presenter
        
        self.window.rootViewController = pageController
        self.window.makeKeyAndVisible()
    }
    
}
