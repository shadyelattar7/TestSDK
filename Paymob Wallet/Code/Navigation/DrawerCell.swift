//
//  DrawerCell.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/6/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var noteNo: UILabel!
    
    var cellIdentifier: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //noteNo.makeRound()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
