//
//  DetailNotificationViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 9/26/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class DetailNotificationViewController: PayMobViewController {
    
    @IBOutlet weak var typeStack: UIStackView!
    @IBOutlet weak var dateStack: UIStackView!
    @IBOutlet weak var amountStack: UIStackView!
    @IBOutlet weak var dueDateStack: UIStackView!
    @IBOutlet weak var merStack: UIStackView!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    @IBOutlet weak var typeLb: UILabel!
    @IBOutlet weak var typeValue: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var merLb: UILabel!
    @IBOutlet weak var merValue: UILabel!
    @IBOutlet weak var dueDateLb: UILabel!
    @IBOutlet weak var dueDateValue: UILabel!
    @IBOutlet weak var messageLb: UILabel!
    @IBOutlet weak var messageValue: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var rateAndFeedback: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    var presenter: NotificationPresenter?
    var notification: Notification?
    
    func localization() {
        self.navigationItem.title = "notification".localized
        self.typeLb.text = "type".localized
        self.dateLb.text = "date".localized
        self.merLb.text = "merchant".localized
        self.dueDateLb.text = "dueDate".localized
        self.messageLb.text = "message".localized
        self.amountLb.text = "amount".localized
        self.cancelBtn.setTitle("cancel".localized, for: .normal)
        self.acceptBtn.setTitle("accept".localized, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.presenter?.addBarButtons(vc: self)
//        presenter?.currentNotification.asObservable().subscribe(onNext: { (notification) in
//            self.notification = notification
//        }).disposed(by: self.disposeBag)
//        //Util.debugMsg(notification?.data.amount)
//        if self.notification?.read == false {
//            self.presenter?.setNotification(dateTime: (notification?.data.preFormattedDate)!, action: .read)
//        }
        
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        print("notification data \(notification?.data.message)")
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        
        
        self.typeValue.text = self.notification?.data.type
        self.dateValue.text = self.notification?.data.dateTime
        self.messageValue.text = self.notification?.data.message
        
        
        
        switch (notification?.data.type)! {
        case "CONSUMER_PULL":
            self.amountValue.text = self.notification?.data.amount
            self.merLb.text = "biller".localized
            self.merValue.text = self.notification?.data.billerName
            self.dueDateValue.text = self.notification?.data.dueDate
            self.editBtn.isHidden = true
            
        case "BILLER_PUSH":
            self.amountValue.text = self.notification?.data.amount
            self.merLb.text = "biller".localized
            self.merValue.text = self.notification?.data.billerName
            self.dueDateStack.isHidden=true
            self.editBtn.isHidden = true
            
        case "CASHOUT PRESENTMENT INQUIRY":
            self.amountValue.text = self.notification?.data.amount
            self.merStack.isHidden = true
            self.dueDateStack.isHidden=true
            self.editBtn.isHidden = true
            self.buttonsStack.isHidden = false
            
        case "CASH IN PRESENTMENT":
            self.amountValue.text = self.notification?.data.amount
            self.merStack.isHidden = true
            self.dueDateStack.isHidden=true
            self.editBtn.isHidden = true
            self.buttonsStack.isHidden = false
            
        default:
            self.buttonsStack.isHidden = true
            self.dueDateStack.isHidden = true
            self.merStack.isHidden = true
            self.editBtn.isHidden = true
            self.amountStack.isHidden = true
            validateRate()
        }
    }
    
    func validateRate(){
        let service = self.notification?.data.SERVICE_RATING_ENABLED
        let rateButton = presenter?.requestRateButton()
        if (rateButton == true  && service == true){
            rateAndFeedback.isHidden = false
        }
        else{
            rateAndFeedback.isHidden = true
        }
    }
    func showSetRateView(TXNID :String){

        if #available(iOS 13.0, *) {
            let rateView = RateRouter(TXNID: TXNID)
            
            UIView.transition(with: (self.navigationController?.view)!, duration: 0.50, options: [.transitionCrossDissolve], animations: {
                self.navigationController?.addChild(rateView.viewController)
                self.navigationController?.view.addSubview(rateView.viewController.view)
            }, completion: nil)
        } else {
            // Fallback on earlier versions
        }

       
    }
    @IBAction func rateAndFeedbackAction(_ sender: Any) {
//        presenter?.rateAndFeedBackTapped()
        showSetRateView(TXNID: self.notification?.data.TXNID ?? "")
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        switch (notification?.data.type)! {
        case "CONSUMER_PULL":
            presenter?.billPaymentAcceptClicked(notification: notification!)
        case "BILLER_PUSH":
            presenter?.billPaymentAcceptClicked(notification: notification!)
        case "CASHOUT PRESENTMENT INQUIRY":
            presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
                self.presenter?.cashoutAcceptClicked(pin: pin, notification: self.notification!, vc: self)
            }).disposed(by: disposeBag)
        case "CASH IN PRESENTMENT":
            presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
                self.presenter?.cashInAcceptClicked(pin: pin, notification: self.notification!, vc: self)
            }).disposed(by: disposeBag)
        default:
            break
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        switch (notification?.data.type)! {
        case "CASHOUT PRESENTMENT INQUIRY":
            presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
                self.presenter?.cashoutCancelClicked(pin: pin, notification: self.notification!, vc: self)
            }).disposed(by: disposeBag)
        case "CASH IN PRESENTMENT":
            presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
                self.presenter?.cashInCancelClicked(pin: pin, notification: self.notification!, vc: self)
            }).disposed(by: disposeBag)
            
        default:
            presenter?.goBack(vc: self)
            break
        }
    }
}
