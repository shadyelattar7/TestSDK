//
//  UIView.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 04/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
    }
}

class dashedView: UIView{
    
    override func awakeFromNib() {
        let color = UIColor.AppColor.ButtonBackgroundValidGreen?.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let frameWidth = UIScreen.main.bounds.width - 32
        let shapeRect = CGRect(x: 0, y: 0, width: frameWidth, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameWidth/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 16).cgPath
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
}

extension UIView {
    func setBorder(borderWidth: CGFloat = 1,
                   color: UIColor = UIColor.systemRed,
                   cornerRadius: CGFloat = 12) {
        layer.cornerRadius = cornerRadius
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    
    func addShadow(color: UIColor, alpha: CGFloat, xValue: CGFloat, yValue: CGFloat, blur: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = Float(alpha)
        self.layer.shadowOffset = CGSize(width: xValue, height: yValue)
        self.layer.shadowRadius = blur/2
    }
    
    func addViewWithAnimation(animationDuration: TimeInterval = 0.3) {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func removeViewWithAnimation(animationDuration: TimeInterval = 0.3) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    // MARK: - Nib Identifier
    // Note: The Nib Assigned name must match it's class ViewModel
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
