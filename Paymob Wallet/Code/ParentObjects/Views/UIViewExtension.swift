//
//  UIViewExtension.swift
//  RevoxTv
//
//  Created by Ahmed Aldaly on 8/1/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    enum States {
        case primary
        case secondry
    }
    
//    @IBInspectable var state: States{
//        return .primary
//    }
    
    var settings:Settings{
       // let appDelegagte = UIApplication.shared.delegate as! AppDelegate
        return EntryPoint.settings!
        
    }
    
    func makeRound(){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
        self.layer.borderWidth = 0;
    }


    func addBackground(view:UIImageView) {
        // screen width and height:
        
        let imageViewBackground = view
        imageViewBackground.image = ImageProvider.image(named: "bg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    func addBottomBar(color:UIColor, thickness: CGFloat){
        let bar = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.maxY - thickness, width: self.bounds.width, height: thickness))
        bar.backgroundColor = color
        self.addSubview(bar)
        self.bringSubviewToFront(bar)
    }

    
   
}

class PayMobView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.backgroundColor = self.settings.primaryColor
        self.backgroundColor = UIColor.white
    }
}

