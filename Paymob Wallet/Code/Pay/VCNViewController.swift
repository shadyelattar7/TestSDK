//
//  VCNViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import Kingfisher

class VCNViewController: PayMobViewController {
    
    var presenter:PayPresenter?
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountCurrencyLabel: UILabel!
    @IBOutlet weak var cardAmountLabel: UILabel!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var generateBtn: PaymobUIButton!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var vcnTitle: UILabel!
    @IBOutlet weak var vcnSubTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        presenter?.addBarButtons(vc: self)
        amountTextField.delegate = self
        generateBtn.disableBtn()
        self.localization()
        if let imageUrl = presenter?.adImage {
            if let url = URL(string: settings.imageBase+imageUrl) {
                adImageView.kf.indicatorType = .activity
                adImageView.kf.setImage(with: url)
            }
        }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.assignFocus))
        amountCurrencyLabel.isUserInteractionEnabled = true
        amountCurrencyLabel.addGestureRecognizer(gesture)
    }
    
    @objc func assignFocus(sender:UITapGestureRecognizer) {
        amountTextField.becomeFirstResponder()
    }

    func localization() {
        self.navigationItem.title = "newCard".localized
        //self.amountTextField.placeholder = NSLocalizedString("amount", comment: "amount")
        vcnTitle.text = "vcnTitle".localized
        vcnSubTitle.text = "vcnSubTitle".localized
        generateBtn.setTitle("generate".localized, for: .normal)
        cardAmountLabel.text = "cardBalance".localized
//        amountTextField.placeholder = NSLocalizedString("cardBalance", comment: "")
    }
    
    @IBAction func generateCard(_ sender: Any) {
        guard !self.amountTextField.text!.isEmpty else{
            return
        }
        self.presenter?.createVirtualCard(amount: amountTextField.text!)
    }
}

extension VCNViewController: UITextFieldDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 0{
            generateBtn.disableBtn()
            amountCurrencyLabel.isHidden = true
        }else{
            generateBtn.enableBtn()
            amountCurrencyLabel.isHidden = false
        }
        
        return true
    }
}
