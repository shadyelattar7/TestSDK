//
//  PayPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import QRCodeReader


enum blulkState: CustomStringConvertible {
    case getFav
    case inquiry
    case pay
    case key
    
    var description: String {
        switch self {
        case .getFav:
            return "getFav"
        case .inquiry:
            return "inquiry"
        case .pay:
            return "pay"
        case .key:
            return "BulkInquiryPaymentKey"
            
        }
    }
}

enum currentPage {
    case qrCode
    case vcn
    case webView
}

class PayPresenter: Presenter, MutliUseVCNDeletionDelegate {
    var router: PayRouter?
    var apiManager:PayApiManager?
    var cardsManager:LocalVirtualCardManager = LocalVirtualCardManager()
    let authManager = AuthLocalManager()
    var trans = Transaction()
    var merCode = ""
    var merCodeObserver = BehaviorSubject<String>(value:"")
    var merNameObserver = BehaviorSubject<String>(value:"")
    var featMerCodeObserver = BehaviorSubject<String>(value: "")
    var merAmountObserver = BehaviorSubject<String>(value:"")
    var merBillRefObserver = BehaviorSubject<String>(value:"")
    
    var favBills = BehaviorSubject<[FavBill]>(value: [])
    var favBillsArray: [FavBill]?
    
    var merObject:Merchant?
    var merObjectObserver: BehaviorSubject<Merchant>?
    var currentCard:VirtualCard?
    var virtualCards: [VirtualCard] = []
    
    var virtualCardsObservable = BehaviorSubject<[VirtualCard]>(value: [])
    var currentCardObservable = BehaviorSubject<VirtualCard>(value: VirtualCard())
    var featMerchants = BehaviorSubject<[FeatMerchant]>(value: [])
    var inquirySuccess = BehaviorSubject<Bool>(value: false)
    var paymentSuccess = BehaviorSubject<Bool>(value: false)
    var cancelSuccess = BehaviorSubject<Bool>(value: false)
    var inquiryPayFaliure = BehaviorSubject<Bool>(value: false)
    var currentPage = BehaviorSubject<currentPage>(value: .qrCode)
    
    
    var vcnTypes: [VCNType]?
    var vcnTypesSuccess = BehaviorSubject<Bool>(value: false)
    var currentVCNType: String? = ""
    
    var adImage: String?
    var adUrl: String?
    
    var qrDataDic: [String: String]?
    var qrReDataArr: [String]?
    
    var qrDataKeys: [String]?
    var qrDataValues: [String]?
    
    var qrUpdatedDataDic: [String: String] = [:]
    var qrFinalDataDic: [String: String] = [:]
    
    var qrFees: String?
    var qrFeesPerc: String?
    var qrTip: String?
    var qrFinalAmount: String?
    var qrMerchantId: String?
    var qrExtraParameterName: String? = nil
    var qrExtraParameterValue: String? = nil
    var isQrDataEntered: [Bool]?
    var keyboardType: [UIKeyboardType]?
    
    var isQrDataComplete: Bool? = false
    var cardToBeDeleted: VirtualCard?
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    
    
    override init(){
        super.init()
        let card = VirtualCard()
        card.number = "Generate Card"
        virtualCards.append(card)
        
//        virtualCards.append(contentsOf:self.formateCardsInfo(cards: cardsManager.cards))
        virtualCardsObservable.onNext(self.virtualCards)
        
        apiManager = PayApiManager()
        
        qrDataKeys = []
        qrDataValues = []
        isQrDataEntered = []
        keyboardType = []
    }
    
    func loadCardsRequest(){
   //        self.getVCNListRequest(pin: pin)
        self.router?.openPinPage()
       }
    
