//
//  ContactUsRouter.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ContactUsRouter: Router {
    var presenter:ContactUsPresenter?
    let disposeBag = DisposeBag()
    var contactUsController:ContactUsViewController?
    
    override init() {
        super.init()
        presenter = ContactUsPresenter()
        contactUsController = initController(fromStoryboard: "ContactUs", controllerName: "ContactUsVC") as? ContactUsViewController
        contactUsController!.presenter = presenter
        presenter?.router = self
        pushToDrawer(controller: contactUsController!)

    }
}
