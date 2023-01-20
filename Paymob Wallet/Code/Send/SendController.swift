//
//  SendController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ContactsUI
import RealmSwift

class SendController: PayMobViewController, CNContactPickerDelegate, UITextViewDelegate  {
    
    @IBOutlet weak var upperView: UIView!
    var presenter:SendPresenter?
    var sendDisposeBag = DisposeBag()
    var name = ""
    
    @IBOutlet weak var mobileNumberLabel: PaymobUILabel!
    @IBOutlet weak var mobileNumberTextLabel: PaymobUITextField!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var sendBtn: PaymobUIButton!
    @IBOutlet weak var recentsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var chooseContactBtn: UIButton!
    
    
    
    func localization() {
        self.navigationItem.title = "send".localized
        mobileNumberLabel.text = "recipient".localized
        sendBtn.setTitle("submit".localized, for: .normal)
        chooseContactBtn.setTitle("chooseContact".localized, for: .normal)
        recentsLabel.text = "recents".localized
        titleLabel.text = "recipient".localized
        subTitleLabel.text = "enterRecipient".localized
        
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        
        guard let mobile = mobileNumberTextLabel.text else {
            return
        }
        
        self.addContactToSaved(mobile: (mobile.getOnly(charSet: CharacterSet.decimalDigits)))
        presenter?.mobile = mobile.toPhoneFormate
        presenter?.contactName = name
        presenter?.goToAmountVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        
        mobileNumberTextLabel.delegate = self
        sendBtn.disableBtn()
        presenter?.addBarButtons(vc: self)
        
        self.presenter?.currentContact.subscribe(onNext: { (contact) in
            self.mobileNumberTextLabel.text = contact._mobile
            Util.debugMsg(contact)
        }).disposed(by: sendDisposeBag)
        //        self.contactsView.isHidden = false
        self.presenter?.embeddContactsVC(into: self, container: contactsView)
        
        
        /*
         RxKeyboard.instance.isHidden.asObservable().subscribe(onNext: {[weak self] (isHidden) in
         guard let strongSelf = self else { return }
         if isHidden {
         strongSelf.scrollViewHeightConstraint.constant = 500
         //strongSelf.animateView(view: strongSelf.view)
         } else {
         strongSelf.scrollViewHeightConstraint.constant = 760
         //strongSelf.animateView(view: strongSelf.view)
         }
         }).disposed(by: disposeBag)
         */
        
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
    
    func animateView(view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
            view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func chooseContactTapped(_ sender: Any) {
        Util.debugMsg("contact")
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate=self
        contactPicker.displayedPropertyKeys = [CNContactImageDataKey, CNContactPhoneNumbersKey,CNContactGivenNameKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard let number=contactProperty.value as? CNPhoneNumber else{
            print("error not number")
            return
        }
        
        var newNumber = number.stringValue.replacingOccurrences(of: "+", with: "")
        newNumber = newNumber.replacingOccurrences(of: " ", with: "")
        Util.debugMsg(contactProperty.value)
        
        //        let realm = try? Realm()
        //        let contact = Contact()
        //        try? realm?.write {
        //            contact._mobile=newNumber
        //            contact._name=contactProperty.contact.givenName
        //            if contactProperty.contact.imageDataAvailable {
        //                print("with image")
        //                contact._image=contactProperty.contact.imageData
        //            }
        //            realm?.add(contact)
        //        }
        //        self.mobileNumberTextLabel.text=contact._mobile
        
        self.mobileNumberTextLabel.text = newNumber.toPhoneFormate
        name = contactProperty.contact.givenName
        sendBtn.enableBtn()
    }
    
    @IBAction func contactsTapped(_ sender: Any) {
        Util.debugMsg("contact")
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate=self
        contactPicker.displayedPropertyKeys = [CNContactImageDataKey, CNContactPhoneNumbersKey,CNContactGivenNameKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    func addContactToSaved(mobile: String){
        let realm = try? Realm()
        let contact = Contact()
        try? realm?.write {
            contact._mobile=mobile
            contact._name=mobile
            //            if contactProperty.contact.imageDataAvailable {
            //                print("with image")
            //                contact._image=contactProperty.contact.imageData
            //            }
            realm?.add(contact)
        }
    }
}

extension SendController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 11{
            sendBtn.enableBtn()
//            mobileNumberTextLabel.configureAlert(message: "")
        }else if count < 11{
            sendBtn.disableBtn()
//            mobileNumberTextLabel.configureAlert(message: NSLocalizedString("11DigitValidation", comment: ""))
        }
        name = ""
        return count <= 11
    }
}
