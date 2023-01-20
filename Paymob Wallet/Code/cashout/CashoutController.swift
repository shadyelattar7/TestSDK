//
//  CashoutController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 7/19/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class CashoutController: PayMobViewController {
    @IBOutlet weak var cashoutImage: UIImageView!
    @IBOutlet weak var cashoutTitle: UILabel!
    @IBOutlet weak var cashoutSubTitle: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountCurrencyLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var generateOtpBtn: PaymobUIButton!
    var presenter: CashoutPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        
        presenter?.addBarButtons(vc: self)
        amountTextField.delegate = self
        generateOtpBtn.disableBtn()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.assignFocus))
        amountCurrencyLabel.isUserInteractionEnabled = true
        amountCurrencyLabel.addGestureRecognizer(gesture)
    }
    
    @objc func assignFocus(sender:UITapGestureRecognizer) {
        amountTextField.becomeFirstResponder()
    }
    
    func localization() {
        if (presenter?.type == "cashout".localized){
            cashoutImage.image = UIImage.init(named: "cashout")
            cashoutTitle.text = "cashoutTitle".localized
            cashoutSubTitle.text = "cashoutSubTitle".localized
        }else{
            cashoutImage.image = UIImage.init(named: "cashin")
            cashoutTitle.text = "cashinTitle".localized
            cashoutSubTitle.text = "cashinSubTitle".localized
        }
        self.navigationItem.title = presenter?.type
        
        amountLabel.text = "amount".localized
        generateOtpBtn.setTitle("continue".localized, for: .normal)
        
    }
    
    func changeInstructionNumber(label: UILabel, instruction: String) {
        let range = NSRange(location: 0, length: 2)
        //let attributedString = NSMutableAttributedString(string: instruction, attributes: [NSFontAttributeName: UIFont(name: "Helvetica-Neue", size: 15)!])
        let attributedString = NSMutableAttributedString(string: instruction, attributes: nil)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: settings.primaryColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Bold", size: 17)!, range: range)
        label.attributedText = attributedString
    }
    
    @IBAction func generateOtpTapped(_ sender: Any) {
        presenter?.cashOutClicked(amount: amountTextField.text!)
    }
    
}

extension CashoutController: UITextFieldDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 0{
            generateOtpBtn.disableBtn()
            amountCurrencyLabel.isHidden = true
        }else{
            generateOtpBtn.enableBtn()
            amountCurrencyLabel.isHidden = false
        }
        
        return true
    }
}

