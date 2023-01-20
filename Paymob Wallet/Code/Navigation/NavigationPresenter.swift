//
//  AuthPresenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/15/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import DrawerController
import RxSwift
import UIKit


class NavigationPresenter: Presenter {
    
    var router: NavigationRouter?
    static var currentModule = ""
    var newModule: String!
    var apiManger: NotificationApiManager?
    var localManager: AuthLocalManager?
    var disposeBag = DisposeBag()
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    var mobile: String!
    var updatedBalance = BehaviorSubject<String>(value: "")
    var cellTitles: [String] = ["send".localized,
                                "homeCashOut".localized,
                                "homeCashIn".localized,
                                "homePay".localized]
    
    var historyArray = BehaviorSubject<[History]>(value: [])
//    var celImages: [UIImage] = [#imageLiteral(resourceName: "send"), #imageLiteral(resourceName: "bills"), #imageLiteral(resourceName: "topup"), #imageLiteral(resourceName: "qrcode"), #imageLiteral(resourceName: "load"), #imageLiteral(resourceName: "VCN")]
    
    
    var celImages: [UIImage] = [
        
        ImageProvider.image(named: "homescreen_send")!,
        ImageProvider.image(named: "homescreen_cash_out")!,
        ImageProvider.image(named: "homescreen_cash_in")!,
        ImageProvider.image(named: "homescreen_pay")!
    ]
    
    
    
    
    var auhtApiManager: AuthApiManager?
  
    //MARK: - Var for virtual cards
    var virtualCards: [VirtualCard] = []
    var virtualCardsObservable = BehaviorSubject<[VirtualCard]>(value: [])
    var currentCard:VirtualCard?
    var currentCardObservable = BehaviorSubject<VirtualCard>(value: VirtualCard())
    
    
    override init(){
        super.init()
        self.apiManger = NotificationApiManager()
        self.auhtApiManager = AuthApiManager()
        self.localManager = AuthLocalManager()
        //currentModule = "Dashboard"
        if (localManager?.userExist)! {
            mobile = localManager?.user?._mobile
            Util.debugMsg(mobile)
        }
    }
    
    
    
    //MARK: - POPUP Pin Code
    
    func loadCardsRequest(){
        self.router?.openPinPage(completion: { (pin) in
            self.getVCNListRequest(pin: pin)
        })
    }
    
