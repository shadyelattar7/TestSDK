//
//  ConfirmationViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ConfirmationViewController: PayMobViewController {

    var presenter:ConfirmationPresenter?
    var confirmDispose = DisposeBag()
    
    //Title  View
    @IBOutlet weak var TitleViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelCenterY: NSLayoutConstraint!
    @IBOutlet weak var titleBackCenterY: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    
    //Status View
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusBackBtn: UIButton!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusSubTitle: UILabel!
    
    //Recepient View
    @IBOutlet weak var recepientInfoView: UIView!
    @IBOutlet weak var recepientLabel: UILabel!
    @IBOutlet weak var recepientSubLabel: UILabel!
    @IBOutlet weak var recipientInfoTitle: UILabel!
    @IBOutlet weak var recipientIcon: UIImageView!
    
    
    @IBOutlet weak var saveToFavBtn: PaymobUIButton!

    @IBOutlet weak var tahweelImageView: UIImageView!
    
    //VCN View
    @IBOutlet weak var vcnView: UIView!
    @IBOutlet weak var vcnTitle: UILabel!
    @IBOutlet weak var vcnNumberLabel: UILabel!
    @IBOutlet weak var vcnNumberValue: UILabel!
    @IBOutlet weak var vcnExpiryLabel: UILabel!
    @IBOutlet weak var vcnExpiryValue: UILabel!
    @IBOutlet weak var vcnCvvLabel: UILabel!
    @IBOutlet weak var vcnCvvValue: UILabel!
    
    
    //Transaction Info View
    @IBOutlet weak var transactionDetailsTitle: UILabel!
    
    @IBOutlet weak var transactionTypeView: UIView!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var transactionTypeValue: UILabel!
    
    @IBOutlet weak var installementServiceProviderView: UIView!
    @IBOutlet weak var installementServiceProviderLabel: UILabel!
    @IBOutlet weak var installementServiceProviderValue: UILabel!
    
    @IBOutlet weak var NationalIdView: UIView!
    @IBOutlet weak var NationalIdLabel: UILabel!
    @IBOutlet weak var NationalIdValue: UILabel!
    
    @IBOutlet weak var extraParameterView: UIView!
    @IBOutlet weak var extraParameterName: UILabel!
    @IBOutlet weak var extraParameterValue: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var feesAmount: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    
    //Message View (if send)
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    //Transaction Response View
    @IBOutlet weak var transactionResponseInfoView: UIView!
    @IBOutlet weak var transactionResponseInfoTitle: UILabel!
    @IBOutlet weak var transactionResponseInfoTimeLabel: UILabel!
    @IBOutlet weak var transactionResponseInfoTimeValue: UILabel!
    @IBOutlet weak var transactionResponseInfoTxnLabel: UILabel!
    @IBOutlet weak var transactionResponseInfoTxnValue: UILabel!
    @IBOutlet weak var transactionResponseInfoReferenceLabel: UILabel!
    @IBOutlet weak var transactionResponseInfoReferenceValue: UILabel!
    
    
    func localization() {
        self.titleLabel.text = "reviewTransaction".localized
        self.recipientInfoTitle.text = "recepientInfoHeaderSend".localized
        self.transactionDetailsTitle.text = "transactionDetails".localized
        self.transactionTypeLabel.text = "transactionType".localized
        self.amountLabel.text = "transactionAmount".localized
        self.feesLabel.text = "transactionFees".localized
        self.totalAmountLabel.text = "transactionTotalAmount".localized
        continueBtn.setTitle("continue".localized, for: .normal)
        
        messageTitleLabel.text = "messageLabel".localized
        transactionResponseInfoTitle.text = "transactionResponseInfo".localized
        transactionResponseInfoTimeLabel.text = "transactionResponseInfoTime".localized
        transactionResponseInfoTxnLabel.text = "transactionResponseInfoTxn".localized
        transactionResponseInfoReferenceLabel.text = "transactionResponseInfoReference".localized
        NationalIdLabel.text = "profileNationalID".localized
        installementServiceProviderLabel.text = "serviceProvider".localized
        
        self.vcnTitle.text = "vcnInfo".localized
        self.vcnNumberLabel.text = "vcnNumber".localized
        self.vcnExpiryLabel.text = "vcnExpiry".localized
        self.vcnCvvLabel.text = "CVV"
    }
    
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 30, height: confirmationSlide.frame.height)
            //confirmationSlide.frame
        
        let angle = 45*CGFloat.pi/180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        //view.layer.addSublayer(gradientLayer)
        confirmationSlide.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -confirmationSlide.frame.width
        animation.toValue = confirmationSlide.frame.width
        animation.repeatCount = Float.infinity
        animation.duration = 2
        gradientLayer.add(animation, forKey: "key")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.keyBoard(withPush: false)
        
        // check for custom navigation view
        if UIDevice.hsNotch{
            TitleViewHeightConst.constant = 104
            titleLabelCenterY.constant = 17
            titleBackCenterY.constant = 17
        }else{
            TitleViewHeightConst.constant = 80
            titleLabelCenterY.constant = 0
            titleBackCenterY.constant = 0
        }
        
        saveToFavBtn.isHidden = true
        saveToFavBtn.backgroundColor = .white
        self.saveToFavBtn.addTarget(self, action: #selector(checkBoxAction), for: .touchUpInside)
        if self.presenter?.transaction.title == "payBill".localized {
            //self.presenter?.showAlertToSaveBill()
            self.saveToFavBtn.isHidden = true
            
        } else {
            saveToFavBtn.isHidden = true
        }
       
        if self.presenter?.transaction.title == "pay".localized || presenter?.transaction.title == "cashout".localized{
//            tahweelImageView.isHidden = false
        } else {
//            tahweelImageView.isHidden = true
        }
        
        print("\n\nConfirmation Cases\n")
        switch self.presenter?.transaction.title {
        
        case "send".localized:
            print("send")
            transactionIsSend()
        case "pay".localized:
            print("pay")
            transactionIsPay()
        case "vcn".localized:
            print("VCN")
            transactionIsVCN()
        case "cashout".localized:
            print("cashout")
            transactionIsCashInOrOut()
        case "cashin".localized:
            print("cashin")
            transactionIsCashInOrOut()
        case "payBill".localized:
            print("Bill Installement")
            transactionIsBillInstallement()
        default:
            print("\n\nPage Title:\n\(self.presenter?.transaction.title)")
            self.presenter?.toWhom?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
        }
       
/*
        swipGesture.rx.event.subscribe(onNext: { (swip) in
            /// for credit card payment
//            if self.presenter?.transaction.type == "P2M"{
//            self.present((self.presenter?.showAliases())!, animated: true, completion: {
//                //self.presenter?.swipedReciet()
//            })
//            } else {
//                self.presenter?.swipedReciet()
//            }
            self.presenter?.swipedReciet()
        }).disposed(by: disposeBag)
 */
        
        let str1 = ""
        self.presenter?.originalAmount?.subscribe(onNext: { (amount) in
            //str1 = NSLocalizedString("egp", comment: "egp")+" "+"\(amount)"+" + "

        }).disposed(by: disposeBag)
        
        
        self.presenter?.title?.bind(to: self.transactionTypeValue.rx.text).disposed(by: confirmDispose)
//        self.presenter?.toWhom?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)

        self.presenter?.totalAmount?.bind(to: self.totalAmountValue.rx.text).disposed(by: confirmDispose)
        self.presenter?.originalAmount?.bind(to: self.amountValue.rx.text).disposed(by: confirmDispose)
        self.presenter?.originalAmount?.bind(to: self.statusSubTitle.rx.text).disposed(by: confirmDispose)
        self.presenter?.fees?.subscribe(onNext: { (fees) in
//            self.totalAmount.text = "+\(fees)" + NSLocalizedString("forService", comment: "forService")
//            let str2 = NSLocalizedString("egp", comment: "egp")+" "+"\(fees)"
//            let str3 = " "+NSLocalizedString("forService", comment: "forService")
//            self.feesAmount.text = str1 + str2 + str3
            self.feesAmount.text = "\(fees) \("egp".localized)"
        }).disposed(by: confirmDispose)
        
        presenter?.title?.subscribe(onNext: { (title) in
            if title == "billInqiure".localized {
                self.feesAmount.isHidden = true
                self.feesLabel.isHidden = true
                self.totalAmountValue.isHidden = true
                self.totalAmountLabel.isHidden = true
            } else {
                self.feesAmount.isHidden = false
                self.feesLabel.isHidden = false
                self.totalAmountValue.isHidden = false
                self.totalAmountLabel.isHidden = false
            }
        }).disposed(by: confirmDispose)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.presenter?.closeConfirmation()
    }

    @IBAction func goToDashBoard(_ sender: Any) {
        NavigationPresenter.currentModule = "Dashboard"
        self.presenter?.closeConfirmation()
        presenter?.goToDashboard()
    }
    @objc func checkBoxAction(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            sender.setImage(ImageProvider.image(named: "unchecked"), for: .normal)
            Presenter.isFav = false
        }else {
            Presenter.isFav = true
            sender.isSelected = true
            sender.setImage(ImageProvider.image(named: "checked"), for: .normal)
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        self.presenter?.swipedReciet()
    }
    
    func transactionIsSend(){
        if (presenter?.transaction.name == ""){
            self.presenter?.toWhom?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
            self.recepientSubLabel.isHidden = true
        }else{
            self.presenter?.name?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
            self.presenter?.toWhom?.bind(to: self.recepientSubLabel.rx.text).disposed(by: confirmDispose)
        }
        
        if presenter?.transaction.msg != ""{
            messageView.isHidden = false
            self.presenter?.msg?.bind(to: self.messageLabel.rx.text).disposed(by: confirmDispose)
        }
    }
    
    func transactionIsPay(){
        print("\n\nTransaction name: \(self.presenter?.transaction.name)\n\n")
        recipientIcon.image = UIImage.init(named: "ConfirmationQRIcon")
        if (presenter?.transaction.name == ""){
            self.presenter?.toWhom?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
            self.recepientSubLabel.isHidden = true
        }else{
            self.presenter?.name?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
            self.presenter?.toWhom?.bind(to: self.recepientSubLabel.rx.text).disposed(by: confirmDispose)
        }
        if (presenter?.transaction.extraParameterName != nil){
            self.extraParameterView.isHidden = false
            self.extraParameterName.text = self.presenter?.transaction.extraParameterName
            self.extraParameterValue.text = self.presenter?.transaction.extraParameterValue
        }
//        self.presenter?.toWhom?.bind(to: self.recepientLabel.rx.text).disposed(by: confirmDispose)
//        self.recepientSubLabel.isHidden = true
    }
    
    func transactionIsCashInOrOut(){
        recepientInfoView.isHidden = true
    }

    func transactionIsBillInstallement(){
        statusView.isHidden = false
        progressBar.isHidden = true
        recepientInfoView.isHidden = true
        let url = URL(string: (presenter?.transaction.institution?.logo_url)!)!
        statusImage?.kf.setImage(with: url, placeholder: UIImage.init(named: "white_tasahel"))
        statusBackBtn.isHidden = true
        installementServiceProviderView.isHidden = false
        NationalIdView.isHidden = false
        NationalIdValue.text = self.presenter?.transaction.nationalID
        statusTitle.text = "installementValue".localized

        if EntryPoint.langId == "ar" {
//            statusTitle.text = self.presenter?.transaction.institution?.name_ar
            installementServiceProviderValue.text = self.presenter?.transaction.institution?.name_ar
        } else {
//            statusTitle.text = self.presenter?.transaction.institution?.name_en
            installementServiceProviderValue.text = self.presenter?.transaction.institution?.name_en
        }
        
        do{
            statusSubTitle.text = try presenter?.originalAmount?.value()
        }catch let error {
            print(error.localizedDescription)
        }
    }

    func transactionIsVCN(){
        recepientInfoView.isHidden = true
        transactionTypeView.isHidden = true
    }
    
    //MARK: - Handle Response Here
    func transactionFinished(response: Response){
        if (response.txn == "1056"){
            self.presenter!.router?.sweetAlertFail(message: response.msg, afterMsg: {})
            return
        }
        
        
        titleView.isHidden = true
        continueView.isHidden = true
        statusView.isHidden = false
        statusBackBtn.isHidden = false
        progressBar.isHidden = true
        
        transactionResponseInfoView.isHidden = false
        transactionResponseInfoTimeValue.text = response.dateTime
        transactionResponseInfoTxnValue.text = response.TXNID
        transactionResponseInfoReferenceValue.text = response.TRID
//        statusSubTitle.text = response.amount

        
        if (response.txn == "200"){
            statusView.backgroundColor = UIColor.AppColor.LabelLightGreenBackground
            statusImage.image = UIImage.init(named: "ConfirmationSuccess")
            statusTitle.text = "doneSuceesfully".localized + " " + (presenter?.transaction.title)!
            if presenter?.transaction.title == "pay installment".localized{
                
                statusTitle.text = "Pay installment successful".localized
            }
        }else{
            statusView.backgroundColor = UIColor.AppColor.LabelLightYellowBackground
            statusImage.image = UIImage.init(named: "ConfirmationError")
            statusTitle.text = "donefailed".localized + " " + (presenter?.transaction.title)!
//            statusSubTitle.text = ""
        }
        

    }
    
    func transactionFinished(response: VirtualCard){
        

        if (response.txn == "200"){
            titleView.isHidden = true
            continueView.isHidden = true
            statusView.isHidden = false
            statusBackBtn.isHidden = false
            progressBar.isHidden = true
            
            
            statusView.backgroundColor = UIColor.AppColor.LabelLightGreenBackground
            statusImage.image = UIImage.init(named: "ConfirmationSuccess")
            statusTitle.text = "doneSuceesfully".localized + " " + "pay".localized
//            statusSubTitle.text = response.amount
            
            transactionResponseInfoView.isHidden = false
            transactionResponseInfoTimeValue.text = response.dateTime
            transactionResponseInfoTxnValue.text = response.TXNID
            transactionResponseInfoReferenceValue.text = response.TXNID
            
            vcnView.isHidden = false
            vcnNumberValue.text = response.number
            vcnExpiryValue.text = response.expireDay
            vcnCvvValue.text = response.cvv
        }else{
            self.presenter!.router?.sweetAlertFail(message: response.msg!, afterMsg: {})

            
            statusView.backgroundColor = UIColor.AppColor.LabelLightYellowBackground
            statusImage.image = UIImage.init(named: "ConfirmationError")
            statusTitle.text = "donefailed".localized + " " + "generateCard".localized
            statusSubTitle.text = ""
        }
        

    }

}