    func getVCNListRequest(pin:String){
        self.router?.displayAlert(msg: "loading".localized)
            self.apiManager?.getVCNList(pin: pin, mobile: self.userManager.user!._mobile!)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        
                        if response.txn == "1902" {
                            self.virtualCards = []
                            self.virtualCardsObservable.onNext(self.virtualCards)
                            return
                        }
                        
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        
                        self.virtualCards.append(contentsOf: self.formateCardsInfo(cards: response.vcns) )
                        self.virtualCardsObservable.onNext(self.virtualCards)
                        
                    }
                    
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }


    
    func deleteAllCards(){
        
        router?.sweetAlertWarningWithTwoButton(message: "youWantToDeleteAll".localized, afterMsg: { (value) in
            if value {
                self.cardsManager.deleteAllCards()
                self.currentCard = nil
//                self.virtualCards = self.virtualCards.filter({$0.isMultiUse || $0.number == "Generate Card"})
                self.virtualCards = []
                self.virtualCardsObservable.onNext(self.virtualCards)
                
            } else {
                
            }
        })
    }
    
    func deleteCard(card: VirtualCard, from view: UIViewController? = nil) {
        if card.isMultiUse {
            self.router?.sweetAlertWarningWithTwoButton(message: "This Is Multiple Usage Card \n Are you Sure You Want To Delete It?", afterMsg: { (isOk) in
                if isOk {
                    guard let view = view else {
                        self.router?.sweetAlertFail(message: "Ops Some thing went Wrong", afterMsg: {})
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.cardToBeDeleted = card
                        _ = MutliUseVCNDeletionWireframe(from: view, isPush: false, cardNumber: card.number!, delegate: self)
                    }
                }
            })
        } else {
            self.cardsManager.delete(vCard: card)
            self.currentCard = nil
            self.virtualCards.removeLast(self.virtualCards.count - 1)
            virtualCards.append(contentsOf:self.formateCardsInfo(cards: cardsManager.cards))
            self.virtualCardsObservable.onNext(self.virtualCards)
        }
        
    }
    
    
    func completionDelegate(pin: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.router?.displayAlert(msg: "loading".localized)
            if self.userManager.userExist {
                if let mobile = self.userManager.user?._mobile {
                    self.apiManager?.deleteMultiUseVCN(pin: pin, cardNumber: self.cardToBeDeleted!.number!.replacingOccurrences(of: " ", with: ""), mobileNumber: mobile)
                        .subscribe(onNext: { (response) in
                            self.router?.hideMsg(afterMsg: {
                                if response.txn == "200" {
                                    self.cardToBeDeleted?.isMultiUse = false
                                    self.deleteCard(card: self.cardToBeDeleted!)
                                    self.router?.sweetAlertSuccess(message: "Card Deleted Succesfully", afterMsg: {})
                                } else {
                                    self.router?.sweetAlertFail(message: response.MESSAGE ?? "Error In Deletion No Message" , afterMsg: {})
                                }
                            })
                            
                        }, onError: { (error) in
                            self.router?.hideMsg(afterMsg: {
                                self.router?.sweetAlertFail(message: error.localizedDescription, afterMsg: {})
                            })
                            
                        }).disposed(by: self.preDisposeBag)
                } else {
                    self.router?.sweetAlertFail(message: "User mobile Number is Not Exists", afterMsg: {})
                }
            } else {
                self.router?.sweetAlertFail(message: "User Is Not Exists", afterMsg: {})
            }
        }
        
    }
    
    
    
    
    func openCardPage(at:IndexPath){
        if at.row == 0 {
            self.router?.pushVCN()
            return
        }
        self.currentCard = self.virtualCards[at.row]
        self.currentCardObservable.onNext(self.currentCard!)
        self.router!.goToCard()
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
    
    func scanQRClicked(vc: UIViewController){
        // launch the qr library
        if checkScanPermissions(viewController: vc) {
            
        }
    }
    
    func findTextFromQR(){
        // send text to server
    }
    
    func closeMechantPay(){
        self.router?.closePayMer(onComplete: nil)
    }
    
    @objc func closeMechantPaySelector(){
        self.router?.closePayMer(onComplete: nil)
    }
    
    @objc func goToPreviousVC(){
        self.router?.centerNav?.popViewController(animated: true)
    }

    
    
    func pay(amount:String?, merchantNumber:String?, isFromNewQR: Bool = false, extraParameterName: String? = nil, extraParameterValue: String? = nil){
        guard amount != nil &&  merchantNumber != nil else{
            self.router?.sweetAlertFail(message: "You should enter the amount and the Merchant no.", afterMsg: {
            })
            return
        }
        
        merCodeObserver.subscribe(onNext: { (code) in
            self.merCode = code
        }).disposed(by: preDisposeBag)
        
        if (!isFromNewQR){
            self.merCode = merchantNumber!
            merCodeObserver.onNext(merchantNumber!)
        }
        
        trans.amount = amount
        trans.title = "pay".localized
        trans.name = self.qrUpdatedDataDic["Merchant Name"] ?? ""
        trans.extraParameterName = extraParameterName
        trans.extraParameterValue = extraParameterValue
        if self.merCode != "" {
            if isFromNewQR {
                trans.toWhom = self.qrMerchantId
            } else {
                trans.toWhom = self.merCode
            }
        }else{
            trans.toWhom = self.merObject?._merchantCode
            self.merCode = self.merObject!._merchantCode!
        }
        
        
        
        trans.type = "P2M"
        
        if isFromNewQR {
            self.sendPayRequest(amount: amount, orderNumber: "", merchantCode: self.qrMerchantId!)
        } else {
//            self.router?.closePayMer(onComplete: {
                self.sendPayRequest(amount: amount, orderNumber: "", merchantCode: self.merCode)
//            })
        }
    }
    
    func showFeedBack(service:Bool,TXNID:String){
        let rate =  authManager.user?._rating ?? true
        if(rate == true && service == true){
            if #available(iOS 13.0, *) {
                self.router?.showSetRateView(TXNID: TXNID)
            } else {
                // Fallback on earlier versions
            }
        }
        else{
            self.router?.closeModal()
            self.router?.goToDashboard()
        }
    }
    func sendPayRequest(amount:String?,orderNumber:String?, merchantCode: String) {
        self.confirm(transaction: self.trans).subscribe(onNext: { (pin) in
            self.merCodeObserver.onNext(merchantCode)
            self.router?.displayAlert(msg: "loading".localized)
            
            self.apiManager?.merchantPayf(pin: pin, myMobile: self.userManager.user!._mobile!, amount: amount!, merchOrder: orderNumber!, merchNo: merchantCode, bankAlias: Presenter.bankAlis, additionalData: self.qrFinalDataDic)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
//                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
//                            })
                            if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                                presentingController.transactionFinished(response: response)
                            }
                            return
                        }
                        
                        if self.userManager.userExist {
                            self.userManager.save(saveCall: { (user) in
//                                user._balance = response.balance
                            })
                        }
                        
                        if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                            presentingController.transactionFinished(response: response)
                        }
                        
