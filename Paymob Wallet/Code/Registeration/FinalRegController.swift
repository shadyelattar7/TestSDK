//
//  FinalRegController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 4/24/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class FinalRegController: PayMobViewController {

    var presenter: RegPresenter?
    
    @IBOutlet weak var dateOfBirthTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!

    @IBOutlet weak var registerBtn: PaymobUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)

        //self.navigationItem.setHidesBackButton(true, animated: false)

        //presenter?.editNavigationTitleView(vc: self)
        
        addDatePicker()
        registerBtn.setTitle("register".localized, for: .normal)
        addressTxt.placeholder = "address".localized
        phoneNumberTxt.placeholder = "mobileNumber".localized
    }


    func addDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(), animated: false)
        let maxDate = "01-12-2003"
        let minDate = "01-12-1930"
        
        let dateFormatter = DateFormatter(withFormat: "dd-MM-yyyy", locale: "EN-EG")
        let maxD = dateFormatter.date(from: maxDate)
        let minD = dateFormatter.date(from: minDate)
        datePicker.maximumDate = maxD
        datePicker.minimumDate = minD
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
        //dateOfBirthTxt.text = maxDate
        dateOfBirthTxt.inputView = datePicker
    }
    
    
    @objc func valueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter(withFormat: "dd-MM-yyyy", locale: "EN-EG")
        let selectedDate = dateFormatter.string(from: sender.date)
        dateOfBirthTxt.text = selectedDate
    }
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        guard !(addressTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!, !(phoneNumberTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! else {
            self.presenter?.emptyFieldsError()
            return
        }
        
        
        
        var param = [
            "FNAME": presenter?.firstName,
            "MNAME": presenter?.middleName,
            "LNAME": presenter?.lastName,
            "NATID": presenter?.nationalID,
            "MSISDN": phoneNumberTxt.text,
            "ADDRESS": addressTxt.text
            ]
        param["TYPE"] = "RSUBREGKYCREQ"
        
        Util.debugMsg(param)
        presenter?.registerTapped(userData: param as! [String : String])
        
    }
}
