//
//  UnregisterViewController.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import UIKit

class UnregisterViewController: InactivateController {
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var sendVerificationBtn: UIButton!
    @IBOutlet weak var OTPStackView: UIStackView!
    @IBOutlet weak var OTPTextField: UITextField!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    var presenter: UnregisterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyBoard(withPush: false)
        localization()
        hideUnregisterStackView()
    }
    
    func localization() {
        navigationItem.title = "unregister".localized
        mobileNumberTextField.placeholder = "mobileNumber".localized
        pinTextField.placeholder = "pleaseEnterYourPin".localized
        sendVerificationBtn.setTitle("sendVerification".localized, for: .normal)
        OTPTextField.placeholder = "verification".localized
        unregisterBtn.setTitle("unregister".localized, for: .normal)
    }
    
    func hideUnregisterStackView(){
        OTPStackView.isHidden = true
        sendVerificationBtn.isHidden = false
    }
    
    func showUnregisterStackView(){
        OTPStackView.isHidden = false
        sendVerificationBtn.isHidden = true
    }
    
    @IBAction func sendVerificationAction(_ sender: Any) {
        presenter?.sendVerificationTapped(pin: pinTextField.text!, mobile: mobileNumberTextField.text!)
    }
    
    @IBAction func unregisterAction(_ sender: Any) {
        presenter?.UnregisterTapped(otp: OTPTextField.text!, mobile: mobileNumberTextField.text!)
    }
}
