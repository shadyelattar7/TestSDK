//
//  ResetPinViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class ResetPinViewController: PayMobViewController {

    var presenter: SettingsPresenter?
    
    @IBOutlet weak var pinMessageLabel: UILabel!
    @IBOutlet weak var oldPinTxt: PaymobUITextField!
    @IBOutlet weak var newPinTxt: PaymobUITextField!
    @IBOutlet weak var confirmPinTxt: PaymobUITextField!
    @IBOutlet weak var setPinBtn: PaymobUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
    }

    func localization() {
        self.navigationItem.title = "changePin".localized
        pinMessageLabel.text = "pinMsg".localized
        self.oldPinTxt.placeholder = "oldPin".localized
        self.newPinTxt.placeholder = "newPin".localized
        self.confirmPinTxt.placeholder = "confirmPin".localized
        setPinBtn.setTitle("changePin".localized, for: .normal)
    }
    
    @IBAction func setPinTapped(_ sender: Any) {
        presenter?.resetMpin(pin: oldPinTxt.text!, newPin: newPinTxt.text!, confPin: confirmPinTxt.text!)
    }

}
