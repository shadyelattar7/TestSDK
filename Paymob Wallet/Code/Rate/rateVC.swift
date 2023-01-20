//
//  rateVC.swift
//  Paymob Wallet
//
//  Created by mac on 12/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit
import RxSwift
@available(iOS 13.0, *)
class rateVC: UIViewController {
    
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var sendFeedbackLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var rateAndFeedbackBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var rateTransactionLabel: UILabel!
    
    
    var presenter: RatePresenter?
    var TXNID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        messageTextView.delegate = self
        messageTextView.placeholder = "Type your message here".localized
        rateTransactionLabel.text = "Rate Transaction".localized
        sendFeedbackLabel.text = "Send Feedback".localized
        rateBtn.setTitle("Rate".localized, for: .normal)
        rateAndFeedbackBtn.setTitle("Rate and Feedback".localized, for: .normal)
        sendBtn.setTitle("submit".localized, for: .normal)
        messageTextView.addDoneButtonOnKeyboard()
        sendBtn.disableBtn()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        presenter?.closeAction()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let message = messageTextView.text , !message.isEmpty else {
            return
        }
        presenter?.feedback(message: message)
    }
    
    @IBAction func rateAndFeedBackAction(_ sender: Any) {
        let rate = Int( self.ratingView.rating)
        presenter?.rateBeforeFeedback(rateVal:rate, TXNID: TXNID)

//        rateView.isHidden = true
//        feedbackView.isHidden = false
    }
    
    @IBAction func rateAction(_ sender: Any) {
        let rate = Int( self.ratingView.rating)
        presenter?.rate(rateVal:rate, TXNID: TXNID)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    

    
}


@available(iOS 13.0, *)
extension rateVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text!.isEmpty{
            sendBtn.disableBtn()
        }else{
            sendBtn.enableBtn()
        }
    }
}
