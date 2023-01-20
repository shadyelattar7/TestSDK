//
//  QrDetailsController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 5/28/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class NotificationQrDetailsController: InactivateController {
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: PaymobUIButton!
    @IBOutlet weak var tableView: UITableView!
    var presenter: NotificationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        if presenter?.currentNoti?.read == false {
            guard let date = presenter?.currentNoti?.data.preFormattedDate else { return }
            presenter?.setNotification(dateTime: date, action: .read)
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "scanDetails".localized
        acceptBtn.setTitle("accept".localized, for: .normal)
        cancelBtn.setTitle("reject".localized, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        for value in (presenter?.qrDataValues)! {
            if value == "***" {
                Util.debugMsg("not complete")
                presenter?.isQrDataComplete = false
                break
            }
            presenter?.isQrDataComplete = true
        }
        if (presenter?.isQrDataComplete)! {
            presenter?.qrUpdatedData()
            presenter?.generateQRFinalDicAndAmount()
            presenter?.pay(amount: presenter?.qrFinalAmount, orderNumber: "0", ref1: presenter?.currentNoti?.data.r2PData?["REF1"], ref2: presenter?.currentNoti?.data.r2PData?["REF2"])
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NotificationQrDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.qrDataKeys?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QrDetailCell
        cell?.keyLabel.text = self.presenter?.qrDataKeys?[indexPath.item]
        if let isEntered = presenter?.isQrDataEntered?[indexPath.row] {
            if isEntered {
                cell?.valueLabel.isHidden = true
                cell?.valueTextField.isHidden = false
                //cell?.valueTextField.keyboardType = (presenter?.keyboardType?[indexPath.row])!
                cell?.initCell(keyboardType: (presenter?.keyboardType![indexPath.row])!, indexPath: indexPath)
            } else {
                cell?.valueLabel.isHidden = false
                cell?.valueLabel.text = self.presenter?.qrDataValues?[indexPath.item]
                cell?.valueTextField.isHidden = true
            }
        }
        cell?.valueTextField.rx.text.asObservable().subscribe(onNext: { (str) in
            //if (str?.characters.count)! > 0  {
            if !(cell?.valueTextField.isHidden)!  {
                self.presenter?.qrDataValues?[indexPath.item] = str!
            }
        }).disposed(by: disposeBag)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}





