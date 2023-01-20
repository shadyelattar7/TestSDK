//
//  CustomAlertController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 5/8/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class CustomAlertController: UIViewController {
    
    var tapped = BehaviorSubject<Bool>(value: false)

    var titleString: String?
    var bodyString: String?
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("close".localized, for: .normal)
        bodyTextView.textContainer.maximumNumberOfLines = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
        bodyTextView.text = bodyString
        imageView.image = image
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.tapped.onNext(true)
        })
    }
}
