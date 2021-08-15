//
//  SetupViewController.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import UIKit

class SetupViewController: UIViewController {
    
    var horizStackV1 = UIStackView() //first row stack view
    var horizStackV2 = UIStackView() //second row stack view
    var buttonsArr = [SetupSeqBtn]()
    
    var seqState: SequanceState = .setup //initial state
    var initWorkout: InitialWorkoutsData?
    
    var pattern = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI config
        configButtonsArr()
        configHorizStackV1()
        configHorizStackV2()
        
        fetchData()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func fetchData() {
        print("\n-------Fetch data func----------\n")
        
        Service.getData {[weak self] (workoutData) in
            if let workout = workoutData {
                self?.initWorkout = workout

                UserDefaults.standard.set(workout.totalTime, forKey: UserDefaultsKeys.totalWorkoutTimeKey)
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isInResumeStateKey)
                Utils.saveExercisesToUserDefaults(exercises: workout.exercises)
            }
            else {
                print("Couldn't retrive workout data- workout is nil")
            }
        }
    }
    
    func configHorizStackV1() {
        view.addSubview(horizStackV1)
        
        horizStackV1.axis = .horizontal
        horizStackV1.distribution = .fillEqually
        horizStackV1.spacing = 10
        
        setHorizStackV1Constraints()
        addButtonsToStack(startIdx: 0, endIdx: buttonsArr.count/2, stackV: horizStackV1)
    }
    
    func configHorizStackV2() {
        view.addSubview(horizStackV2)
        
        horizStackV2.axis = .horizontal
        horizStackV2.distribution = .fillEqually
        horizStackV2.spacing = 10
        
        setHorizStackV2Constraints()
        addButtonsToStack(startIdx: buttonsArr.count/2, endIdx: buttonsArr.count, stackV: horizStackV2)
    }
    
    func setHorizStackV1Constraints() {
        horizStackV1.translatesAutoresizingMaskIntoConstraints = false
        horizStackV1.topAnchor.constraint(equalTo: view.topAnchor, constant: 301).isActive = true
        horizStackV1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42).isActive = true
    }
    
    func setHorizStackV2Constraints() {
        horizStackV2.translatesAutoresizingMaskIntoConstraints = false
        horizStackV2.topAnchor.constraint(equalTo: view.topAnchor, constant: 420).isActive = true
        horizStackV2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42).isActive = true
    }
    
    func configButtonsArr() {
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("F").value
        
        for alphabet in startChar...endChar {
            let btn = SetupSeqBtn()
            
            if seqState == .setup {
                //set letters title to buttons
                if let char = Unicode.Scalar(alphabet) {
                    btn.setTitle("\(char)", for: .normal)
                }
            }
            
            btn.addTarget(self, action: #selector(buttonTapped(senderBtn:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 90).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            buttonsArr.append(btn)
        }
    }
    
    func addButtonsToStack(startIdx: Int, endIdx: Int, stackV: UIStackView) {
        for i in startIdx..<endIdx {
            stackV.addArrangedSubview(buttonsArr[i])
        }
    }
    
    @objc func buttonTapped(senderBtn: UIButton) {
        //change color and change previous button color
        
        senderBtn.changeColorAnim(backgroundColor: Design.darkPinkBtnColor ?? .systemPink, fontColor: Design.whiteColor)
        
        pattern.append(senderBtn.titleLabel?.text ?? "")
        
        if pattern.count == 4 {
            if isSeqMatch(pattern: pattern){
                moveToActivitynVc()
            }
            else {
                horizStackV1.shake()
                horizStackV2.shake()
                pattern = ""
            }
        }
    }
    
    func moveToActivitynVc() {
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.mainStoryBoard, bundle: nil)
        let activityVc = storyBoard.instantiateViewController(identifier: Constants.activityVcId) as! ActivityViewController
        
        if let workout = initWorkout {
            activityVc.workoutTotalTime = workout.totalTime
            activityVc.exercises = workout.exercises
        }
        else {
            print("workout data is nil")
        }
        activityVc.delegate = self
        
        self.navigationController?.pushViewController(activityVc, animated: true)
    }
    
    func isSeqMatch(pattern: String) -> Bool {
        switch seqState {
        case .setup:
            return pattern.lowercased() == initWorkout?.setupSeq.lowercased()
        case .reSetupBetween:
            let seq = getReSetupSeqCode(type: Constants.between)
            if seq != "" {
                return pattern == seq
            }
            return false
        case .reSetupInside:
            let seq = getReSetupSeqCode(type: Constants.inside)
            if seq != "" {
                return pattern == seq
            }
            return false
        }
    }
    
    func getReSetupSeqCode(type: String) -> String {
        if let i = initWorkout?.reSetupSeq.firstIndex(where: { $0.type == type }) {
            guard let code = initWorkout?.reSetupSeq[i].code else {
                return ""
            }
            return String(code)
        }
        return ""
    }
}

extension SetupViewController: ResumeWorkoutDelegate {
    func resume(workoutState: SequanceState?) {
        print("resume workout setup")
        for i in 0..<buttonsArr.count {
            buttonsArr[i].setTitle("\(i+1)", for: .normal)
        }
        if let state = workoutState {
            seqState = state
            pattern = ""
        }
        else {
            print("workout state is nil")
        }
    }
    
}
