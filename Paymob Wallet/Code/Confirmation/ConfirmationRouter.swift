//
//  ConfirmationRouter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ConfirmationRouter: Router {
    
    private var confirmViewController:ConfirmationViewController?
    private var pinViewController:PinViewController?
    private var confirmPresenter:ConfirmationPresenter?
    
    
    init(pinObserver:AnyObserver<String>,transaction:Transaction){
        super.init()
        self.confirmPresenter = ConfirmationPresenter(pinObserver:pinObserver,transaction: transaction)
        self.confirmPresenter?.router = self
        self.confirmViewController = self.initController(fromStoryboard: "Confirmation", controllerName: "confirmationView") as! ConfirmationViewController
        self.confirmViewController!.presenter = self.confirmPresenter
        self.addModally(controller: confirmViewController!, transition: .flipHorizontal)
    }
    func closeConfirmationPage(){
        self.confirmViewController!.dismiss(animated: true, completion: nil)
    }
    func openPinPage(){
        self.pinViewController = self.initController(fromStoryboard: "Confirmation", controllerName: "ConfirmController") as! PinViewController
        self.pinViewController?.presenter = self.confirmPresenter
        self.addModally(controller: pinViewController!, transition: .coverVertical, presentation: .overCurrentContext)
        
    }
    func closePinPage(after:(()->())?){
        self.confirmViewController?.dismiss(animated: true, completion: after)
    }
   }
