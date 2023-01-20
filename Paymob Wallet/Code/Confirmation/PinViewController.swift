//
//  PinViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/22/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import SVPinView

class PinViewController: PayMobViewController {
    var presenter:ConfirmationPresenter?
    
    @IBOutlet weak var pinText: PaymobUITextField!
    @IBOutlet weak var PinTextView: SVPinView!
    
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var doneBtn: PaymobUIButton!
    @IBOutlet weak var backgroundLowerView: UIView!
    @IBOutlet weak var enterYourMpinLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.keyBoard(withPush: true)
        // Do any additional setup after loading the view.
        pinText.delegate = self
        initVC()
    }
    
    func initVC(){

   
        doneBtn.disableBtnWithImg(lockImageView, ImageProvider.image(named: "closedLock")!)
        
        
        backgroundLowerView.layer.cornerRadius = 16.0
        backgroundLowerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        PinTextView.pinLength = 6
        PinTextView.interSpace = 6
        PinTextView.textColor = UIColor.black
        PinTextView.shouldSecureText = true
        PinTextView.secureCharacter = "•"
        PinTextView.style = .underline
        PinTextView.secureTextDelay = 100
        
        //        PinTextView.borderLineColor = UIColor.AppColor.LabelGray!
        PinTextView.activeBorderLineColor = UIColor.AppColor.LabelGreen!
        //        PinTextView.borderLineThickness = 1
        PinTextView.activeBorderLineThickness = 3
        
        PinTextView.font = UIFont.systemFont(ofSize: 22)
        PinTextView.keyboardType = .asciiCapableNumberPad
        PinTextView.keyboardAppearance = .default
        PinTextView.becomeFirstResponderAtIndex = 0
        
        PinTextView.didChangeCallback = { [weak self] pin in
            guard let self = self else {return}
            print("The pin entered is \(pin)")
            if pin.count == 6{
                self.doneBtn.enableBtnWithImg(self.lockImageView, ImageProvider.image(named: "openedLock")!)
            }else{
                self.doneBtn.disableBtnWithImg(self.lockImageView, ImageProvider.image(named: "closedLock")!)
            }
        }
    }
    
    func localization() {
        //pinText.placeholder = NSLocalizedString("pin", comment: "pin")
        doneBtn.setTitle("done".localized, for: .normal)
        enterYourMpinLb.text = "enterPinToContinue".localized
        
    }
    
    
    @IBAction func doneClicked(_ sender: Any) {
        
        //        self.presenter?.confirmPin(pin: self.pinText.text!)
        self.presenter?.confirmPin(pin: self.PinTextView.getPin())
    }
    @IBAction func closeCliced(_ sender: Any) {
        self.presenter?.closeConfirmation()
    }
}

extension PinViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count >= 6{
            doneBtn.enableBtnWithImg(self.lockImageView, ImageProvider.image(named: "openedLock")!)
        }else if count < 6{
            doneBtn.disableBtnWithImg(lockImageView, ImageProvider.image(named: "closedLock")!)
        }
        
        //        return count <= 6
        return true
    }
}
