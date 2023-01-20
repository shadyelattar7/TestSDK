//
//  CustomAlertWithTwoController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 10/22/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class CustomAlertWithTwoController: UIViewController {
    
    var tapped = PublishSubject<Bool>()
    
    var titleString: String?
    var bodyString: String?
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitle("confirmBtn".localized, for: .normal)
        cancelButton.setTitle("cancel".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
        bodyTextView.text = bodyString
        imageView.image = image
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        tapped.onNext(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        tapped.onNext(false)
        self.dismiss(animated: true, completion: nil)
    }
}
