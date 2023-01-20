//
//  AuthRouter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import DrawerController
import RxSwift


class NavigationRouter: Router {
    
    var presenter = NavigationPresenter()
    var currentCenter: NavigationViewController?
    var mainNavCenter: UINavigationController?
    let disposeBag = DisposeBag()
    
    var vcnController:VCNViewController?
   // var centerNav: UINavController?
    var vcardController:VCardViewController?
    
    override init(){
        super.init()
        self.presenter.router = self
        Router.NavRouter = self
        
        currentCenter = initController(fromStoryboard: "Main", controllerName: "dashboardVC") as? NavigationViewController
        mainNavCenter = initController(fromStoryboard: "Main", controllerName: "mainVCNav") as? UINavigationController

        currentCenter?.presenter = self.presenter

        mainNavCenter?.viewControllers = [currentCenter!]
         if Router.drawerController != nil {
            currentCenter?.presenter = self.presenter
            //Router.drawerController?.setCenter(currentCenter!, withCloseAnimation: true, completion: nil)
            Router.drawerController?.setCenter(mainNavCenter!, withCloseAnimation: true, completion: nil)
         } else {
            currentCenter?.presenter = self.presenter
            setupDrawer(currentCenter: mainNavCenter)
         }
        
    }
    // setup drawer with support for arabic
    
    func setupDrawer(currentCenter: UIViewController?){
        let drawerTableViewController = initController(fromStoryboard: "Main", controllerName: "Drawer") as? DrawerTableViewController
        if EntryPoint.langId == "ar" {
            Router.drawerController = DrawerController(centerViewController: currentCenter!, rightDrawerViewController: drawerTableViewController)
        } else {
            Router.drawerController = DrawerController(centerViewController: currentCenter!, leftDrawerViewController: drawerTableViewController)
        }
        drawerTableViewController?.presenter = self.presenter
//        Router.drawerController?.openDrawerGestureModeMask = .bezelPanningCenterView
//        Router.drawerController?.closeDrawerGestureModeMask = .all
//        Router.drawerController?.showsShadows = false
        openAsRootView(controller: Router.drawerController!,withTransition: true)
    }
    
    /// for audi setup drawer without support for arabic
    /*
    func setupDrawer(currentCenter: UIViewController?){
    
        let drawerTableViewController = initController(fromStoryboard: "Main", controllerName: "Drawer") as? DrawerTableViewController
        Router.drawerController = DrawerController(centerViewController: currentCenter!, leftDrawerViewController: drawerTableViewController)
        drawerTableViewController?.presenter = self.presenter
        Router.drawerController?.openDrawerGestureModeMask = .custom
        Router.drawerController?.closeDrawerGestureModeMask = .custom
        openAsRootView(controller: Router.drawerController!,withTransition: true)
    }*/
    
    
    func addToCenter(controller:UIViewController){
        let nav = initController(fromStoryboard: "Main", controllerName: "mainNav") as? UINavController
        nav?.presenter = self.presenter
        nav!.setViewControllers([controller], animated: false)
        nav?.navigationBar.tintColor = UIColor.white
        Router.drawerController?.setCenter(nav!, withCloseAnimation: true, completion: nil)

    }
    
    override func goToDashboard() {
        _ = NavigationRouter()
    }
    
    func goToSend()  {
        _ = SendRouter()
    }
    
    func goToPay()  {
        _ = PayRouter()
    }
    
    func goToCashout()  {
        _ = CashoutRouter(type: "cashout".localized)
    }
    
    func goToCashin()  {
        _ = CashoutRouter(type: "cashin".localized)
    }
    
    func goToTopUp(){
        _ = TopUpRouter()
    }
    
    func goToMap()  {
        _ = MapRouter()
    }
    
    func goToProfile()  {
        _ = ProfileRouter()
    }
    
    func goToNotifications()  {
        _ = NotificationRouter()
    }
    
    func goToContactUs()  {
        _ = ContactUsRouter()
    }
    
    func goToMerchants()  {
        _ = MerchantsRouter()
    }
    
    func goToHistory()  {
        _ = HistoryRouter()
    }
    
    func goToSettings()  {
        _ = SettingsRouter()
    }
    
    func goToLogout() {
        _ = AuthRouter(withLogout: true)
    }
    
    func goToServiceInfo() {
        _ = ServiceInfoRouter()
    }
    
    func goToVCN() {
        _ = PayRouter(currentPage: .vcn)
    }
    
    func goToWebView() {
        _ = PayRouter(currentPage: .webView)
    }
    
    func goToTransactionDetail(transaction: History){
        _ = HistoryRouter(transaction: transaction)
    }
    
    // MARK: - Open Pin page
    
    func openPinPage(completion:@escaping (_ pin:String) -> Void) {
        print("\n\nOpening Pin Page\n\n")
        let pinViewController = initController(fromStoryboard: "Pay", controllerName: "PayPinVC") as? PayPinViewController

        pinViewController?.onDone = { (pin) in
            // GO to next view controller
            print("DONE CLICKED")
            completion(pin)
        }
        addModally(controller: pinViewController!, transition: .coverVertical, presentation: .overCurrentContext)
        print("\n\nOpened Pin Page\n\n")
    }
    
    
    // MARK: - Generate
    
    func pushVCN(){
        _ = PayRouter(generateCard: true)

//        self.vcnController = self.initController(fromStoryboard: "Pay", controllerName: "vcnController") as! VCNViewController
     //   self.vcnController!.presenter = self.presenter
//        self.push(into: self.mainNavCenter!, childController: self.vcnController!)
//        self.mainNavCenter?.navigationItem.title = "VCN"
//        self.vcnController?.viewDidLoadObserver.subscribe(onNext: {
//            UpperViewRouter(embeddIn: self.vcnController!.upperView , containerVC: self.vcnController!)
//        }).disposed(by: disposeBag)
    }
    
    // MARK: - GO to card
    func goToCard(card: VirtualCard){
        _ = PayRouter(virtualCard: card)
//        self.vcardController = self.initController(fromStoryboard: "Pay", controllerName: "vCardController") as! VCardViewController
     //   self.vcardController!.presenter = self.presenter
        /*vcardController?.viewDidLoadObserver.subscribe(onNext: {
         _ = UpperViewRouter(embeddIn: (self.vcardController?.upperView)! , containerVC: self.vcardController!)
         }).disposed(by: disposeBag)*/
//        self.push(into: self.mainNavCenter!, childController: self.vcardController!)
//        self.mainNavCenter?.navigationItem.title = "Virtual Card"
        
    }
}