    func getVCNListRequest(pin:String){
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManger?.getVCNList(pin: pin, mobile: self.userManager.user!._mobile!)
            .subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    
                    if response.txn == "1902" {
                        self.virtualCards = []
                        self.virtualCardsObservable.onNext(self.virtualCards)
                        self.router?.pushVCN()
                        return
                    }
                    
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    
                    self.virtualCards.append(contentsOf: self.formateCardsInfo(cards: response.vcns) )
                    self.virtualCardsObservable.onNext(self.virtualCards)
                
        

                    if self.virtualCards.isEmpty{
                        self.router?.pushVCN()
                    }else{
                        self.openCardPage()
                    }
                    
                   
                }
                
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.preDisposeBag)
    }
    
    
    func formateCardsInfo(cards:[VirtualCard]) -> [VirtualCard]{
        var formatedCards:[VirtualCard] = []
        for card in cards {
            let newCard = VirtualCard()
            newCard.number = card.number?.vCardFormate()
            newCard.validity = card.expireDay?.vCardValidFormate()
            newCard.amount  = card.amount
            newCard.cvv  = card.cvv
            newCard.expireDay = card.expireDay
            newCard.validityDate = card.validityDate
            newCard.isMultiUse = card.isMultiUse
            formatedCards.append(newCard)
        }
        
        return formatedCards
    }
    
    
    
    func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    func notificationClicked() {
        NavigationPresenter.currentModule = "Pay"
        self.router?.goToNotifications()
    }
    
    func sendClicked() {
        NavigationPresenter.currentModule = "p2p".localized
        self.router?.goToSend()
    }
    
    func payClicked() {
        NavigationPresenter.currentModule = "qrCode".localized
        self.router?.goToPay()
    }
    
    func loadClicked() {
//        NavigationPresenter.currentModule = NSLocalizedString("cashout", comment: "my wallet")
//        self.router?.goToCashout()
    }
    
    func cashoutClicked(){
        NavigationPresenter.currentModule = "cashout".localized
        self.router?.goToCashout()
    }
    
    func cashinClicked(){
        NavigationPresenter.currentModule = "cashin".localized
        self.router?.goToCashin()
    }
    
    func profileClicked() {
        NavigationPresenter.currentModule = "Pay"
        self.router?.goToProfile()
    }
    
    func webViewClicked() {
        NavigationPresenter.currentModule = "bills".localized
        self.router?.goToWebView()
    }
    
    func topUpClicked() {
        NavigationPresenter.currentModule = "topUp".localized
        self.router?.goToTopUp()
    }
    
    func vcnClicked() {
        NavigationPresenter.currentModule = "eCommere".localized
        self.router?.goToVCN()
    }
    
    func historyClicked(){
        NavigationPresenter.currentModule = "history".localized
        self.router?.goToHistory()
    }
    
    func openCardPage(){
        self.currentCard = self.virtualCards.first
        self.currentCardObservable.onNext(self.currentCard!)
        self.router!.goToCard(card: self.currentCard!)
    }
    
    
    func cellSelected() {
        
        Util.debugMsg(NavigationPresenter.currentModule)
        Util.debugMsg(newModule)
        
//        if NavigationPresenter.currentModule == newModule {
//            Router.drawerController?.closeDrawer(animated: true, completion: nil)
//            return
//        }
        
        switch newModule {
        case "dashboard".localized:
            router?.goToDashboard()
        //case NSLocalizedString("send", comment: "send"):
        case "p2p".localized:
            router?.goToSend()
        case "load".localized:
            router?.goToCashout()
        case "qrCode".localized:
            router?.goToPay()
            //router?.goToVCN()
            //router?.goToWebView()
        case "cashout".localized:
            router?.goToCashout()
            break
            //router?.goToCashout()
        case "map".localized:
            router?.goToMap()
        case "profile".localized:
            router?.goToProfile()
        case "notifications".localized:
            router?.goToNotifications()
        case "merchant".localized:
            router?.goToMerchants()
        case "history".localized:
            router?.goToHistory()
        case "contactUs".localized:
            router?.goToContactUs()
        case "settings".localized:
            router?.goToSettings()
        case "logout".localized:
            router?.goToLogout()
        case "bills".localized:
            webViewClicked()
        case "Service Info".localized:
            router?.goToServiceInfo()
        case "myWallet".localized:
//            router?.goToLoad()
            break
        case "topUp".localized:
            router?.goToTopUp()
        case "eCommere".localized:
            router?.goToVCN()
        default:
            break
        }
        Router.drawerController?.closeDrawer(animated: true, completion: nil)
        Util.debugMsg(NavigationPresenter.currentModule)
        NavigationPresenter.currentModule = newModule!
    }
    
    func getNumOfUnreadNotification() {
        self.apiManger?.getNumOfUnreadNotification(mobile: mobile).subscribe(onNext: { (response) in
            //self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            //self.router?.hideMsg {
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.localManager?.save(saveCall: { (user) in
                user._noOfUnreadNoti = "\(response.numberOfUnreadNoti)"
            })
            self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            UIApplication.shared.applicationIconBadgeNumber = response.numberOfUnreadNoti
            //}
            
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func editNavigationTitleView(vc: UIViewController) {
        let titleCustomView = TitleCustomView(frame: (vc.navigationController?.navigationBar.frame)!)
        
//        titleCustomView.backgroundColor = settings.primaryColor
        titleCustomView.backgroundColor = UIColor.white

        /*
        let imageView = UIImageView(image: UIImage(named: NSLocalizedString("navIcon", comment: "navicon")))
        imageView.contentMode = .scaleAspectFit
        titleCustomView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: titleCustomView.trailingAnchor).isActive = true
        //imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (vc.navigationController?.navigationBar.frame.height)!).isActive = true
        imageView.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        */
        vc.navigationItem.titleView = titleCustomView
        
    }
    
    func requestUpdateBalancePIN(){
        self.router?.openPinPage(completion: { (pin) in
            self.updateBalance(pin: pin)
        })
    }
    
    func updateBalance(pin: String){
        self.router?.displayAlert(msg: "loading".localized)
        Util.debugMsg(self.localManager?.user)
        guard self.localManager!.userExist else {
            //self.router?.goToMobileVerfication()
            return
        }
        self.auhtApiManager?.login(pin:pin, mobile: self.localManager!.user!._mobile!).subscribe(onNext:
            { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    // self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    self.localManager?.save(saveCall: { (user) in
                        user._balance = response.balance
                    })
                    
                    self.updatedBalance.onNext(response.balance)
                    //AppDelegate.inApp = true
                    // go to dashboard page
                    //self.router?.goToDashboard()
                    
                    //debug
                    Util.debugMsg(response.txn)
                    Util.debugMsg(response.balance)
                    Util.debugMsg(self.localManager?.user)
                    // })
                    
                }
                
        }, onError:
            { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
        })
            .disposed(by: disposeBag)
        
    }
    
    
    func displayVerifiy(vc: UIViewController) -> Observable<String> {
        return Observable.create({ (pin) -> Disposable in
            let popup=UIAlertController(title: "", message:"enterYourPin".localized , preferredStyle: UIAlertController.Style.alert)
            
            popup.addAction(UIAlertAction(title: "verify".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                pin.onNext((popup.textFields?.first?.text)!)
            }))
            
            popup.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                //pin.onNext("")
            }))
            popup.addTextField(configurationHandler: { (name) in
                name.placeholder="pin".localized
                name.isSecureTextEntry = true
                name.keyboardType=UIKeyboardType.numberPad
                name.textAlignment=NSTextAlignment.center
            })
            vc.present(popup, animated: true, completion: nil)
            return Disposables.create()
        })
    }

    func getAllHistory(page:Int) {
        router?.displayAlert(msg: "loading".localized)
        apiManger?.getAllHistory(mobile: mobile!).subscribe(onNext: { (response) in
            Util.debugMsg(response)
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.closeModal()
                        self.router?.goToDashboard()
                    })
                    return
                }
                do {
                    var upperBound = min(4, response.histories.count - 1)
                    try self.historyArray.onNext(Array(response.histories[...upperBound]))
                   
                } catch {
                    print(error)
                }
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func TransactionClicked(transaction: History){
        self.router?.goToTransactionDetail(transaction: transaction)
    }

}
