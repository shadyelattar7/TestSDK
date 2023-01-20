//
//  FavBillCell.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/7/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class FavBillCell: UITableViewCell {
    
    @IBOutlet weak var billRefLabel: UILabel!
    @IBOutlet weak var billRefValue: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    
    @IBOutlet weak var billNameLabel: UILabel!
    @IBOutlet weak var billNameValue: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    
    @IBOutlet weak var amountStackView: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        accessoryType = selected ? .checkmark : .none
    }

}
