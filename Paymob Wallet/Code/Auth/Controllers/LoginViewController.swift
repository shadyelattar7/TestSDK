//
//  LoginViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/8/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit

class LoginViewController: PayMobViewController {
    
    var presenter:AuthPresenter?
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pinMessageLabel: UILabel!
    @IBOutlet weak var MPINTextFeild: PaymobUITextField!
    @IBOutlet weak var loginBtn: PaymobUIButton!
    @IBOutlet weak var poweredByLb: PaymobUILabel!
    @IBOutlet weak var signInImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        
        initVC()
        
        MPINTextFeild.configureAlert(message: "", textColor: .systemRed)
        
    }
    
    func initVC(){        
        let backImage = UIImage.init(named: (EntryPoint.langId == "en") ? "back_ar" : "back_en")
        backBtn.setImage(backImage, for: .normal)
        MPINTextFeild.delegate = self
        loginBtn.disableBtn()
    }

    @IBAction func backTapped(_ sender: Any) {
        back()
    }
    
    func localization() {
        pinMessageLabel.text = "pinMsg".localized
        MPINTextFeild.placeholder = "pleaseEnterYourPin".localized
        loginBtn.setTitle("login".localized, for: .normal)
        poweredByLb.text = "poweredBy".localized
    }

    @IBAction func login(_ sender: Any) {
        self.presenter?.login(pin:MPINTextFeild.text!)
    }

}

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count >= 6{
            loginBtn.enableBtn()
        }else if count < 6{
            loginBtn.disableBtn()
        }
        
        return count <= 6
//        return true
    }
}
