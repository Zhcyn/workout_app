//
//  SummaryViewController.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import UIKit

class SummaryViewController: UIViewController {

    let summaryLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Design.blackColor
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = Design.defaultFontWithSize(size: 36)
        return lbl
    } ()
    
    var successPerc: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configTitle()
    }
    
    func configUI() {
        view.addSubview(summaryLbl)
        
        summaryLbl.translatesAutoresizingMaskIntoConstraints = false
        summaryLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        summaryLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31).isActive = true
        summaryLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 351).isActive = true
        summaryLbl.widthAnchor.constraint(equalToConstant: 313).isActive = true
        summaryLbl.heightAnchor.constraint(equalToConstant: 109).isActive = true
    }
    
    func configTitle() {
        guard let success = successPerc else {
            print("Success percentage is nil")
            return
        }
        print("\(success)%")
        
        if success >= 0 && success < 30 {
            summaryLbl.text = Constants.summaryStr1
        }
        else if success >= 30 && success < 60 {
            summaryLbl.text = Constants.summaryStr2
        }
        else if success >= 60 {
            summaryLbl.text = Constants.summaryStr3
        }
    }
    
}
