//
//  SendAmountController.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 28/06/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift
import ContactsUI
import RealmSwift

class SendAmountController: PayMobViewController  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: PaymobUILabel!
    @IBOutlet weak var amountTextLabel: PaymobUITextField!
    @IBOutlet weak var amountCurrencyLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: PaymobUIButton!
    @IBOutlet weak var messageTitle: PaymobUILabel!
    
    var presenter:SendPresenter?
    var sendDisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        addDoneButtonOnKeyboard()
        self.localization()
        
        initVC()
    }
    
    func initVC(){
        messageTextView.textColor = .darkGray
        messageTextView.delegate = self
        amountTextLabel.delegate = self
        sendBtn.disableBtn()
        presenter?.addBarButtons(vc: self)

        
        messageTextView.textAlignment = EntryPoint.langId == "en" ? .left : .right
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.assignFocus))
        amountCurrencyLabel.isUserInteractionEnabled = true
        amountCurrencyLabel.addGestureRecognizer(gesture)
    }
    
    @objc func assignFocus(sender:UITapGestureRecognizer) {
        amountTextLabel.becomeFirstResponder()
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
    
    func addDoneButtonOnKeyboard() {
        let window = UIApplication.shared.keyWindow
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: (window?.bounds.width)!, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        var items = [UIBarButtonItem]()
        //items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        messageTextView.inputAccessoryView = doneToolbar
        amountTextLabel.inputAccessoryView = doneToolbar
    }

    
    func localization() {
        self.navigationItem.title = "send".localized
        amountLabel.text = "amount".localized
        messageTitle.text = "messageTitle".localized
        sendBtn.setTitle("submit".localized, for: .normal)
        messageTitle.text = "writeMessage".localized

        titleLabel.text = "sendAmountTitle".localized
        subTitleLabel.text = "sendAmountSubTitle".localized

    }
    
    @IBAction func sendTapped(_ sender: Any) {
        
        guard let amount = amountTextLabel.text else {
            return
        }
        
        presenter?.amount = amount
        if messageTextView.text == "writeMessage".localized {
            presenter?.sendMoneyClicked(msg: "")
        } else {
            presenter?.sendMoneyClicked(msg: messageTextView.text)
        }
    }
    
    func checkBalance(amount: String){
        if ( Double(amount) ?? 0.0 > Double(self.presenter?.localManager?.user?._balance ?? "0.0") ?? 0.0 ){
            amountTextLabel.configureAlert(message: "largerThanBalanceValidation".localized)
        }else{
            amountTextLabel.configureAlert(message: "")
        }
    }
    
    @objc func doneButtonAction() {
        messageTextView.resignFirstResponder()
        amountTextLabel.resignFirstResponder()
    }

}

extension SendAmountController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
//            scrollToBottom(scrollView: scrollView)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "writeMessage".localized
            textView.textColor = UIColor.darkGray
        }
    }
    
    func scrollToBottom(scrollView: UIScrollView) {
//        CGPoint point = textfield.frame.origin ;
//        scrollView.contentOffset = point
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
            let y = self.messageTextView.frame.maxY
            let point = CGPoint(x: 0, y: y)
            scrollView.contentOffset = point
        }, completion: nil)
        
    }

}

extension SendAmountController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        textField.text = textField.amountTrim
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedText = ""
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            updatedText = text.replacingCharacters(in: textRange, with: string)
        }
        
        if updatedText.count > 0{
            sendBtn.enableBtn()
//            checkBalance(amount: updatedText)
            amountCurrencyLabel.isHidden = false
        }else {
            sendBtn.disableBtn()
//            amountTextLabel.configureAlert(message: "")
            amountCurrencyLabel.isHidden = true
        }
        
        
        return true
    }
 
    
}
