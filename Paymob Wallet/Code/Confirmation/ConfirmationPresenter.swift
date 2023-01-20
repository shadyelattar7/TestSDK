//
//  ConfirmationPresenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift
import UIKit


class ConfirmationPresenter:Presenter, UIPickerViewDelegate, UIPickerViewDataSource {
    

    
    
    var pickerView: UIPickerView?
    var alert: UIAlertController?
    
    var transaction:Transaction
    private var pin:AnyObserver<String>
    private var confirmApi = ConfirmApiManager()
    private var disposeBag = DisposeBag()
    private var user: User {
        let authManager = AuthLocalManager()
        authManager.userExist
        return authManager.user!
    }
    
    var aliases: [String] = ["Smart Wallet"]
    
    public var router:ConfirmationRouter?
    
    var title: BehaviorSubject<String>?
    var originalAmount: BehaviorSubject<String>?
    var fees: Observable<String>?
    var totalAmount: BehaviorSubject<String>?
    var toWhom: BehaviorSubject<String>?
    var name: BehaviorSubject<String>?
    var msg: BehaviorSubject<String>?
    var image: BehaviorSubject<UIImage>?
    
    
    init(pinObserver:AnyObserver<String>,transaction:Transaction) {
        self.transaction = transaction
        self.pin = pinObserver
        super.init()
        self.title = BehaviorSubject<String>(value: self.transaction.title)
        self.toWhom = BehaviorSubject<String>(value:self.transaction.toWhom!)
        self.name = BehaviorSubject<String>(value:self.transaction.name!)
        self.msg = BehaviorSubject<String>(value:self.transaction.msg!)

        self.originalAmount = BehaviorSubject<String>(value: self.transaction.amount! + " " + "egp".localized)
        
        self.totalAmount = BehaviorSubject<String>(value: "")
        if let image = ImageProvider.image(named: self.transaction.image) {
            self.image = BehaviorSubject<UIImage>(value: image)
        }else {
            self.image = BehaviorSubject<UIImage>(value: UIImage())
        }
        
        if let staticBillFees = transaction.staticBillFees {
            fees = Observable.create({ (observer) -> Disposable in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    observer.onNext(staticBillFees)
                    let feeeees = Double(staticBillFees) ?? 0
                    let amount = Double(transaction.amount ?? "0" ?? "0") ?? 0
                    
                    self.totalAmount?.onNext("egp".localized+" \(feeeees+amount) ")
                }
                return Disposables.create()
            })
        } else {
            // we send a request to calculate the fees
             fees = self.calculateFees()
        }
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
    }
    
    func swipedReciet(){
        self.router!.openPinPage()
    }
    
    func closeConfirmation(){
        self.router?.closeConfirmationPage()
    }
    
    func closePinPage(){
        
    }
    func confirmPin(pin:String){
        guard pin.count == 6 else {
            // error you can't put empty
                self.router?.sweetAlertFail(message: "Pin must be 6 digits only", afterMsg: {
                })
            return
        }
        self.router?.closePinPage(after:{
            self.pin.onNext(pin)
        })
    }
    private func calculateFees() -> Observable<String>{
        
        return Observable.create({ (feeObserver) -> Disposable in
            let mobileClean = self.transaction.toWhom?.getOnly(charSet: CharacterSet.decimalDigits)
            
            var amount = Double(self.transaction.amount!)
            if self.transaction.extraParameterName != nil{
                amount = (amount ?? 0.0) + (Double(self.transaction.extraParameterValue ?? "0.0") ?? 0.0)
                amount = amount?.rounded(toPlaces: 2)
            }
            
            
            
            self.confirmApi.getFees(type: self.transaction.type!, mobile: self.user._mobile!, toMobile: mobileClean, amount: String(amount ?? 0.0), isMultiUseVCN: self.transaction.isMultiUseVCN)
                .subscribe(onNext: { (resopnse) in
                    
                    guard resopnse.fees != nil else {
                        feeObserver.onNext("0.0")
                        return
                    }
                    
                    
                    feeObserver.onNext("\(resopnse.fees!)")
                    var dAmount = Util.convertArDigitToEn(digit: self.transaction.amount!)
                    if self.transaction.type == "VCN" {
                        dAmount = 0.0
                    }
                    
                    self.totalAmount?.onNext(" \(resopnse.fees! + (amount ?? 0.0))" + "egp".localized)
                    
                    if let alias1 = resopnse.bankAlias1 {
                        if alias1.isEmpty {
                            
                        } else {
                            self.aliases.append(alias1)
                        }
                    }
                    
                    if let alias2 = resopnse.bankAlias2 {
                        if alias2.isEmpty {
                            
                        } else {
                            self.aliases.append(alias2)
                        }
                    }
                    
                    self.pickerView?.reloadAllComponents()
                    
                }, onError: { (error) in
                    // some error handleing
                    feeObserver.onNext("")
                    self.router?.hideMsg {
                        self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                        })
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
        // get the fees and display them
        
    
    }
    
    func showAliases() -> UIAlertController{
        alert = UIAlertController(title: "Choose Payment Method", message: "", preferredStyle: .alert)
        alert?.addTextField { (textField) in
            textField.placeholder = "Wallet"
            textField.inputView = self.pickerView
        }
        
        let action = UIAlertAction(title: "Done", style: .default) { (_) in
            self.swipedReciet()
        }
        alert?.addAction(action)
        
        return alert!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alert?.textFields?.first?.text = aliases[row]
        if row == 0 {
            
        } else {
            Presenter.bankAlis = aliases[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Pay with: "+aliases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aliases.count
    }
    
    func showAlertToSaveBill() {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        
        
        
        let alert = UIAlertController(title: "", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (_) in
            topWindow.isHidden = true
            self.swipedReciet()
        }
        let button = UIButton(frame: CGRect(x: 70, y: 0, width: 100, height: 50))

        button.setTitle("Save bill", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(ImageProvider.image(named: "unchecked"), for: .normal)
        button.addTarget(self, action: #selector(checkBoxAction), for: .touchUpInside)
        
        alert.addAction(action)
        alert.view.addSubview(button)
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true)
    }
    
    @objc func checkBoxAction(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            sender.setImage(ImageProvider.image(named: "unchecked"), for: .normal)
        }else {
            sender.isSelected = true
            sender.setImage(ImageProvider.image(named: "checked"), for: .normal)
        }
    }
    
    @objc func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    func notificationClicked() {
        goToNotifications()
    }
}
