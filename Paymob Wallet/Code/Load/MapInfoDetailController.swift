//
//  MapInfoDetailController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 11/21/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class MapInfoDetailController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "mapInfo".localized
    }
}