//                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
                            self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
//                        })
                        
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
    }
    
    func nextClicked(){
        merCodeObserver = BehaviorSubject<String>(value:"")
        merAmountObserver = BehaviorSubject<String>(value:"")
        merBillRefObserver = BehaviorSubject<String>(value:"")
        /*guard !merCode!.isEmpty else{
            self.router?.sweetAlertFail(message: "Brand Code is empty", afterMsg: {
            })
            return
        }
        
        self.merCode = merCode!
        merCodeObserver.onNext(merCode!)
         */
        self.router?.openPayMer()
        
    }
    
    func successifullScan(merCode: String?, amount: String?, billRef: String?) {
        guard !merCode!.isEmpty else{
            self.router?.sweetAlertFail(message: "Brand Code is empty", afterMsg: {
            })
            return
        }
        merCodeObserver.onNext(merCode!)
        merAmountObserver.onNext(amount!)
        merBillRefObserver.onNext(billRef!)
        self.router?.openPayMer()
    }
    
    func newQrSuccessifullScan(merId: String?, merName: String? = "") {
        guard !merId!.isEmpty else{
            self.router?.sweetAlertFail(message: "Brand Code is empty", afterMsg: {
            })
            return
        }
        merCodeObserver.onNext(merId!)
        merNameObserver.onNext(merName!)
        //self.router?.openPayMer()
        isQrDataEntered = []
        keyboardType = []
        for (key, value) in qrDataDic! {
            if value == "***" {
                self.qrDataKeys?.insert(key, at: 0)
                self.qrDataValues?.insert(value, at: 0)
                isQrDataEntered?.insert(true, at: 0)
            } else {
                self.qrDataKeys?.append(key)
                self.qrDataValues?.append(value)
                isQrDataEntered?.append(false)
            }
            
            if key == "Bill number" || key == "Purpose" {
                keyboardType?.append(.default)
            } else {
                keyboardType?.insert(.decimalPad, at: 0)
            }
        }
        self.router?.goToQrDetailsController()
    }
    
    func qrUpdatedData() {
        Util.debugMsg(self.qrDataKeys)
        qrUpdatedDataDic = [:]
        var i = 0
        for key in self.qrDataKeys! {
            qrUpdatedDataDic.updateValue((qrDataValues?[i])!, forKey: key)
            i = i+1
        }
        Util.debugMsg(self.qrUpdatedDataDic)
    }
    
    func generateQRFinalDicAndAmount () {
        for key in self.qrReDataArr! {
            if self.qrUpdatedDataDic.keys.contains(key) {
                qrFinalDataDic.updateValue(qrUpdatedDataDic[key]!, forKey: key)
            }
        }
        
        var finalFees = 0.0
        qrExtraParameterName = nil
        qrExtraParameterValue = nil
        self.qrMerchantId = self.qrUpdatedDataDic["Merchant ID"]
        self.qrFees = self.qrUpdatedDataDic["Convenience Fees"]
        self.qrFeesPerc = self.qrUpdatedDataDic["Convenience Fees (%)"]
        let enteredAmount = self.qrUpdatedDataDic["Amount"]
        self.qrTip = self.qrUpdatedDataDic["Tip"]
        
        if let tips = qrTip {
            if let dTip = Double(tips){
                finalFees = dTip
                qrExtraParameterName = "tips".localized
                qrExtraParameterValue = String(finalFees)
            }
        } else if let convFees = qrFees {
            if let dFees = Double(convFees) {
                finalFees = dFees
                qrExtraParameterName = "convenienceFees".localized
                qrExtraParameterValue = String(finalFees)
            }
        } else if let conFeesPerc = qrFeesPerc, let amo = enteredAmount {
            if let dfee = Double(conFeesPerc), let dAmo = Double(amo) {
                let cfee = (dfee/100) * dAmo
                finalFees = cfee + dAmo
                qrExtraParameterName = "convenienceFees".localized
                qrExtraParameterValue = String(finalFees)
            }
        }
        
        print("\n\nFees \(finalFees)")
        print("Name: \(qrExtraParameterName)")
        print("Value: \(qrExtraParameterValue)\n\n")

        
        qrFinalAmount = "0"
        if let finalAmo = Double(enteredAmount ?? "0") {
            let final = finalAmo// + finalFees
            qrFinalAmount = String(final)//.rounded(toPlaces: 2))
        }
        
    }
    
    func splitAmountAndFees() -> Bool{
        return true
    }
    
    func webView(with webJSON:String){
        let webView = Mapper<WebViewTransaction>().map(JSONString: webJSON)
        
        Util.debugMsg(webView)
        switch webView!.msgType! {
        case "processBillInquiry":
            self.inquireBill(webViewTransaction: webView!)
            break
        case "processBill":
            self.payBill(webViewTransaction: webView!)
            break
        case "processMobileTopUp":
            self.chargeMobile(webViewTransaction: webView!)
            break
        default:
            return
        }
        
    }
    
    func inquireBill(webViewTransaction:WebViewTransaction){
        self.trans = Transaction()
        //self.trans.toWhom = webViewTransaction.billReference
        self.trans.toWhom = webViewTransaction.merchantName
        
        self.trans.amount =  webViewTransaction.merchantId
        //self.trans.amount =  "0"
        self.trans.title = "billInqiure".localized
        self.trans.type = "BILLPAYMENT"
        self.confirm(transaction: self.trans).subscribe(onNext: { (pin) in
            
            self.router?.displayAlert(msg: "loading".localized)
            
            self.apiManager?.inquireBill(pin: pin, mobile: self.userManager.user!._mobile!, billNo: webViewTransaction.billReference!, billerCode: webViewTransaction.merchantId!)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        // good let's show a messsage then goto the dashbord
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        //self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        Util.debugMsg(response.billerCode)
                        //NavigationPresenter.currentModule = "Dashboard"
                        self.router?.closeModal()
                        self.showAlertToPay(response: response)
                        
                        //self.router?.goToNotifications()
                        //self.router?.goToDashboard()
                        
                        //})
                        
                    }
                    
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
    }
    
    func payBill(webViewTransaction:WebViewTransaction){
        self.trans = Transaction()
        self.trans.toWhom = webViewTransaction.merchantName!
        self.trans.amount = "\(webViewTransaction.amount!)"
        self.trans.title = "pay".localized
        self.trans.type = "BILLPAYMENT"
        self.confirm(transaction: self.trans).subscribe(onNext: { (pin) in
            
            self.router?.displayAlert(msg: "loading".localized)
            
            self.apiManager?.payBill(pin: pin, amount: "\(webViewTransaction.amount!)", mobile: self.userManager.user!._mobile!, billNo: webViewTransaction.billReference!, merchantCode: webViewTransaction.merchantId!, billName: webViewTransaction.merchantName!)
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        // good let's show a messsage then goto the dashbord
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
                            self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
                        })
                        
                    }
                    
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
    }
    
    func chargeMobile(webViewTransaction:WebViewTransaction){
        self.trans = Transaction()
        self.trans.toWhom = webViewTransaction.merchantName!
        self.trans.amount = "\(webViewTransaction.amount!)"
        self.trans.title = "pTopUp".localized
        self.trans.type = "RECHARGE"
        self.confirm(transaction: self.trans).subscribe(onNext: { (pin) in
            
            self.router?.displayAlert(msg: "loading".localized)
            
            self.apiManager?.rechargeMobile(pin: pin, myMobile: self.userManager.user!._mobile!, toMobile: webViewTransaction.receipientMobile!, merchCode: webViewTransaction.merchantId!, amount: "\(webViewTransaction.amount!)")
                .subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        // good let's show a messsage then goto the dashbord
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            NavigationPresenter.currentModule = "Dashboard"
                            self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
                        })
                        
                    }
                    
                }, onError: { (error) in
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
    }
    
    /*func createVirtualCard(amount:String){
        
        self.trans = Transaction()
        self.trans.toWhom = ""
        self.trans.amount = amount
        self.trans.title = NSLocalizedString("eCommere", comment: "vcn")
        self.trans.type = "VCN"
        self.trans.isMultiUseVCN = true
        self.confirm(transaction: self.trans).subscribe(onNext: { (pin) in
            
            self.router?.displayAlert(msg: NSLocalizedString("loading", comment: "loading"))
            
            self.apiManager?.createVCN(pin: pin, amount: amount, mobile: self.userManager.user!._mobile!, type: self.currentVCNType!)
                .subscribe(onNext: { (response) in
                    response.isMultiUse = true
                    self.router?.hideMsg {
                        // good let's show a messsage then goto the dashbord
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg!, afterMsg: {
                            })
                            return
                        }
                        self.cardsManager.save(vCard: response)
                        // assign the amount
                        try! response.realm?.write {
                            response.isMultiUse = true
                            response.amount = amount
                        }
                        
                        self.virtualCards.append(contentsOf:self.formateCardsInfo(cards: [response]))
                        // push it to the observer
                        self.virtualCardsObservable.onNext(self.virtualCards)
                        
                        if self.userManager.userExist {
                            self.userManager.save(saveCall: { (user) in
                                user._balance = response.balance
                            })
                        }
                        
                        self.router?.sweetAlertSuccess(message: response.msg!, afterMsg: {
                            
                            self.router?.closeModal()
                            self.router?.goBackToVCN()
                        })
                        
                        //self.router?.p
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
        }).disposed(by: self.preDisposeBag)
        
    }*/
    
    func createVirtualCard(amount:String){
        trans = Transaction()
        trans.toWhom = ""
        trans.amount = amount
        trans.isMultiUseVCN = true
        trans.title = "vcn".localized
        trans.type = "VCN"
        
        confirm(transaction: self.trans)
            .subscribe(onNext: { (pin) in
                self.createNewVCNRequest(pin: pin, amount: amount)
            }).disposed(by: preDisposeBag)
    }
        
        
    private func createNewVCNRequest(pin:String, amount:String){
        self.router?.displayAlert(msg: "loading".localized)
        self.apiManager?.createVCN(pin: pin, amount: amount, mobile: self.userManager.user!._mobile!, type: self.currentVCNType!)
            .subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
//                        self.router?.sweetAlertFail(message: response.msg!, afterMsg: {
//                        })
                        if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                            presentingController.transactionFinished(response: response)
                        }
                        return
                    }
                    try! response.realm?.write {
                        response.amount = amount
                    }
                    response.amount = amount
                    self.virtualCards.append(contentsOf:self.formateCardsInfo(cards: [response]))
                    self.virtualCardsObservable.onNext(self.virtualCards)
                    if self.userManager.userExist {
                        self.userManager.save(saveCall: { (user) in
                            user._balance = response.balance
                        })
                    }
                    
                    if let presentingController = self.router!.top(vc: self.router!.window.rootViewController!) as? ConfirmationViewController{
                        presentingController.transactionFinished(response: response)
                    }
                    
