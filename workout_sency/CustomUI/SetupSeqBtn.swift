//
//  SetupSeqBtn.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 13/08/2021.
//

import UIKit

class SetupSeqBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBtn()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder) //TODO: explain in the paper why its necesary
        setupBtn()
    }
    
    override func layoutSubviews() { //TODO: explain
        super.layoutSubviews()
        roundBtn()
    }
    
    func setupBtn() {
        setTitleColor(Design.blackColor, for: .normal)
        backgroundColor = Design.lightPinkBtnColor
        titleLabel?.font = Design.defaultFontWithSize(size: 36)
        roundBtn()
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
    }
    
}
