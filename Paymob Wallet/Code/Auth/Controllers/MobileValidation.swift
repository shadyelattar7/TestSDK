//
//  MobileValidation.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxSwift

class MobileValidation: PayMobViewController {
    
    var presenter: AuthPresenter?
    
    @IBOutlet weak var mobileText: PaymobUITextField!
    @IBOutlet weak var submitBtn: PaymobUIButton!
    @IBOutlet weak var howToRegTitleLb: PaymobUILabel!
        
    @IBOutlet weak var howToRegBtn: PaymobUIButton!
    @IBOutlet weak var titleLabel: PaymobUILabel!
    @IBOutlet weak var signInImageView: UIImageView!
    @IBOutlet weak var poweredByLb: PaymobUILabel!
    @IBOutlet weak var firstStepLb: PaymobUILabel!
    @IBOutlet weak var secondStepLb: PaymobUILabel!
    @IBOutlet weak var thirdStepLb: PaymobUILabel!
    @IBOutlet weak var fourthStepLb: PaymobUILabel!
    @IBOutlet weak var fifthStepLb: PaymobUILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        // for audi
        //presenter?.showTermsForFirstTime()
        
        initVC()
    }
    
    func initVC(){
        mobileText.delegate = self
        submitBtn.disableBtn()
        
        howToRegBtn.centerTextAndImage(spacing: 10)
        
        if (EntryPoint.langId == "en"){
            howToRegBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        }else{
            howToRegBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        }
    }

    func localization() {
        howToRegTitleLb.text = "howToRegTitle".localized
        firstStepLb.text = "firstStep".localized
        secondStepLb.text = "secondStep".localized
        thirdStepLb.text = "thirdStep".localized
        fourthStepLb.text = "fourthStep".localized
        fifthStepLb.text = "fifthStep".localized
        poweredByLb.text = "poweredBy".localized
        mobileText.placeholder = "mobileNumber".localized
        submitBtn.setTitle(("sendVerificationCode".localized), for: .normal)
        howToRegBtn.setTitle(("howToRegTitle".localized), for: .normal)
        titleLabel.text = "youWillRecieveSms".localized
    }
    
    @IBAction func HowToRegTapped(_ sender: Any) {
        presenter?.goToHowToReg()
    }
    
    @IBAction func submitMobile(_ sender: UIButton) {
        if (presenter?.canAuthenticateNumber)! {
            presenter?.submitMobileNumber(mobile: self.mobileText.text!)
        } else {
            presenter?.showThrottleMessage()
        }
    }

}

extension MobileValidation: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 11{
            submitBtn.enableBtn()
        }else if count < 11{
            submitBtn.disableBtn()
        }
        
        return count <= 11
    }
}
