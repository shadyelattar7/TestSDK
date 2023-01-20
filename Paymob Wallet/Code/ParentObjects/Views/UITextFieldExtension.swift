//
//  UITextViewExtension.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    //    @objc override func makeRound(){
    //        self.layer.cornerRadius = self.frame.size.height/2;
    //        self.layer.masksToBounds = true;
    //        self.layer.borderWidth = 0;
    //    }
    func fontStyle(){
        self.textColor = UIColor.white
        //TODO:: add the needed font
    }
    
    
    var amountTrim : String {
        var numSections = self.text!.components(separatedBy: ".")
        
        if numSections.count > 2{
            numSections.removeLast(numSections.count - 1)
        }
        
        if let num = numSections.first{
            if num.count > 6{
                numSections[0] = "\(num.dropLast())"
            }
        }
        
        
        if let num = numSections.last, numSections.count > 1{
            if num.count > 2{
                numSections[1] = "\(num.dropLast())"
            }
        }
        
        return numSections.joined(separator: ".")

    }
    
}


class PaymobUITextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBottomBorder(color: self.settings.bottomBarColor, thickness: 1.0)
        self.font =  UIFont(name: "Helvetica-Neue", size: 15)
        addDoneButtonOnKeyboard()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        addBottomBar(color: self.settings.bottomBarColor, thickness: 1.0)
        self.font =  UIFont(name: "Helvetica-Neue", size: 15)
        addDoneButtonOnKeyboard()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomBorder(color: self.settings.bottomBarColor, thickness: 1.0)
        alert.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bar.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY - 3, width: UIScreen.main.bounds.width - 40, height: 1.0)
     //   alertView.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY - 3, width: UIScreen.main.bounds.width - 40, height: 24.0)
        alert.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY , width: UIScreen.main.bounds.width - 40, height: 24)
    }
    
    
    // MARK: - Custom bar
    
    private lazy var bar = UIView()
    func addBottomBorder(color:UIColor, thickness: CGFloat){
        bar = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.maxY - 3, width: UIScreen.main.bounds.width - 32, height: thickness))
        self.clipsToBounds = false
        bar.clipsToBounds = false
        bar.backgroundColor = color
        self.addSubview(bar)
        self.bringSubviewToFront(bar)
        self.alertConfiguration()
    }
    
    // MARK: - Custom alert
    
    private lazy var alertView = UIView()
    private lazy var alert = UILabel()
    private func alertConfiguration(){
//        alertView = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.maxY , width: UIScreen.main.bounds.width, height: 24))
//        alertView.clipsToBounds = true
//        alertView.backgroundColor = .clear
        
        alert = UILabel(frame: CGRect(x: self.bounds.minX, y: self.bounds.maxY , width: UIScreen.main.bounds.width, height: 24))
        alert.text = "custom alert"
        alert.font = UIFont.systemFont(ofSize: 12)
        alert.textColor = .red
//        alertView.addSubview(alert)
        self.addSubview(alert)
        
        
        
    }
    
    //MARK: - Alert configuration
    
    func configureAlert(message: String, textColor: UIColor = UIColor.AppColor.LabelRed!){
        
        if message == ""{
            alert.isHidden = true
            self.rightViewMode = UITextField.ViewMode.never
            bar.backgroundColor = self.settings.bottomBarColor
            return
        }
        alert.isHidden = false
        alert.text = message
        alert.textColor = textColor
        bar.backgroundColor = textColor
        
        // I need to check on language
        addRightImageTF()
    }
    
    // MARK: - Add Icon in right textFiled
    
    private func addRightImageTF(){
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        let image = ImageProvider.image(named: "ic_filled_infocircle")
        imageView.image = image
        self.rightView = imageView
    }
    
    
    // MARK: - Add Icon in left textFiled
    
    private func addLeftImageTF(){
        self.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        let image = ImageProvider.image(named: "ic_filled_infocircle")
        imageView.image = image
        self.leftView = imageView
    }
    
    
    
    
    func addDoneButtonOnKeyboard() {
        let window = UIApplication.shared.keyWindow
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: (window?.bounds.width)!, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        var items = [UIBarButtonItem]()
        //items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}


extension UITextView{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

