//
//  RequireAuthViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/13/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class RequireAuthViewController: PayMobViewController {
    
    @IBOutlet weak var confirmTitleLb: PaymobUILabel!
    var presenter: BackTaskPresenter?

    @IBOutlet weak var doneBtn: PaymobUIButton!
    @IBOutlet weak var pinTxt: PaymobUITextField!
    @IBOutlet weak var enterYourPinLb: PaymobUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.keyBoard(withPush: false)
    }
    
    func localization() {
        confirmTitleLb.text = "confirmTitle".localized
        pinTxt.placeholder = "pin".localized
        enterYourPinLb.text = "enterYourPin".localized
        doneBtn.setTitle("done".localized, for: .normal)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.presenter?.login(pin: pinTxt.text!)
    }
}
