//
//  File.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class SendRouter: Router {
    var sendController:SendController?
    var presenter:SendPresenter?
    let disposeBag = DisposeBag()
    override init() {
        super.init()
        self.presenter = SendPresenter()
        self.presenter?.router = self
        self.sendController = self.initController(fromStoryboard: "Send", controllerName: "SendController") as! SendController
        self.sendController?.presenter = self.presenter
        self.pushToDrawer(controller: self.sendController!)
       
        self.sendController?.viewDidLoadObserver.subscribe(onNext: {
             UpperViewRouter(embeddIn: self.sendController!.upperView, containerVC: self.sendController!)
        })
        .disposed(by: disposeBag)
       
    }
    
    func embeddContactsView(into vc: UIViewController, container: UIView) {
        let contactsVC = initController(fromStoryboard: "Send", controllerName: "contactsVC") as? ContactsViewController
        contactsVC?.presenter = self.presenter
        self.embedd(into: vc, childController: contactsVC!, containerView: container)
    }
    
    func goToSendAmountViewController(){
        let sendAmountVC = initController(fromStoryboard: "Send", controllerName: "SendAmountController") as! SendAmountController
        sendAmountVC.presenter = self.presenter
        sendController?.navigationController?.navigationItem.title = "Scan Details"
        self.push(into: (self.sendController?.navigationController)!, childController: sendAmountVC)
        
        sendAmountVC.viewDidLoadObserver.subscribe(onNext: {
            UpperViewRouter(embeddIn: sendAmountVC.upperView, containerVC: sendAmountVC)
        })
        .disposed(by: disposeBag)
    }
    
   
}
