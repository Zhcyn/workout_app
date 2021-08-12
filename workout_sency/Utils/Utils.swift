//
//  Utils.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation
import UIKit

class Utils {
    
    static func roundedBtnCorners(button: UIButton, radius: CGFloat = 5) {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
    }
}
