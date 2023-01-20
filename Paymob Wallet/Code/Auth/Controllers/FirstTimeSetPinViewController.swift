//
//  FirstTimeSetPinViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/22/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class FirstTimeSetPinViewController: PayMobViewController {
    
    var presenter: AuthPresenter?
    
    @IBOutlet weak var pinMessageLabel: UILabel!
    @IBOutlet weak var changeMpinTitleLb: PaymobUILabel!
    @IBOutlet weak var setPinBtn: PaymobUIButton!
    @IBOutlet weak var confirmPinTxt: PaymobUITextField!
    @IBOutlet weak var mpinTxt: PaymobUITextField!
    
    @IBOutlet weak var mOldPinTxt: PaymobUITextField!
    
    
    var isPinExpiry:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        // Do any additional setup after loading the view.
        mOldPinTxt.isHidden = !(self.isPinExpiry)
    }
    
    func localization() {
        mOldPinTxt.placeholder = "oldPinPLaceHolder".localized
        pinMessageLabel.text = "pinMsg".localized
        changeMpinTitleLb.text = "setPin".localized
        setPinBtn.setTitle("setPin".localized, for: .normal)
        mpinTxt.placeholder = "newPin".localized
        confirmPinTxt.placeholder = "confirmPin".localized
        
    }
    
    @IBAction func setPinTapped(_ sender: Any) {
        
        if self.isPinExpiry{
            presenter?.setExpiredPin(oldPin: self.mOldPinTxt.text! , newPin: mpinTxt.text!, confirmPin: confirmPinTxt.text!)
        }else{
            self.presenter?.setPin(newPin: mpinTxt.text!, confirmPin: confirmPinTxt.text!)
        }
    }
    
}
