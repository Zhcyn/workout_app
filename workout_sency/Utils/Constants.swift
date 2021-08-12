//
//  Constants.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation
import UIKit

struct Design {
    static func defaultFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DIN Alternate", size: size)!
    }
    //colors
    static let blackColor = UIColor.black
    static let whiteColor = UIColor.white
    static let lightPinkBtnColor = UIColor(hex: "#F9DAEB")
    static let darkPinkBtnColor = UIColor(hex: "#EC509E")
}

struct Constants {
    static let pauseStr = "PAUSE"
    static let resumeStr = "RESUME"
    static let restStr = "REST"
    static let summaryStr1 = "Not bad, try harder next time!" //0-30%
    static let summaryStr2 = "Well done, you nailed it!" //30-60%
    static let summaryStr3 = "Champion, it's too easy for you!" //60-100%
}
