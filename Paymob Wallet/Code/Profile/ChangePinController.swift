//
//  ChangePinController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 7/17/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class ChangePinController: PayMobViewController {

    var presenter: ProfilePresenter?
    
    @IBOutlet weak var oldPinLb: UILabel!
    @IBOutlet weak var oldPinTxt: UITextField!
    @IBOutlet weak var newPinLb: UILabel!
    @IBOutlet weak var newPinTxt: UITextField!
    @IBOutlet weak var confirmPinLb: UILabel!
    @IBOutlet weak var confirmPinTxt: UITextField!
    @IBOutlet weak var setPinBtn: PaymobUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        
        presenter?.addBarButtons(vc: self)
        oldPinTxt.delegate = self
        newPinTxt.delegate = self
        confirmPinTxt.delegate = self
    }
    
    func localization() {
        self.navigationItem.title = "changePin".localized
        self.oldPinLb.text = "oldPin".localized
        self.oldPinTxt.placeholder = "oldPin".localized
        self.newPinLb.text = "newPin".localized
        self.newPinTxt.placeholder = "newPin".localized
        self.confirmPinLb.text = "confirmPin".localized
        self.confirmPinTxt.placeholder = "confirmPin".localized
        setPinBtn.setTitle("changePin".localized, for: .normal)
    }
    
    @IBAction func setPinTapped(_ sender: Any) {
        presenter?.resetMpin(pin: oldPinTxt.text!, newPin: newPinTxt.text!, confPin: confirmPinTxt.text!)
    }
}

extension ChangePinController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var old = oldPinTxt.text
        var new = newPinTxt.text
        var confirm = confirmPinTxt.text
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if (textField == oldPinTxt){
                old = updatedText
            }else if (textField == newPinTxt){
                new = updatedText
            }else{
                confirm = updatedText
            }
        }
        if (old!.count < 6 || new!.count < 6 || new != confirm){
            setPinBtn.disableBtn()
        }else{
            setPinBtn.enableBtn()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Done")
    }
}
