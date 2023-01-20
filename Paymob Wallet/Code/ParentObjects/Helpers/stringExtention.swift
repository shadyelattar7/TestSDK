//
//  stringExtention.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/22/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation

extension String {

    
    // cleans mobile number form space  and )( . -
    func getOnly(charSet:CharacterSet) -> String {
        let sections = self.components(separatedBy: charSet.inverted)
        return sections.joined(separator:"")
    }
    
    func vCardFormate() -> String{
        var final = self
        final.insert(" ", at: self.index(self.startIndex, offsetBy: 4))
        final.insert(" ", at: self.index(self.startIndex, offsetBy: 9))
        final.insert(" ", at: self.index(self.startIndex, offsetBy: 14))
        
        return final
    }
    
    func vCardValidFormate() -> String {
        var final = self
        final = self.substring(to: final.index(final.startIndex, offsetBy: 2))
        final.append("/")
        final = self.substring(to: final.index(final.endIndex, offsetBy: -2))
        
        return final
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
