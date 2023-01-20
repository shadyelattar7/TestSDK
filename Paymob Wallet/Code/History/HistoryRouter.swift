//
//  HistoryRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class HistoryRouter: Router {
    var presenter = HistoryPresenter()
    var historyNav: UINavigationController?
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        self.presenter.router = self
        let historyController = initController(fromStoryboard: "History", controllerName: "HistoryVC") as? HistoryViewController
        historyController?.presenter = self.presenter
        historyController?.viewDidLoadObserver.subscribe(onNext: {
            UpperViewRouter(embeddIn: (historyController?.upperBlueContainer)! , containerVC: historyController!)
        }).disposed(by: disposeBag)
        pushToDrawer(controller: historyController!)
        historyNav = Router.drawerController?.centerViewController as? UINavController

    }
    
    init(transaction: History) {
        super.init()
        self.presenter.router = self
        let historyController = initController(fromStoryboard: "History", controllerName: "detailHistory") as? DetailHistoryViewController
        historyController?.presenter = presenter
        self.presenter.currentHistory.onNext(transaction)
        pushToDrawer(controller: historyController!)
        }

    
    
    func embeddHistoryTableView(into vc: UIViewController, container: UIView) {
        let historyTableView = initController(fromStoryboard: "History", controllerName: "HistoryTable") as? HistoryTableViewController
        historyTableView?.presenter = self.presenter
        self.embedd(into: vc, childController: historyTableView!, containerView: container)
    }
    
    func goToDetailController() {
        let detailHistory = initController(fromStoryboard: "History", controllerName: "detailHistory") as? DetailHistoryViewController
        detailHistory?.presenter = self.presenter
        self.push(into: historyNav!, childController: detailHistory!)
    }
    
    func showExpoertView(){
     
        let emailViewController = initController(fromStoryboard: "History", controllerName: "emailViewController") as? emailViewController
            emailViewController?.presenter = presenter
        push(into: historyNav!, childController: emailViewController!)
    }
    
    override func goToDashboard() {
        _ = NavigationRouter()
    }
}
