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
    
    var currentState: WorkoutState = .pause //intial state when a workout begins
    var generalTimer:Timer?
    var exerciseTimer:Timer?
    
    var generalTimerCount = 0
    var exerciseTimerCount = 0
    var timeUntilGeneralPaused = TimeInterval()
    var timeUntilExercisePaused = TimeInterval()

    
    var exercises: [Exercise?] = []
    var workoutTotalTime: Int?
    var currentExerciseIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Design.blackColor
        
        addSubViews()
        
        setUpGenarelTimerLbl()
        setUpCurrentExerciseNameLbl()
        setUpRemainingTimerLbl()
        setUpPauseBtn()
        
        //start workout
        generalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireGTimer), userInfo: nil, repeats: true)
        exerciseTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireExerciseTimer), userInfo: nil, repeats: true)
        
        pauseResumeBtn.addTarget(self, action: #selector(pauseBtnTapped), for: .touchUpInside)
        
    }
    
    @objc func fireGTimer() {
        print("Timer fired!")
        
        if generalTimerCount == workoutTotalTime {
            stopGTimer()
        }
        
        generalTimerCount += 1
        
        let seconds = String(format: "%02d", (generalTimerCount%60))
        let minutes = String(format: "%02d", generalTimerCount/60)
        
        genarelTimerLbl.text = "\(minutes):\(seconds)"
    }
    
    func stopGTimer() {
        generalTimer?.invalidate()
        endWorkout()
    }
    
    func stopExerciseTimer() {
        exerciseTimer?.invalidate()
    }
    
    func resumeTimers() {
        
    }
    
    @objc func fireExerciseTimer()  {
        print("Timer fired!")
        
        if generalTimerCount == 0 {
            loadFirstExercise()
        }
        else {
            loadNextExercise()
        }
        
        exerciseTimerCount -= 1
        
        let seconds = String(format: "%02d", (exerciseTimerCount%60))
        let minutes = String(format: "%02d", exerciseTimerCount/60)
        remainingTimerLbl.text = "\(minutes):\(seconds)"
        
    }
    
    func loadNextExercise() {
        //if current exercise is the last one
        if currentExerciseIndex == exercises.count - 1 {
            //last exercise
            if exercises[currentExerciseIndex]?.start_time == generalTimerCount, let startTime = exercises[currentExerciseIndex]?.start_time, let totalTime = exercises[currentExerciseIndex]?.total_time {
                //start the last exercise
                configExercise(exerciseName: exercises[currentExerciseIndex]?.name ?? "", exerciseCounter: totalTime - startTime)
            }
            else if exercises[currentExerciseIndex]?.total_time == generalTimerCount, let workoutTotalT = workoutTotalTime {
                //start last rest
                configExercise(exerciseName: Constants.restStr, exerciseCounter: workoutTotalT - generalTimerCount)
            }
        }
        else {
            if let nextExercise = exercises[currentExerciseIndex + 1], let startTime = nextExercise.start_time, let totalTime = nextExercise.total_time {
                if generalTimerCount == exercises[currentExerciseIndex]?.total_time {
                    //if current workout has ended- start rest phase
                    configExercise(exerciseName: Constants.restStr, exerciseCounter: startTime - generalTimerCount)
                }
                else if generalTimerCount == startTime {
                    currentExerciseIndex += 1
                    
                    //new exercise is beginning- reset the workout timer and current workout name
                    configExercise(exerciseName: nextExercise.name ?? "", exerciseCounter: totalTime - generalTimerCount)
                }
            }
        }
    }
    
    func configExercise(exerciseName: String, exerciseCounter: Int){
        currentExerciseNameLbl.text = exerciseName
        exerciseTimerCount = exerciseCounter
    }
    
    func loadFirstExercise() {
        guard let firstEx = exercises[0] , exercises.count > 0 , !exercises.isEmpty else {
            print("Exercises data is empty")
            return
        }
        currentExerciseIndex = 0
        
        if let totalTime = firstEx.total_time, generalTimerCount < totalTime {
            configExercise(exerciseName: firstEx.name ?? "", exerciseCounter: totalTime - generalTimerCount)
        }
        
    }
    
    func addSubViews() {
        [genarelTimerLbl, remainingTimerLbl, currentExerciseNameLbl, pauseResumeBtn].forEach { (viewObj) in
            self.view.addSubview(viewObj)
            viewObj.translatesAutoresizingMaskIntoConstraints = false //prevent translating default resize mask to constraint so that it will not conflict with our coded constraints
        }
    }
    
    func setUpCurrentExerciseNameLbl() {
        //        currentExerciseNameLbl.frame.size.width = 315
        //        currentExerciseNameLbl.frame.size.height = 109
        //        currentExerciseNameLbl.topAnchor.constraint(equalTo: genarelTimerLbl.bottomAnchor, constant: 82.0).isActive = true
        currentExerciseNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentExerciseNameLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        //        currentExerciseNameLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30).isActive = true
        currentExerciseNameLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 202).isActive = true
        currentExerciseNameLbl.widthAnchor.constraint(equalToConstant: 315).isActive = true
        currentExerciseNameLbl.heightAnchor.constraint(equalToConstant: 109).isActive = true
    }
    
    func setUpGenarelTimerLbl() {
        //        genarelTimerLbl.frame.size.width = 102
        //        genarelTimerLbl.frame.size.height = 63
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
    
    @objc func pauseBtnTapped() {
        pauseWorkout()
        saveWorkoutDetails()
        showPauseAlert()
    }
    
    func pauseWorkout() {
        //pause timers and save their current counters
        
    }
    
    func endWorkout() {
        saveWorkoutDetails()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Know to explain bundle = nil
        let summaryVc = storyBoard.instantiateViewController(identifier: "summaryVc") as! SummaryViewController
        self.navigationController?.pushViewController(summaryVc, animated: true)
    }
    
    func resumeWorkout() {
        self.navigationController?.popToRootViewController(animated: true)
        //need to use delegate here later on
    }
    
    func saveWorkoutDetails() {
        
    }
    
    func showPauseAlert() {
        let alert = UIAlertController(title: "Workout is paused", message: "Do you want to continue the workout?",  preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Resume", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            self?.resumeWorkout()
        }))
        alert.addAction(UIAlertAction(title: "Stop Workout",
                                      style: UIAlertAction.Style.default,
                                      handler: {[weak self] _ in
                                        self?.endWorkout()
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
