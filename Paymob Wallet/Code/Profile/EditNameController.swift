//
//  EditNameController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 7/17/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class EditNameController: PayMobViewController {
    @IBOutlet weak var modifyNameLabel: UILabel!
    var presenter: ProfilePresenter?
    
    @IBOutlet weak var acceptBtn: PaymobUIButton!
    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var enterYoutNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)

        navigationItem.title = "modifyName".localized
        modifyNameLabel.text = "modifyName".localized
        enterYoutNameLabel.text = "enterYourName".localized
        acceptBtn.setTitle("confirmBtn".localized, for: .normal)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        if (presenter?.userManager.userExist)! {
            presenter?.userManager.save(saveCall: { (user) in
//                if let newImage = image {
//                    let imageData = UIImageJPEGRepresentation(newImage, 0.9)
//                    user._image = imageData
//                }
                
                if (self.newNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                    
                } else {
                    user._name = self.newNameTextField.text!
                }
                
            })
        }
        self.navigationController?.popViewController(animated: true)
    }
}
