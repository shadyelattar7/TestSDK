//
//  LoadRouter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift
class LoadRouter: Router {
    var presenter:LoadPresenter?
    let disposeBag = DisposeBag()
    var loadController:LoadController?
    var loadCardListController:LoadCardTableController?
    var cashInOutController: CashInOutViewController?
    var loadNav: UINavigationController?
    
    
    override init() {
        super.init()
        self.presenter = LoadPresenter()
        
        self.cashInOutController = self.initController(fromStoryboard: "Load", controllerName: "CashInOutController") as! CashInOutViewController
        
        self.cashInOutController!.presenter = self.presenter
        self.presenter?.router = self
        self.pushToDrawer(controller: self.cashInOutController!)
        
        
        self.cashInOutController?.viewDidLoadObserver.subscribe(onNext: {
            _ = UpperViewRouter(embeddIn: self.cashInOutController!.upperBlue, containerVC: self.cashInOutController!)
        }).disposed(by: disposeBag)
        loadNav = Router.drawerController?.centerViewController as? UINavController
        
    }
    
    func goToLoadController() {
        self.loadController = self.initController(fromStoryboard: "Load", controllerName: "LoadController") as! LoadController
        loadController?.presenter = self.presenter
        self.loadController?.viewDidLoadObserver.subscribe(onNext: {
            //UpperViewRouter(embeddIn: self.loadController!.upperBlue, containerVC: self.loadController!)
            self.loadCardListController = self.loadController?.children[0] as! LoadCardTableController
            self.loadCardListController!.presenter = self.presenter
            self.loadCardListController?.viewDidLoad()
            
        }).disposed(by: disposeBag)
        self.push(into: loadNav!, childController: loadController!)
    }
    
    
    func goToCashoutController() {
//        let cashoutController = self.initController(fromStoryboard: "Load", controllerName: "CashoutController") as! CashoutController
//        cashoutController.presenter = self.presenter
//        self.push(into: loadNav!, childController: cashoutController)
    }
    
    func goToMapInfoController() {
        let cashoutController = self.initController(fromStoryboard: "Load", controllerName: "MapInfoDetailController") as! MapInfoDetailController
        //cashoutController.presenter = self.presenter
        self.push(into: loadNav!, childController: cashoutController)
    }
    
}
