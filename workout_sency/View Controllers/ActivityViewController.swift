//
//  ActivityViewController.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import UIKit

protocol ResumeWorkoutDelegate: class {
    func resume(workoutState: SequanceState?)
}

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
        lbl.textColor = Design.whiteColor
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
        btn.setTitleColor(Design.blackColor, for: .normal)
        btn.roundBtn(radius: 19, borderColor: UIColor.clear.cgColor)
        return btn
    }()
    //timer related vars
    var generalTimer:Timer?
    var exerciseTimer:Timer?
    var generalTimerCount = 0
    var exerciseTimerCount = 0
    
    var exercises: [Exercise] = []
    var workoutTotalTime: Int?
    var currentExerciseIndex: Int = -1
    var currentExerciseState: SequanceState?
    weak var delegate:ResumeWorkoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        configUI()
        
        workoutTotalTime = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalWorkoutTimeKey)
        
        if let exercisesUserDefaults = Utils.getExercisesFromUserDefaults() {
            exercises = exercisesUserDefaults
            print("Exercises from user defaults: \(exercises)")
        }
        else {
            print("Couldn't retrive exersice info")
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isInResumeStateKey) {
            //reset timer to their counters, exercise index
            resetTimersAndCurrentEx()
            
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isInResumeStateKey)
        }
        else {
            //first time launce
            loadFirstExercise()
        }
        
        //start timers
        generalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireGTimer), userInfo: nil, repeats: true)
        exerciseTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireExerciseTimer), userInfo: nil, repeats: true)
        
    }
    
    func configUI() {
        view.backgroundColor = Design.blackColor
        
        addSubViews()
        setUpGenarelTimerLbl()
        setUpCurrentExerciseNameLbl()
        setUpRemainingTimerLbl()
        setUpPauseBtn()
        
        pauseResumeBtn.addTarget(self, action: #selector(pauseBtnTapped), for: .touchUpInside)
    }
    
    func addSubViews() {
        [genarelTimerLbl, remainingTimerLbl, currentExerciseNameLbl, pauseResumeBtn].forEach { (viewObj) in
            self.view.addSubview(viewObj)
            viewObj.translatesAutoresizingMaskIntoConstraints = false //prevent translating default resize mask to constraint so that it will not conflict with our coded constraints
        }
    }
    
    func setUpCurrentExerciseNameLbl() {
        currentExerciseNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentExerciseNameLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        currentExerciseNameLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 202).isActive = true
        currentExerciseNameLbl.widthAnchor.constraint(equalToConstant: 315).isActive = true
        currentExerciseNameLbl.heightAnchor.constraint(equalToConstant: 109).isActive = true
    }
    
    func setUpGenarelTimerLbl() {
        genarelTimerLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 57).isActive = true
        genarelTimerLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 234).isActive = true
        genarelTimerLbl.widthAnchor.constraint(equalToConstant: 102).isActive = true
        genarelTimerLbl.heightAnchor.constraint(equalToConstant: 63).isActive = true
    }
    
    func setUpRemainingTimerLbl() {
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
    
    @objc func fireGTimer() {
        let seconds = String(format: "%02d", (generalTimerCount%60))
        let minutes = String(format: "%02d", generalTimerCount/60)
        
        genarelTimerLbl.text = "\(minutes):\(seconds)"
        
        loadNextExercise()
        
        if generalTimerCount == workoutTotalTime {
            endWorkout()
        }
        generalTimerCount += 1
    }
    
    @objc func fireExerciseTimer() {
        exerciseTimerCount -= 1
        
        let seconds = String(format: "%02d", (exerciseTimerCount%60))
        let minutes = String(format: "%02d", exerciseTimerCount/60)
        
        remainingTimerLbl.text = "\(minutes):\(seconds)"
    }
    
    func stopGTimer() {
        generalTimer?.invalidate()
        UserDefaults.standard.set(generalTimerCount, forKey: UserDefaultsKeys.generalTimerKey)
    }
    
    func stopExerciseTimer() {
        exerciseTimer?.invalidate()
        UserDefaults.standard.set(exerciseTimerCount, forKey: UserDefaultsKeys.exerciseTimerKey)
    }
    
    func resetTimersAndCurrentEx() {
        exerciseTimerCount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.exerciseTimerKey)
        generalTimerCount =  UserDefaults.standard.integer(forKey: UserDefaultsKeys.generalTimerKey)
        currentExerciseIndex = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentexerciseIndexKey)
        currentExerciseNameLbl.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentExerciseNameKey)
    }
    
    func loadFirstExercise() { //when launched for the first time
        if currentExerciseIndex == -1, !exercises.isEmpty {
            currentExerciseIndex = 0
            
            //start rest time immediately (if necessary)
            if generalTimerCount < exercises[currentExerciseIndex].startTime {
                configExercise(exerciseName: Constants.restStr, exerciseCounter: exercises[currentExerciseIndex].startTime - generalTimerCount)
                currentExerciseState = .reSetupBetween
            }
            else {
                currentExerciseNameLbl.text = exercises.first?.name
            }
        }
    }
    
    func loadNextExercise() {
        /*
         I consider each workout interval as inclusive [startTime, endTime]
         */
        
        guard !exercises.isEmpty, currentExerciseIndex > -1 else {return}
        
        //start rest time immediately (if necessary)
        if generalTimerCount < exercises[currentExerciseIndex].startTime {
            configExercise(exerciseName: Constants.restStr, exerciseCounter: exercises[currentExerciseIndex].startTime - generalTimerCount)
            currentExerciseState = .reSetupBetween
        }
        if generalTimerCount  == exercises[currentExerciseIndex].startTime {
            //start exercise
            print("Starting new exercise \(exercises[currentExerciseIndex].name) in time \(exercises[currentExerciseIndex].startTime), timer is \(generalTimerCount)")
            
            configExercise(exerciseName: exercises[currentExerciseIndex].name, exerciseCounter: exercises[currentExerciseIndex].totalTime - exercises[currentExerciseIndex].startTime + 1)
            currentExerciseState = .reSetupInside
        }
        
        //start rest between exercises
        if generalTimerCount == exercises[currentExerciseIndex].totalTime + 1{
            if currentExerciseIndex == exercises.count - 1, let workoutTotalT = workoutTotalTime {
                //if current exercise is the last one
                
                configExercise(exerciseName: Constants.restStr, exerciseCounter: workoutTotalT - generalTimerCount + 1)
            }
            else {
                let nextExercise = exercises[currentExerciseIndex + 1]
                //if current workout has ended- start rest phase
                print("Starting new rest in time \(nextExercise.startTime - exercises[currentExerciseIndex].totalTime + 1), timer is \(generalTimerCount)")
                
                configExercise(exerciseName: Constants.restStr, exerciseCounter: nextExercise.startTime - exercises[currentExerciseIndex].totalTime + 1)
                currentExerciseIndex += 1
            }
            currentExerciseState = .reSetupBetween
        }
    }
    
    func configExercise(exerciseName: String, exerciseCounter: Int){
        currentExerciseNameLbl.text = exerciseName
        exerciseTimerCount = exerciseCounter
    }
    
    @objc func pauseBtnTapped() {
        pauseWorkout()
        stopGTimer()
        stopExerciseTimer()
        showPauseAlert()
    }
    
    func pauseWorkout() {
        //pause timers and save their current counters
        UserDefaults.standard.set(generalTimerCount, forKey: UserDefaultsKeys.generalTimerKey)
        UserDefaults.standard.set(exerciseTimerCount, forKey: UserDefaultsKeys.exerciseTimerKey)
        UserDefaults.standard.set(currentExerciseIndex, forKey: UserDefaultsKeys.currentexerciseIndexKey)
        UserDefaults.standard.set(currentExerciseNameLbl.text, forKey: UserDefaultsKeys.currentExerciseNameKey)
    }
    
    func endWorkout() {
        stopGTimer()
        stopExerciseTimer()
        saveWorkoutDetails()
        
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isInResumeStateKey)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.mainStoryBoard, bundle: nil) //Know to explain bundle = nil
        let summaryVc = storyBoard.instantiateViewController(identifier: Constants.summaryVcId) as! SummaryViewController
        
        if let totalTime = workoutTotalTime {
            summaryVc.successPerc = Utils.calculateSucessPercentage(workoutTotalTime: totalTime, completedTime: generalTimerCount)
        }
        self.navigationController?.pushViewController(summaryVc, animated: true)
    }
    
    func resumeWorkout() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isInResumeStateKey)
        delegate?.resume(workoutState: currentExerciseState)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveWorkoutDetails() {
        var completedExercises: [CompleteExercise] = []
        
        for i in 0..<currentExerciseIndex {
            completedExercises.append(CompleteExercise(name: exercises[i].name, totalTime: exercises[i].totalTime))
        }
        var lastExerciseTotalTime = 0
        
        if generalTimerCount < exercises[currentExerciseIndex].startTime {
            lastExerciseTotalTime = 0
        }
        else if generalTimerCount >= exercises[currentExerciseIndex].totalTime {
            lastExerciseTotalTime = exercises[currentExerciseIndex].totalTime
        }
        else { //if user haven't completed the current exercise
            lastExerciseTotalTime = generalTimerCount - exercises[currentExerciseIndex].startTime
        }
        
        if lastExerciseTotalTime != 0 {
            //if the user didn't begin the first exercise, don't count it
            completedExercises.append(CompleteExercise(name: exercises[currentExerciseIndex].name, totalTime: lastExerciseTotalTime))
        }
        
        Service.postData(dataToPost:CompletedWorkoutsData(totalTimeCompleted: generalTimerCount, exercisesCompleted: completedExercises))
    }
    
    func showPauseAlert() {
        let alert = UIAlertController(title: "🏋️‍♀️ Workout is in pause mode 🏋️‍♀️", message: "Let's continue to work out, you've got this!",  preferredStyle: UIAlertController.Style.alert)
        
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
