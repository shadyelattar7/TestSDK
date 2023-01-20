//
//  PayRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift
import QRCodeReader
import AVFoundation


class PayRouter: Router {
    var presenter = PayPresenter()
    let disposeBag = DisposeBag()
    
    var centerNav:UINavController?
    
    var payController:PayViewController?
    var merPay:MerchantPayViewController?
    var vcnController:VCNViewController?
    var vcardController:VCardViewController?
    
    var qrDetailController: QrDetailsController?
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    override init() {
        super.init()
        self.presenter.router = self
        let payController = initController(fromStoryboard: "Pay", controllerName: "payVC") as? PayViewController
        payController?.presenter = self.presenter
        payController?.viewDidLoadObserver.subscribe(onNext: {
            _ = UpperViewRouter(embeddIn: (payController?.upperView)! , containerVC: payController!)
        }).disposed(by: disposeBag)
        pushToDrawer(controller: payController!)
        
        self.centerNav = Router.drawerController?.centerViewController as? UINavController
        
    }
    
    init(currentPage: currentPage) {
        super.init()
        self.presenter.router = self
        let payController = initController(fromStoryboard: "Pay", controllerName: "payVC") as? PayViewController
        payController?.presenter = self.presenter
        presenter.currentPage.onNext(currentPage)
        payController?.viewDidLoadObserver.subscribe(onNext: {
            _ = UpperViewRouter(embeddIn: (payController?.upperView)! , containerVC: payController!)
        }).disposed(by: disposeBag)
        pushToDrawer(controller: payController!)
        
        self.centerNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    func openPayMer(){
        self.merPay = initController(fromStoryboard: "Pay", controllerName: "merchantPay") as! MerchantPayViewController
        self.merPay?.presenter = self.presenter
        self.merPay?.viewDidLoadObserver.subscribe(onNext: {
            _ = UpperViewRouter(embeddIn: (self.merPay?.upperView)! , containerVC: self.merPay!)
        }).disposed(by: disposeBag)
//        self.addModally(controller: self.merPay!, transition: .crossDissolve)
        self.push(into: centerNav!, childController: merPay!)
    }
    
    init(virtualCard: VirtualCard) {
        super.init()
        self.presenter.router = self
        self.presenter.currentCard = virtualCard
        self.presenter.currentCardObservable.onNext(virtualCard)
        let payController = initController(fromStoryboard: "Pay", controllerName: "vCardController") as? VCardViewController
        payController?.presenter = self.presenter
//        payController?.viewDidLoadObserver.subscribe(onNext: {
//            _ = UpperViewRouter(embeddIn: (payController?.upperView)! , containerVC: payController!)
//        }).disposed(by: disposeBag)
        pushToDrawer(controller: payController!)
        
        self.centerNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    init(generateCard: Bool) {
        super.init()
        self.presenter.router = self
        let payController = initController(fromStoryboard: "Pay", controllerName: "vcnController") as? VCNViewController
        payController?.presenter = self.presenter
        payController?.viewDidLoadObserver.subscribe(onNext: {
            _ = UpperViewRouter(embeddIn: (payController?.upperView)! , containerVC: payController!)
        }).disposed(by: disposeBag)
        pushToDrawer(controller: payController!)
        
        self.centerNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    func closePayMer(onComplete: (()->Void)?){
        self.merPay?.navigationController?.popViewController(animated: true)
        onComplete?()
//        self.merPay?.dismiss(animated: true, completion: {
//            onComplete?()
//        })
    }
    
    func goToQrDetailsController() {
        self.qrDetailController = initController(fromStoryboard: "Pay", controllerName: "qrDetails") as! QrDetailsController
        self.qrDetailController?.presenter = self.presenter
        self.centerNav?.navigationItem.title = "Scan Details"
        self.push(into: centerNav!, childController: qrDetailController!)
    }
    
    func pushVCN(){
        self.vcnController = self.initController(fromStoryboard: "Pay", controllerName: "vcnController") as! VCNViewController
        self.vcnController!.presenter = self.presenter
        self.push(into: self.centerNav!, childController: self.vcnController!)
        self.centerNav?.navigationItem.title = "VCN"
        self.vcnController?.viewDidLoadObserver.subscribe(onNext: {
            UpperViewRouter(embeddIn: self.vcnController!.upperView , containerVC: self.vcnController!)
        }).disposed(by: disposeBag)
        
        
    }
    func goToCard(){
        self.vcardController = self.initController(fromStoryboard: "Pay", controllerName: "vCardController") as! VCardViewController
        self.vcardController!.presenter = self.presenter
        /*vcardController?.viewDidLoadObserver.subscribe(onNext: {
         _ = UpperViewRouter(embeddIn: (self.vcardController?.upperView)! , containerVC: self.vcardController!)
         }).disposed(by: disposeBag)*/
        self.push(into: self.centerNav!, childController: self.vcardController!)
        self.centerNav?.navigationItem.title = "Virtual Card"
        
    }
    func goBackToVCN(){
        self.centerNav?.popViewController(animated: true)
    }
    
    func embeddFeaturedMerView(into vc: UIViewController, container: UIView) {
        let fMerVC = initController(fromStoryboard: "Pay", controllerName: "merVC") as? FeaturedMerchantViewController
        fMerVC?.presenter = self.presenter
        self.embedd(into: vc, childController: fMerVC!, containerView: container)
    }
    
    func goToNotifications() {
        _ = NotificationRouter()
    }
    
    func openPinPage() {
        print("\n\nOpening Pin Page\n\n")
        let pinViewController = initController(fromStoryboard: "Pay", controllerName: "PayPinVC") as? PayPinViewController

        pinViewController?.onDone = { (pin) in
            self.presenter.getVCNListRequest(pin: pin)
        }
        pinViewController?.presenter = presenter
        addModally(controller: pinViewController!, transition: .crossDissolve, presentation: .overCurrentContext)
        print("\n\nOpened Pin Page\n\n")
    }
}
