//
//  HistoryCell.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var dateLb: PaymobUILabel!
    @IBOutlet weak var typeLb: PaymobUILabel!
    @IBOutlet weak var nameLb: PaymobUILabel!
    @IBOutlet weak var transactionNumberLabel: UILabel!
    
    @IBOutlet weak var moneyLb: PaymobUILabel!
    @IBOutlet weak var egpLb: PaymobUILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func updateCell(history: History) {
        moneyLb.text = "\(history.amount)"
        dateLb.text = history.time
        typeLb.text = history.type
        transactionNumberLabel.text = "\("transactionID".localized): \(history.txnId)"
        //for audi changes
        /*
        if history.type == "P2P" {
            typeLb.text = "Transfer"
        } else if history.type == "VCN" {
            typeLb.text = "Virtual Card Number"
        } else if history.type == "ATM OPERATIONS" {
            typeLb.text = "One Time Password (OTP)"
        } else if history.type == "CONSUMERPULL" {
            typeLb.text = "Bill Inquiry"
        } else {
            typeLb.text = history.type
        }
 */
        nameLb.text = history.fromTo
        nameLb.isHidden = true
        if history.isRecieved == true {
//            recieveImageView.image = UIImage(named: "recieve")
        } else {
//            recieveImageView.image = UIImage(named: "Sent")
        }
        
        Util.debugMsg(history.status)
        
        if history.status == "NOT-PERFORMED-YET" || history.status == "PENDING" || history.status == "UNDER_PROCESSING" {
            statusLabel.text = "pending".localized
            statusLabel.backgroundColor = UIColor.AppColor.LabelLightRedBackground
            statusLabel.textColor = UIColor.AppColor.LabelRed
        } else if history.status == "SUCCESSFUL" {
            statusLabel.text = "successfull".localized
            statusLabel.backgroundColor = UIColor.AppColor.LabelLightGreenBackground
            statusLabel.textColor = UIColor.AppColor.LabelGreen
        } else {
            statusLabel.text = "failure".localized
            statusLabel.backgroundColor = UIColor.AppColor.LabelLightRedBackground
            statusLabel.textColor = UIColor.AppColor.LabelRed

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        egpLb.text = "egp".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
