////
////  CashoutViewController.swift
////  WalletsPaymob
////
////  Created by mahmoud gamal on 9/11/17.
////  Copyright © 2017 mahmoud gamal. All rights reserved.
////
//
//import UIKit
//
//class CashoutViewController: PayMobViewController {
//
//    @IBOutlet weak var amountLabel: UILabel!
//    @IBOutlet weak var youCanCashTitleLb: UILabel!
//    @IBOutlet weak var firstStepLb: UILabel!
//    @IBOutlet weak var secondStepLb: UILabel!
//    @IBOutlet weak var thirdStepLb: UILabel!
//    @IBOutlet weak var amountTextField: PaymobUITextField!
//    @IBOutlet weak var fourthStepLb: UILabel!
//    @IBOutlet weak var generateOtpBtn: PaymobUIButton!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.keyBoard(withPush: false)
//        self.localization()
//
//    }
//    
//    func localization() {
//        self.navigationItem.title = NSLocalizedString("cashout", comment: "cashout")
//        youCanCashTitleLb.text = NSLocalizedString("youCanCash", comment: "youCanCash")
//        firstStepLb.text = NSLocalizedString("cashoutFirstStep", comment: "cashoutFirstStep")
//        secondStepLb.text = NSLocalizedString("cashoutSecondStep", comment: "cashoutSecondStep")
//        thirdStepLb.text = NSLocalizedString("cashoutThirdStep", comment: "cashoutThirdStep")
//        fourthStepLb.text = NSLocalizedString("cashoutFourthStep", comment: "cashoutFourthStep")
//        amountLabel.text = NSLocalizedString("amount", comment: "enterAmount")
//        generateOtpBtn.setTitle(NSLocalizedString("generateOtp", comment: "generateOtp"), for: .normal)
//        
//    }
//
//    @IBAction func generateOtpTapped(_ sender: Any) {
//        presenter?.cashOutClicked(amount: amountTextField.text!)
//    }
//    
//}
//
