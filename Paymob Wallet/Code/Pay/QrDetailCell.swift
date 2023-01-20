//
//  QrDetailCell.swift
//  Paymob Wallet
//
//  Created by mahmoud on 5/28/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class QrDetailCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    var keyboardType: UIKeyboardType = .decimalPad
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func initCell(keyboardType: UIKeyboardType, indexPath: IndexPath) {
        self.keyboardType = keyboardType
        valueTextField.keyboardType = self.keyboardType
        self.indexPath = indexPath
        if let _ = self.indexPath, self.keyboardType == .decimalPad {
            valueTextField.delegate = self
        } else {
            valueTextField.delegate = nil
        }
    }
}

extension QrDetailCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}
