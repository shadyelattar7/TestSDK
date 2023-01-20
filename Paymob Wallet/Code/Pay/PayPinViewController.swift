//
//  PayPinViewController.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 1/23/22.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit
import SVPinView


class PayPinViewController: InactivateController {
    var presenter: PayPresenter?

    @IBOutlet weak var backgroundLowerView: UIView!
    @IBOutlet weak var PinTextView: SVPinView!    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var onDismiss: (() -> Void)?
    var onDone: ((_ pin:String)-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        keyBoard(withPush: true)
        localization()
//        pinText.delegate = self
        backgroundLowerView.layer.cornerRadius = 16.0
        backgroundLowerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.confirmBtn.disableBtnWithImg(self.lockImageView, ImageProvider.image(named: "closedLock")!)
        svpinViewConfiguration()
    }

    func localization(){
        mainTitle.text = "enterPinLab".localized
        confirmBtn.setTitle("done".localized, for: .normal)
        cancelBtn.setTitle("cancel".localized, for: .normal)
    }
    
    
    //MARK: - SVPinView Cinfiguration
    
    private func svpinViewConfiguration(){
        PinTextView.pinLength = 6
        PinTextView.interSpace = 6
        PinTextView.shouldSecureText = true
        PinTextView.secureCharacter = "•"
        PinTextView.textColor = UIColor.black
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
                self.confirmBtn.enableBtnWithImg(self.lockImageView, ImageProvider.image(named: "openedLock")!)
            }else{
                self.confirmBtn.disableBtnWithImg(self.lockImageView, ImageProvider.image(named: "closedLock")!)
            }
        }
    }

    
    //MARK: - Enable & Disable Configuatiion
    

    @IBAction func doneClicked(_ sender: Any) {
      
            self.dismiss(animated: true) {
                if let _ = self.onDone{
                    print("Pin: \(self.PinTextView.getPin())")
                    self.onDone!(self.PinTextView.getPin())
                }
            }
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        close()
    }
    
    @IBAction func OutsideTapped(_ sender: Any) {
        close()
    }
    
    func close(){
        self.dismiss(animated: true) {
            if let _ = self.onDismiss{
                self.onDismiss!()
            }
        }
    }
}

extension PayPinViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }
}
