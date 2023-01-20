//
//  ServiceInfoDetailsViewController.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit

class ServiceInfoDetailsViewController: InactivateController {
    
    @IBOutlet weak var stackViewMoreInfo: UIStackView!
    @IBOutlet weak var serviceInfoContext: UILabel!
    var presenter: ServiceInfoPresenter?
    var serviceInfoDetails : ServiceInfoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = serviceInfoDetails?.name
        serviceInfoContext.text = serviceInfoDetails?.content_text
        guard !(serviceInfoDetails?.url ?? "").isEmpty else{
            stackViewMoreInfo.isHidden = true
            return
        }
        
    }


    @available(iOS 10.0, *)
    @IBAction func moreInfo(_ sender: Any) {
        if let url = serviceInfoDetails?.url{
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
            
        }
    }
}
