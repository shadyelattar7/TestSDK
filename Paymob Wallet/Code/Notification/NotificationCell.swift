//
//  NotificationCell.swift
//  Paymob Wallet
//
//  Created by mahmoud on 9/26/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var actionDate: UILabel!
    @IBOutlet weak var message: UILabel!
    
    //@IBOutlet weak var typeImageView: UIImageView!
    
    func updateCell(notification: Notification)  {
        action.text = notification.data.type
        
        //for audi changes
        
//        if notification.data.type == "P2P" {
//            typeImageView.image = #imageLiteral(resourceName: "bills")
//        } else if notification.data.type == "VCN" {
//            typeImageView.image = #imageLiteral(resourceName: "VCN")
//        } else if notification.data.type == "ATM OPERATIONS" {
//            typeImageView.image = #imageLiteral(resourceName: "bills")
//        } else if notification.data.type == "CONSUMER_PULL" {
//            typeImageView.image = #imageLiteral(resourceName: "bills")
//        } else {
//            typeImageView.image = #imageLiteral(resourceName: "bills")
//        }
        
        actionDate.text = notification.data.dateTime
        message.text = notification.data.message
        if notification.read == false {
            self.backgroundColor = UIColor.AppColor.OffWhiteBackground
//            self.accessoryView = UIImageView(image: UIImage(named: "circle"))
        } else {
            self.backgroundColor = UIColor.white
//            self.accessoryView = nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
