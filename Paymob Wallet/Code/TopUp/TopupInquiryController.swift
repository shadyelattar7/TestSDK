//
//  TopupInquiryController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 11/15/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class TopupInquiryController: UIViewController {
    var presenter: TopUpPresenter?

//    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nationalidTextField: PaymobUITextField!
    @IBOutlet weak var nationalidLabel: UILabel!
    
    
    @IBOutlet weak var firstInquiryButton: PaymobUIButton!
    @IBOutlet weak var payContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var feesValueLabel: UILabel!
    @IBOutlet weak var payButton: PaymobUIButton!
    @IBOutlet weak var dueDateValue: UILabel!
    @IBOutlet weak var duePenaltyValeu: UILabel!
    @IBOutlet weak var duePenaltyStackView: UIStackView!
    @IBOutlet weak var dueDateStackView: UIStackView!
    @IBOutlet weak var installmentIdLabel: UILabel!
    
    @IBOutlet weak var topUpTitle: UILabel!
    @IBOutlet weak var topUpSubTitle: UILabel!
    
    
    var billFees = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        initVC()
//        duePenaltyStackView.isHidden = true
//        dueDateStackView.isHidden = true
        
        
        /*if presenter?.currentType == TopupType.mashroey {
            //navigationItem.title = NSLocalizedString("mashrooy", comment: "mashrooy")
            logoImageView.image = #imageLiteral(resourceName: "mashroey")
        } else if presenter?.currentType == TopupType.tasahel {
            //navigationItem.title = NSLocalizedString("tsaheel", comment: "tsaheel")
            logoImageView.image = UIImage(named: NSLocalizedString("tsaheel_logo", comment: "tsaheel_logo"))
        }
//        let url = URL(string: (presenter?.institution!.logo_url)!)!
//        logoImageView.kf.setImage(with: url, placeholder: UIImage.init(named: "white_tasahel"))
        */
//        if let amount = presenter?.amount {
//            nationalidTextField.isHidden = true
//            nationalidLabel.isHidden = true
//            firstInquiryButton.isHidden = true
////            amountLabel.isHidden = false
//        } else {
//            nationalidTextField.isHidden = false
//            nationalidLabel.isHidden = false
//            firstInquiryButton.isHidden = false
////            amountLabel.isHidden = true
//        }
    }
    
    func initVC(){
        payContainerView.isHidden = true
        nationalidTextField.delegate = self
        firstInquiryButton.disableBtn()
        presenter?.addBarButtons(vc: self)
//        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let url = URL(string: (presenter?.institution!.logo_url)!)!
    }
    
    func localization(){
        navigationItem.title = "topUpTitle".localized

        amountLabel.text = "amount".localized
        nameLabel.text = "myName".localized
        feesLabel.text = "fee".localized
        firstInquiryButton.setTitle("inquire".localized, for: .normal)
        payButton.setTitle("pay".localized, for: .normal)
        
        installmentIdLabel.text = "InstallmentId".localized
        
//        topUpTitle.text = NSLocalizedString("nationalId", comment: "")
//        topUpSubTitle.text = NSLocalizedString("topUpInquirySubTitle", comment: "")
//        nationalidLabel.text = NSLocalizedString("nationalId", comment: "")
        
        topUpTitle.text = self.presenter?.institution?.identifierName
        topUpSubTitle.text = "\("pleaseEnter".localized) \(self.presenter?.institution?.identifierName ?? "") \("linkedTo".localized)\(self.presenter?.institution?.name ?? "")"
        nationalidLabel.text = self.presenter?.institution?.identifierName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func inquireTapped(_ sender: Any) {
        guard let text = nationalidTextField.text, !text.isEmpty else {return}
        presenter?.nationalId = text
//        if let _ = presenter?.amount {
//            guard let amount = amountTextField.text, !amount.isEmpty else {return}
//            presenter?.staticBillInquiry(billRef: text, amount: amount, completed: { (completed) in
//
//            })
//        } else {
            presenter?.staticBillInquiry(billRef: text, completed: {[unowned self] (completed, response) in
                DispatchQueue.main.async {
                    if completed {
//                        self.nationalidTextField.isHidden = true
//                        self.nationalidLabel.isHidden = true
//                        self.firstInquiryButton.isHidden = true
//                        self.payContainerView.isHidden = false
                        self.amountValueLabel.text = response?.amount
                        self.nameValueLabel.text = response?.clientName
                        self.feesValueLabel.text = response?.topUpFees ?? "0"
                        self.billFees = response?.topUpFees ?? "0"
                        
                        self.presenter?.ref = response?.topUpRef
                        self.presenter?.amount = response!.amount
                        
                        
                        if let response = response,
                            let duePenalty = response.duePenalty,
                            duePenalty > 0 {
                            self.dueDateValue.text = response.dueDate
                            self.duePenaltyValeu.text = "\(duePenalty)"
                            duePenaltyStackView.isHidden = false
                            dueDateStackView.isHidden = false
                            
                            presenter!.amount! = "\(Double(response.amount)! + duePenalty)"
//                            self.amountValueLabel.text = "\(Double(response.amount)! + duePenalty)"
                        }
                        //MARK: - TEST THIS
                        presenter?.payBill(amount: presenter!.amount!, merCode: "700010", billFees: self.billFees)

                    } else {
                    }
                
                    print("\n\nfinal \(amountValueLabel.text)\n\n")

                }
            })

    }
    
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        
        presenter?.payBill(amount: presenter!.amount!, merCode: "700010", billFees: self.billFees)
        
    }
    
    
    deinit {
        presenter?.amount = nil
        presenter?.ref = nil
        presenter?.nationalId = nil
        presenter?.fees = nil
    }
}

extension TopupInquiryController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count >= ((self.presenter?.institution!.identifierLength)!) {
            firstInquiryButton.enableBtn()
        }else {
            firstInquiryButton.disableBtn()
        }
        return count <= ((self.presenter?.institution!.identifierLength)!)
//        return true
    }
}

