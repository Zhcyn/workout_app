//
//  ActivityViewController.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import UIKit

class ActivityViewController: UIViewController {
    
    let currentExerciseNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Exercise name"
        lbl.textColor = Design.whiteColor
        lbl.textAlignment = .center
        //        lbl.numberOfLines = 0
        lbl.font = Design.defaultFontWithSize(size: 48)
        return lbl
    } ()
    
    let genarelTimerLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.numberOfLines = 0
//        lbl.isUserInteractionEnabled = false
        lbl.textColor = UIColor.red //TODO: change to white
        lbl.font = Design.defaultFontWithSize(size: 24)
        lbl.sizeToFit()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .right
        return lbl
    }()
    
    let remainingTimerLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textAlignment = .center
        lbl.textColor = Design.whiteColor
        lbl.font = Design.defaultFontWithSize(size: 64)
        return lbl
    }()
    
    let pauseResumeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(Constants.pauseStr, for: .normal)
        btn.backgroundColor = Design.whiteColor
        btn.setTitleColor(Design.blackColor, for: .normal) //TODO: check other states?
        Utils.roundedBtnCorners(button: btn, radius: 19)
        return btn
    }()
    
    var currentState: workoutState = .pause //intial state when a workout begins
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Design.blackColor
        
        addSubViews()
        
        setUpGenarelTimerLbl()
        setUpCurrentExerciseNameLbl()
        setUpRemainingTimerLbl()
        setUpPauseBtn()
    }
    
    func addSubViews() {
        [genarelTimerLbl, remainingTimerLbl, currentExerciseNameLbl, pauseResumeBtn].forEach { (viewObj) in
            self.view.addSubview(viewObj)
            viewObj.translatesAutoresizingMaskIntoConstraints = false //prevent translating default resize mask to constraint so that it will not conflict with our coded constraints
        }
    }
    
    func setUpCurrentExerciseNameLbl() {
        currentExerciseNameLbl.frame.size.width = 315
        currentExerciseNameLbl.frame.size.height = 109
        //        currentExerciseNameLbl.topAnchor.constraint(equalTo: genarelTimerLbl.bottomAnchor, constant: 82.0).isActive = true
        currentExerciseNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentExerciseNameLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        //        currentExerciseNameLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30).isActive = true
        currentExerciseNameLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 202).isActive = true
        currentExerciseNameLbl.widthAnchor.constraint(equalToConstant: 315).isActive = true
        currentExerciseNameLbl.heightAnchor.constraint(equalToConstant: 109).isActive = true
    }
    
    func setUpGenarelTimerLbl() {
        genarelTimerLbl.frame.size.width = 102
        genarelTimerLbl.frame.size.height = 63
        genarelTimerLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 57).isActive = true
        genarelTimerLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 234).isActive = true
        //        genarelTimerLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -234).isActive = true //left
        //        genarelTimerLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 39).isActive = true //right
        //        genarelTimerLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 693).isActive = true
        currentExerciseNameLbl.widthAnchor.constraint(equalToConstant: 102).isActive = true
        currentExerciseNameLbl.heightAnchor.constraint(equalToConstant: 63).isActive = true
    }
    
    func setUpRemainingTimerLbl() {
        //        remainingTimerLbl.frame.size.width = 261
        //        remainingTimerLbl.frame.size.height = 63
        remainingTimerLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 57).isActive = true
        remainingTimerLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 366).isActive = true
        remainingTimerLbl.widthAnchor.constraint(equalToConstant: 261).isActive = true
        remainingTimerLbl.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
    }
    
    func setUpPauseBtn() {
        pauseResumeBtn.widthAnchor.constraint(equalToConstant: 234).isActive = true
        pauseResumeBtn.heightAnchor.constraint(equalToConstant: 59).isActive = true
        pauseResumeBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 551).isActive = true
        pauseResumeBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 70).isActive = true
    }
    
}
