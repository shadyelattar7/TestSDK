//
//  MutliUseVCNDeletionView.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 9/21/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import Foundation
import UIKit

// VIPER Protocol for communication from Presenter -> View
protocol MutliUseVCNDeletionPresenterToViewProtocol: class {
    var cardNumber: String {get set}
    func dismissView()
    
}


class MutliUseVCNDeletionView: UIViewController {
    
    // MARK: - VIPER Stack
    var presenter: MutliUseVCNDeletionViewToPresenterProtocol!
    
    // MARK: - IBOutLets
    @IBOutlet weak var pinTextField: PaymobUITextField!
    @IBOutlet weak var cardNumberTextField: PaymobUITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var cardNumber: String = ""
    // MARK: - Instance Variables
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        
        hintLabel.text =
        "You are about to delete multi use VCN with number\n" +
        "\(cardNumber)" +
        "\nplease enter the card number and your PIN to confirm."
        
//        You are about to delete multi use VCN with number XXXXXXXXX, please enter the card number and your PIN to confirm.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

//        let selectedRange = scrollView.selectedRange
//        scrollView.scrollRangeToVisible(selectedRange)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        if let pin = self.pinTextField.text, let cardNumber = self.cardNumberTextField.text {
            self.presenter.doneButtonDidTapped(pin: pin, cardNumber: cardNumber)
        }
        
    }
    
    
}

// MARK: - Presenter to View Protocol
extension MutliUseVCNDeletionView: MutliUseVCNDeletionPresenterToViewProtocol {
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
