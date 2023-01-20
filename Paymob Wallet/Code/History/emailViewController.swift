//
//  emailViewController.swift
//  Paymob Wallet
//
//  Created by mac on 25/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class emailViewController: InactivateController {

    @IBOutlet weak var expoert: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    
    var presenter: HistoryPresenter?
    var router = Router()
    var apiManger: HistoryApiManager?
    var mobile: String?
    var localManager: AuthLocalManager?
    
    var isEmailVaild: Bool = false
    var isPinVaild: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        expoert.disableBtn()
        
        presenter?.addBarButtons(vc: self)
        emailTextField.placeholder = "Please enter a valid email".localized
        pinTextField.placeholder = "Please enter your pin".localized
//        emailTextField.addDoneButtonOnKeyboard()
//        pinTextField.addDoneButtonOnKeyboard()
        
        navigationItem.title = "Export History".localized
        
        expoert.setTitle("Export".localized, for: .normal)
        apiManger = HistoryApiManager()
        localManager = AuthLocalManager()
        if (localManager?.userExist)! {
            mobile = localManager?.user?._mobile
        }
//        emailTextField.addDoneButtonOnKeyboard()
//        self.router = self
        
        
        emailTextField.delegate = self
        pinTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
  
    @IBAction func okButtonAction(_ sender: Any) {
        
        guard let email = emailTextField.text , !email.isEmpty  , let pin = pinTextField.text ,!pin.isEmpty , pin.count == 6 else {
            return
        }
        expoertPfd(email: email, pin: pin)
    }
    
    func expoertPfd(email:String,pin:String){
        router.displayAlert(msg: "loading".localized)
        apiManger?.expoertPdf(email: email, mobile: mobile!, pin: pin).subscribe(onNext: { (response) in
            Util.debugMsg(response)
            self.router.hideMsg {
                guard response.txn == "200" else {
                    self.router.sweetAlertFail(message: response.msg, afterMsg: {
                      
                    })
                    return
                }
                self.router.sweetAlertSuccess(message: response.msg, afterMsg: {
                NavigationPresenter.currentModule = "Dashboard"
                self.router.closeModal()
                self.router.goToDashboard()
                })
            }
        }, onError: { (error) in
            self.router.hideMsg {
                self.router.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
}


//MARK: - UITextField Delegate

extension emailViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == pinTextField{ // Pin
            if textField.text?.count == 6{
                isPinVaild = true
                if isEmailVaild == true{
                    expoert.enableBtn()
                }
            }else{
                isPinVaild = false
                expoert.disableBtn()
            }
        }else{ // Email
            if textField.text?.isValidEmail() == true{
                isEmailVaild = true
                if isPinVaild == true{
                    expoert.enableBtn()
                }
            }else{
                isEmailVaild = false
                expoert.disableBtn()
            }
        }
    }
}
