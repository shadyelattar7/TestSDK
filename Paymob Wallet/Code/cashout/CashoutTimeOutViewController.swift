//
//  CashoutTimeOutViewController.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 26/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

class CashoutTimeOutViewController: PayMobViewController{
    
    @IBOutlet weak var cashoutTimeOutTitle: UILabel!
    @IBOutlet weak var cashoutTimeOutSubTitle: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    var presenter: CashoutPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()

        presenter?.addBarButtons(vc: self)
    }
    
    func localization(){
        cashoutTimeOutTitle.text = "cashoutTimeOutTitle".localized
        cashoutTimeOutSubTitle.text = "cashoutTimeOutSubTitle".localized
        retryBtn.setTitle("otpRetry".localized, for: .normal)
        self.navigationItem.title = presenter?.type
    }
    
    @IBAction func retryTapped(_ sender: Any) {
        self.presenter?.goToPreviousVC()
    }
    
}
