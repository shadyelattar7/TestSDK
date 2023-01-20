//
//  ActivateViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit

class ActivateViewController: PayMobViewController {
    var presenter:AuthPresenter?
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var signInImageView: UIImageView!
    @IBOutlet weak var verifyTextFeild: PaymobUITextField!
    @IBOutlet weak var youWillRecieveSmsLb: PaymobUILabel!
    @IBOutlet weak var poweredByLb: PaymobUILabel!
    @IBOutlet weak var resendSmsBtn: UILabel!
    @IBOutlet weak var submitBtn: PaymobUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        //self.navigationItem.setHidesBackButton(true, animated: false)
        initViews()
    }
    
    func initViews(){        
        let backImage = UIImage.init(named: (EntryPoint.langId == "en") ? "back_ar" : "back_en")
        backBtn.setImage(backImage, for: .normal)
        verifyTextFeild.delegate = self
        submitBtn.disableBtn()
    }

    @IBAction func backTapped(_ sender: Any) {
        back()
    }
    func localization() {
        verifyTextFeild.placeholder = "verificationCode".localized
        youWillRecieveSmsLb.text = "youWillRecieveSms".localized + (presenter?.localManager?.user?._mobile)!
        poweredByLb.text = "poweredBy".localized
        resendSmsBtn.text = "resendSms".localized
        submitBtn.setTitle("submit".localized, for: .normal)
    }
    
    @IBAction func activationSubmit(_ sender: Any) {
        self.presenter?.activationCode(code: self.verifyTextFeild.text!)

    }
    
    @IBAction func resendSms(_ sender: Any) {
        Util.debugMsg("tapped")
        if (presenter?.localManager?.userExist)! {
            Util.debugMsg("tapped")
            self.presenter?.submitMobileNumber(mobile: (presenter?.localManager?.user?._mobile)!)
        }
        
    }

}

extension ActivateViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count >= 6{
            submitBtn.enableBtn()
        }else if count < 6{
            submitBtn.disableBtn()
        }
        
        return true
    }
}
