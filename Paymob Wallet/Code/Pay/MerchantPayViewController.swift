//
//  MerchantPayViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/17/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MerchantPayViewController: PayMobViewController {
    var presenter:PayPresenter?
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var paymentInfoTitle: UILabel!
    @IBOutlet weak var paymentInfoSubTitle: UILabel!
    
    @IBOutlet weak var merchantNoField: UITextField!
    @IBOutlet weak var merchantNoLabel: UILabel!
    
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var amountFeild: UITextField!
    @IBOutlet weak var amountCurrencyLabel: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        presenter?.addBarButtons(vc: self)
//        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        cancelBtn.centerTextAndImage(spacing: 10)
        payBtn.disableBtn()
//        presenter?.merCodeObserver.subscribe(onNext: { (code) in
//            self.MerCodeLabel.text = code
//        }).disposed(by: disposeBag)
//        presenter?.merNameObserver.subscribe(onNext: { (name) in
//            if name == "" {
//                self.MerNameLabel.isHidden = true
//            } else {
//                self.MerNameLabel.text = name
//            }
//        }).disposed(by: disposeBag)
        
        
        presenter?.merAmountObserver.subscribe(onNext: { (amount) in
            self.amountFeild.text = amount
        }).disposed(by: disposeBag)
//        presenter?.merBillRefObserver.subscribe(onNext: { (billRef) in
//            self.orderNoField.text = billRef
//        }).disposed(by: disposeBag)
        
//        presenter?.merObjectObserver?.subscribe(onNext: { (merchant) in
//            Util.debugMsg(merchant)
//            self.MerNameLabel.isHidden = false
//            self.MerNameLabel.text = merchant._merchantName
//            self.MerCodeLabel.text = merchant._merchantCode
//        }).disposed(by: disposeBag)
                
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.assignFocus))
        amountCurrencyLabel.isUserInteractionEnabled = true
        amountCurrencyLabel.addGestureRecognizer(gesture)
    }
    
    @objc func assignFocus(sender:UITapGestureRecognizer) {
        amountFeild.becomeFirstResponder()
    }
    
    func localization() {
        paymentInfoTitle.text = "paymentInfo".localized
        paymentInfoSubTitle.text = "paymentInfoEntry".localized
        
//        amountFeild.placeholder = NSLocalizedString("amount", comment: "amount")
        AmountLabel.text = "amount".localized
        
        merchantNoField.placeholder = "merchantCode".localized
        merchantNoLabel.text = "merchantCode".localized
        
        payBtn.setTitle("continue".localized, for: .normal)
        cancelBtn.setTitle("payByScanningQR".localized, for: .normal)
    }

    @IBAction func cancelPay(_ sender: Any) {
        self.presenter?.closeMechantPay()
    }
    
    @IBAction func payToMerchClicked(_ sender: Any) {
        guard !(amountFeild.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! else {
            return
        }
        guard !(merchantNoField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! else {
            return
        }
        self.presenter?.pay(amount: amountFeild.text, merchantNumber: merchantNoField.text)
    }
    

    
    @IBAction func TExtFieldsChangedAction(_ sender: UITextField) {
        if sender == amountFeild{
            if sender.text!.isEmpty{
                amountCurrencyLabel.isHidden = true
            }else{
                amountCurrencyLabel.isHidden = false
            }
            
            sender.text = sender.amountTrim
            
        }else if sender == merchantNoField{
            if sender.text!.count > 14{
                sender.deleteBackward()
            }
        }
        
        if merchantNoField.text!.merchantIDIsValid && !(amountFeild.text!.isEmpty){
            payBtn.enableBtn()
        }else{
            payBtn.disableBtn()
        }
    }
}
