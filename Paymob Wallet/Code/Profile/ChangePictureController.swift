//
//  ChangePictureController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 7/17/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import ImagePicker

class ChangePictureController: PayMobViewController, ImagePickerDelegate {
    
    @IBOutlet weak var saveBtn: PaymobUIButton!
    @IBOutlet weak var manImageView: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var changePicLb: UILabel!
    @IBOutlet weak var changeNameLb: UILabel!
    @IBOutlet weak var changeNameTF: PaymobUITextField!
    @IBOutlet weak var changeMailLb: UILabel!
    @IBOutlet weak var changeMailTF: PaymobUITextField!
    
    
    var image: UIImage?
    var presenter: ProfilePresenter?
    let imagePicker = ImagePickerController()
    var imageChanged = false
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        initVC()
        changeNameTF.delegate = self
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        self.presenter?.addBarButtons(vc: self)
        self.manImageView.makeRound()
        self.selectedImage.makeRound()
        self.manImageView.contentMode = .scaleAspectFit
        self.selectedImage.contentMode = .scaleAspectFit

        if (presenter?.localManager?.userExist)! {
            if let imageData = presenter?.localManager?.user?._image {
                selectedImage.image = UIImage(data: imageData)
            }
        }
    }
    
    func localization(){
        navigationItem.title = "ProfileEdit".localized
        changePicLb.text = "changePic".localized
        changeNameLb.text = "profileName".localized
        changeMailLb.text = "profileMail".localized
        saveBtn.setTitle("save".localized, for: .normal)
    }
    
    func initVC(){
        if self.presenter!.localManager!.userExist {
            if self.presenter?.userManager.user?._name == "My Name" {
                self.name = "myName".localized
            } else {
                self.name = (self.presenter?.userManager.user?._name)!
            }
            self.changeNameTF.text = self.name
        }
        
        if let mail = self.presenter?.email, !mail.isEmpty {
            self.changeMailTF.text = self.presenter?.email
        } else {
            self.changeMailTF.text = "-------"
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if (presenter?.userManager.userExist)! {
            presenter?.userManager.save(saveCall: { (user) in
                if let newImage = image {
                    let imageData = newImage.jpegData(compressionQuality: 0.9)
                    user._image = imageData
                }
                
                if (self.changeNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                    
                } else {
                    user._name = self.changeNameTF.text!
                }
            })
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selctImageTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
        print("Tapped")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        image = images[0]
        self.selectedImage.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        imageChanged = true
        saveBtn.enableBtn()
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        image = images[0]
        self.selectedImage.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        imageChanged = true
        saveBtn.enableBtn()
    }
}

extension ChangePictureController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count == 0{
            saveBtn.disableBtn()
        }else{
            saveBtn.enableBtn()
        }
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if (updatedText == name){
                saveBtn.disableBtn()
            }
        }
        return true
    }
}
