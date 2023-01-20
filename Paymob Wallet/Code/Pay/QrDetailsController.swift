//
//  QrDetailsController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 5/28/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class QrDetailsController: PayMobViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: PaymobUIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var presenter: PayPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.presenter?.addBarButtons(vc: self)
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "scanDetails".localized
        titleLabel.text = "scanDetails".localized
        acceptBtn.setTitle("accept".localized, for: .normal)
        cancelBtn.setTitle("reject".localized, for: .normal)
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
            print("\n\nHERE\n\n")
            Util.debugMsg(presenter?.qrReDataArr)
            Util.debugMsg(presenter?.qrFinalDataDic)
            presenter?.pay(amount: presenter?.qrFinalAmount, merchantNumber: "0", isFromNewQR: true, extraParameterName: presenter?.qrExtraParameterName, extraParameterValue: presenter?.qrExtraParameterValue)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension QrDetailsController: UITableViewDelegate, UITableViewDataSource {
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





