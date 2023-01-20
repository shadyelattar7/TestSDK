//
//  cashoutOtpViewController.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 26/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit
import SVPinView

class CashoutOtpController: PayMobViewController{
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var cashoutOtpTitle: UILabel!
    @IBOutlet weak var cashoutOtpSubTitle: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var willExpireInLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var count = 5*60
    var presenter: CashoutPresenter?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        self.initVC()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        presenter?.addBarButtons(vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pinView.pastePin(pin: (self.presenter?.OTP)!)
    }
    
    func localization(){
        cashoutOtpTitle.text = "cashoutOtpTitle".localized
        cashoutOtpSubTitle.text = "cashoutOtpSubTitle".localized
        willExpireInLabel.text = "willExpireIn".localized
        self.navigationItem.title = presenter?.type
    }
    
    func initVC(){
        pinView.pinLength = 6
        pinView.interSpace = 5
        pinView.textColor = UIColor.black
        pinView.shouldSecureText = false
        pinView.style = .none

        pinView.borderLineColor = UIColor.black
        pinView.activeBorderLineColor = UIColor.lightGray
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 3

        pinView.font = UIFont.systemFont(ofSize: 32)
        pinView.keyboardType = .phonePad
        pinView.keyboardAppearance = .default
        pinView.isUserInteractionEnabled = false
    }
    
    @objc func update() {
        if(count > 0) {
            timeLabel.text = timeFormatted(count)
            count -= 1
        }else{
            timer?.invalidate()
            timer = nil
            self.presenter!.goToTimeOutVC()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
}