//                    self.router?.sweetAlertSuccess(message: response.msg!, afterMsg: {
//                        self.router?.closeModal()
//                        self.router?.goBackToVCN()
//                    })
//                    self.router?.goBackToVCN()
                }
                
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: self.preDisposeBag)
    }


    
    func checkScanPermissions(viewController: UIViewController) -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController?
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert?.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            case -11814:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            default:
                alert = nil
            }
            
            guard let vc = alert else { return false }
            
            viewController.present(vc, animated: true, completion: nil)
            
            return false
        }
    }
    
    func qrRequestAfterScanning(scanResult: String) {
        merCodeObserver = BehaviorSubject<String>(value:"")
        merNameObserver = BehaviorSubject<String>(value:"")
        merAmountObserver = BehaviorSubject<String>(value:"")
        merBillRefObserver = BehaviorSubject<String>(value:"")
        self.router?.displayAlert(msg: "loading".localized)
        apiManager?.parseQR(qrCode: scanResult).subscribe(onNext: { (response) in
            Util.debugMsg(response)
            self.router?.hideMsg {
                // good let's show a messsage then goto the dashbord
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                if let _ = response.qrCRC {
                    self.qrDataDic = [:]
                    self.qrReDataArr = []
                    self.qrDataValues = []
                    self.qrDataKeys = []
                    
                    self.qrDataDic = response.qrDataDic
                    self.qrReDataArr = response.qrReDataArr
                    
                    self.qrFees = response.qrFees
                    self.qrFeesPerc = response.qrFeesPerc
                    self.qrTip = response.qrTip
                    
                    self.newQrSuccessifullScan(merId: response.qrMerCode)
                    
                    
                } else {
                    
                    self.successifullScan(merCode: response.qrMerCode, amount: response.qrAmount, billRef: response.qrBillRefNumber)
                }
            }
            
        }, onError: { (error) in
            // usally an internet error
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: self.preDisposeBag)
    }
    func embeddFMerVC(into vc: UIViewController, container: UIView) {
        router?.embeddFeaturedMerView(into: vc, container: container)
    }
    
    func getFeatMerchants() {
        apiManager?.getFMer().subscribe(onNext: { (response) in
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.featMerchants.onNext(response.featMerchants)
        }, onError: { (error) in
            // usally an internet error
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: self.preDisposeBag)
    }
    
    /// get vcn types
    
    func getVCNTypes() {
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                apiManager?.getVCNTypes(mobile: mobile).subscribe(onNext: { (response) in
                    guard response.txn == "200" else {
                        self.vcnTypesSuccess.onNext(false)
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    self.vcnTypes = response.vcnTypes
                    self.vcnTypesSuccess.onNext(true)
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
                
            }
        }
    }
    
    // get fav bills
    
    func getFavBills() {
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                self.router?.displayAlert(msg: "loading".localized)
                apiManager?.getFavBills(mobile: mobile).subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                                self.inquiryPayFaliure.onNext(true)
                            })
                            return
                        }
                        
                        self.cancelSuccess.onNext(true)
                        if let favBills = response.favBills {
                            self.favBills.onNext(favBills)
                            self.favBillsArray = favBills
                        }
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    // get ad image
    func getAdImage() {
        apiManager?.getAdImage().subscribe(onNext: { (response) in
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            
            self.adImage = response.adImage
            self.adUrl = response.adUrl
            
        }, onError: { (error) in
            // usally an internet error
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: self.preDisposeBag)
        
    }
    
    func sendInqBills(selectedBills: [[String: Any]]) {
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                self.router?.displayAlert(msg: "loading".localized)
                apiManager?.sendInqBills(mobile: mobile, selectedBills: selectedBills).subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        
                        self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                            UserDefaults.standard.set(blulkState.inquiry.description, forKey: blulkState.key.description)
                            //self.inquirySuccess.onNext(true)
                            //self.getBillsStatus(action: "INQ")
                        })
                    }
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    func sendBulkPayBills(selectedBills: [[String: Any]]){
        let trans = Transaction()
        var amount = 0
        var fee = 0
        if let bills = self.favBillsArray {
            for bill in bills {
                if let billAmount = bill.amount, let billFee = bill.fee {
                    if let intAmount = Int(billAmount), let intFee = Int(billFee) {
                        amount += intAmount
                        fee += intFee
                    }
                }
            }
        }
        
        
        trans.amount = String(amount+fee)
        trans.type = "BILLPAYMENT" //TODO:: hide in a constant
        trans.toWhom = ""
        trans.title = "payBulkBill".localized
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                self.confirm(transaction: trans).subscribe(onNext: { (pin) in
                    self.router?.displayAlert(msg: "loading".localized)
                    self.apiManager?.sendPayBills(mobile: mobile, selectedBills: selectedBills, pin: pin).subscribe(onNext: { (response) in
                        self.router?.hideMsg {
                            guard response.txn == "200" else {
                                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                                })
                                return
                            }
                            
                            self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                                UserDefaults.standard.set(blulkState.pay.description, forKey: blulkState.key.description)
                                self.router?.closeModal()
                                //self.favBillsArray = []
                                //self.paymentSuccess.onNext(true)
                            })
                        }
                    }, onError: { (error) in
                        // usally an internet error
                        self.router?.hideMsg {
                            self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                            })
                        }
                    }).disposed(by: self.preDisposeBag)
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    
    func getBillsStatus(action: String) {
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                self.router?.displayAlert(msg: "loading".localized)
                apiManager?.getBillsStatus(mobile: mobile).subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                                self.inquiryPayFaliure.onNext(true)
                            })
                            return
                        }
                        
                        if action == "PAY" {
                            self.paymentSuccess.onNext(true)
                        } else {
                            //self.favBillsArray = []
                            self.inquirySuccess.onNext(true)
                        }
                        
                        if let favBills = response.favBills {
                            self.favBills.onNext(favBills)
                            self.favBillsArray = favBills
                        }
                        
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    func cancelBulkInquiry() {
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                self.router?.displayAlert(msg: "loading".localized)
                apiManager?.cancelBulkInquiry(mobile: mobile).subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        self.cancelSuccess.onNext(true)
                        self.getFavBills()
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    func deleteFavBill(bill: FavBill) {
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                self.router?.displayAlert(msg: "loading".localized)
                apiManager?.deleteFavBill(mobile: mobile, bill: bill).subscribe(onNext: { (response) in
                    self.router?.hideMsg {
                        guard response.txn == "200" else {
                            self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                            })
                            return
                        }
                        //self.cancelSuccess.onNext(true)
                        self.getFavBills()
                    }
                    
                }, onError: { (error) in
                    // usally an internet error
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                }).disposed(by: self.preDisposeBag)
            }
        }
    }
    
    /// new bill payment experience
    
    func billPaymentAcceptClicked(response: Response){
        let trans = Transaction()
        trans.amount = response.amount
        trans.type = "BILLPAYMENT" //TODO:: hide in a constant
        trans.toWhom = response.billerCode
        trans.title = "pay".localized
        
        if self.userManager.userExist {
            if  let mobile = self.userManager.user?._mobile {
                
                self.confirm(transaction: trans).subscribe(onNext: { (pin) in
                    self.router?.displayAlert(msg: "loading".localized)
                    self.apiManager?.payBill(pin: pin, amount: response.amount, mobile: mobile, billNo: response.billRefNum, merchantCode: response.billerCode, billName: response.billerName)
                        .subscribe(onNext: { (response) in
                            self.router?.hideMsg {
                                guard response.txn == "200" else {
                                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                                    })
                                    return
                                }
                                
                                if self.userManager.userExist {
                                    self.userManager.save(saveCall: { (user) in
                                        user._balance = response.balance
                                    })
                                }
                                
                                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                                    NavigationPresenter.currentModule = "Dashboard"
                                    self.showFeedBack(service: response.SERVICE_RATING_ENABLED,TXNID:response.TXNID)
                                })
                                
                            }
                        }, onError: { (error) in
                            self.router?.hideMsg {
                                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                                })
                            }
                        }).disposed(by: self.preDisposeBag)
                })
                    .disposed(by: self.preDisposeBag)
            }
        }
    }
    
    func showAlertToPay(response: Response) {
//        self.router?.centerNav?.pushViewController(UIViewController(), animated: true)
        
//        let topWindow = UIWindow(frame: UIScreen.main.bounds)
//        topWindow.rootViewController = UIViewController()
//        topWindow.windowLevel = UIWindow.Level.alert + 10
        
        
        let alert = UIAlertController(title: "Pay Bill", message: response.msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Pay", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//            topWindow.isHidden = true
            self.billPaymentAcceptClicked(response: response)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
//            topWindow.isHidden = true
        }))
