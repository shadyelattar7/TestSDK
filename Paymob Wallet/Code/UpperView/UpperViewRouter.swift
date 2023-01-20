//
//  UpperViewRouter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/14/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit

class UpperViewRouter: Router {
    var presenter:UpperViewPresenter?
    
    var upperViewController:UpperBlueViewController?
    
    init(embeddIn:UIView, containerVC:UIViewController){
        super.init()
        
        self.upperViewController = initController(fromStoryboard: "UpperView", controllerName: "upperView") as! UpperBlueViewController
        self.presenter = UpperViewPresenter()
        self.presenter?.router = self
        self.upperViewController?.presenter = self.presenter
        
        self.embedd(into: containerVC, childController: self.upperViewController!, containerView: embeddIn)
        
        
    }
    
    
}
