//
//  Extension.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation
import UIKit

public typealias RawJsonFormat = [String: Any]

extension UIColor {
    convenience init?(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        if #available(iOS 13, *) {
            //If your string is not a hex colour String then we are returning white color. you can change this to any default colour you want.
            guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return nil }
            
            let a, r, g, b: Int32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
            
        } else {
            var int = UInt32()
            
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        }
    }
}

extension UIButton {
    public func roundBtn(borderColor: CGColor = UIColor.black.cgColor) {
        self.layer.cornerRadius = frame.height/2
        layer.borderWidth = 1
        layer.borderColor = borderColor
    }
    public func roundBtn(radius: CGFloat, borderColor: CGColor = UIColor.black.cgColor) {
        self.layer.cornerRadius = radius
        layer.borderWidth = 1
        layer.borderColor = borderColor
    }
}

extension UIButton {
    func changeColorAnim(backgroundColor: UIColor, fontColor: UIColor) {
        let currentBackColor = self.backgroundColor
        let currentFontColor = self.titleLabel?.textColor
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.backgroundColor = backgroundColor
            self.setTitleColor(fontColor, for: .normal)
        }, completion:nil )
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.backgroundColor = currentBackColor
            self.setTitleColor(currentFontColor, for: .normal)
        }, completion:nil )
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
