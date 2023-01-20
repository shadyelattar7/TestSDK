//
//  ContactUsViewController.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 8/2/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ContactUsViewController: InactivateController {
    var presenter: ContactUsPresenter?
    var contactUsDisposeBag = DisposeBag()
    @IBOutlet weak var getInTouchLabel: UILabel!
    @IBOutlet weak var callUsButton: UIButton!
    @IBOutlet weak var toLoadYourLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        keyBoard(withPush: false)
        
        addDoneButtonOnKeyboard()
        messageTextView.delegate = self
    }
    
    func localization() {
        navigationItem.title = "contactUs".localized
        getInTouchLabel.text = "inTouch".localized
        callUsButton.setTitle("callUs".localized, for: .normal)
        toLoadYourLabel.text = "toLoadYour".localized
        orLabel.text = "or".localized
        sendMessageButton.setTitle("sendFeedback".localized, for: .normal)
        
        messageTextView.text = "typeYourMessage".localized
        messageTextView.textColor = UIColor.lightGray

    }
    
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        presenter?.menuClicked()
    }
    
    @IBAction func callButton(_ sender: UIButton) {
        presenter?.callClicked()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        if (messageTextView.text.count<3 || messageTextView.text == "typeYourMessage".localized){
            return
        }
        
        presenter?.sendMessageClicked(message: messageTextView.text ?? " ")
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
    }
    
    
    @objc func doneButtonAction() {
        messageTextView.resignFirstResponder()
    }
}
extension ContactUsViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            messageTextView.text = "typeYourMessage".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
}
