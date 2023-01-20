//
//  HistoryPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class HistoryPresenter: Presenter {
    var router: HistoryRouter?
    var apiManger: HistoryApiManager?
    var disposeBag = DisposeBag()
    var historyArray = BehaviorSubject<[History]>(value: [])
    var allHistoryArray = BehaviorSubject<[History]>(value: [])
    var localManager: AuthLocalManager?
    var currentHistory = BehaviorSubject<History>(value: History())
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    var mobile: String?
    var number_Pages = Int()
    override init(){
        super.init()
        self.apiManger = HistoryApiManager()
        self.localManager = AuthLocalManager()
        if (self.localManager?.userExist)! {
            mobile = localManager?.user?._mobile
        }
    }
    
    func embeddHistoryTableView(into vc: UIViewController, container: UIView) {
        router?.embeddHistoryTableView(into: vc, container: container)
    }
    
    func cellTapped() {
        router?.goToDetailController()
    }
    
    func showExpoertView(){
        router?.showExpoertView()
    }
    
    func getAllHistory(page:Int) {
        router?.displayAlert(msg: "loading".localized)
        apiManger?.getAllHistory(mobile: mobile!, page: page).subscribe(onNext: { (response) in
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
                    try self.historyArray.onNext(self.historyArray.value() + response.histories)
                    try self.allHistoryArray.onNext(self.allHistoryArray.value() + response.histories)
                   
                } catch {
                    print(error)
                }
//                self.historyArray.onNext(response.histories)
                self.number_Pages = response.NUMPAGES
                
//                self.historyArray.onNext(response.histories)
//                self.allHistoryArray.onNext(response.histories)
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }

    func cancelTapped() {
        NavigationPresenter.currentModule = "Dashboard"
        router?.goToDashboard()
    }

    
    func displayVerifiy(vc: UIViewController) -> Observable<String> {
        return Observable.create({ (pin) -> Disposable in
            let popup=UIAlertController(title: "", message:"enterYourPin".localized , preferredStyle: UIAlertController.Style.alert)
            
            popup.addAction(UIAlertAction(title: "verify".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                pin.onNext((popup.textFields?.first?.text)!)
            }))
            
            popup.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default,handler: { (thing) in
                //pin.onNext("")
                self.cancelTapped()
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
    
    
    func getForSection(sec:Int,txns:[History])->[History]{
        var Htxn:[History]=[]
        switch sec {
        case 0:
            return txns;
        case 1:
            for txn in txns{
                guard txn.isRecieved == true else {
                    continue
                }
                Htxn.append(txn)
            }
            break
        case 2:
            for txn in txns{
                guard txn.isRecieved != true else {
                    continue
                }
                Htxn.append(txn)
            }
            break
        case 3:
            for txn in txns{
                guard txn.status == "NOT-PERFORMED-YET" || txn.status == "PENDING" || txn.status == "UNDER_PROCESSING" else {
                    continue
                }
                Htxn.append(txn)
            }
            break
        default:
            break
        }
        
        return Htxn;
        
    }

    @objc func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    @objc func notificationClicked() {
        NavigationPresenter.currentModule = "Notifications"
        goToNotifications()
    }
    
    @objc func logoCliked() {
        NavigationPresenter.currentModule = "Dashboard"
        goToDashboard()
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(PayPresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
            //            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
                        
                        numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                            notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
                        }).disposed(by: disposeBag)
                        
                        numOfUnreadNoti.onNext( Int(localManager?.user?._noOfUnreadNoti ?? "0") ?? 0 )
        }
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
         */
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(PayPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.imageView?.flipImage()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    func getNumOfUnreadNotification() {
        self.apiManger?.getNumOfUnreadNotification(mobile: (self.mobile ?? localManager?.user?._mobile)!).subscribe(onNext: { (response) in
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
}