//        topWindow.makeKeyAndVisible()
//        topWindow.rootViewController?.present(alert, animated: true)
        
        self.router?.centerNav?.viewControllers.last?.present(alert, animated: true)
    }
    
    func showAlertToCancel() {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        
        let alert = UIAlertController(title: "Cancel", message: "Are You sure you want to cancel the Process?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            topWindow.isHidden = true
            UserDefaults.standard.set(blulkState.getFav.description, forKey: blulkState.key.description)
            self.getFavBills()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            topWindow.isHidden = true
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true)
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
            }).disposed(by: preDisposeBag)
            
            numOfUnreadNoti.onNext( Int(userManager.user?._noOfUnreadNoti ?? "0") ?? 0 )
        }
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
        */
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if ("\(vc.classForCoder)" == "PayViewController"
            || "\(vc.classForCoder)" == "VCardViewController"
            || "\(vc.classForCoder)" == "VCNViewController"){
            backBtn.addTarget(self, action: #selector(PayPresenter.logoCliked), for: .touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(PayPresenter.goToPreviousVC), for: .touchUpInside)
        }
//        backBtn.addTarget(self, action: #selector(PayPresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.flipImage()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    
    func getNumOfUnreadNotification() {
        self.apiManager?.getNumOfUnreadNotification(mobile: (userManager.user?._mobile)!).subscribe(onNext: { (response) in
            //self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            //self.router?.hideMsg {
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.authManager.save(saveCall: { (user) in
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
        }).disposed(by: preDisposeBag)
    }
}
