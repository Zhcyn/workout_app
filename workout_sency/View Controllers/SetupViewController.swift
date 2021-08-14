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
//    var parentStackV = UIStackView() //container stack view for both rows
    var buttonsArr = [SetupSeqBtn]()
    
//    let button = SetupSeqBtn()
    
//    let buttonsNum = 6
    
    var seqState: SequanceState = .setup //initial state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configButtonsArr()
        configHorizStackV1()
        configHorizStackV2()
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
        var i = 0
        for alphabet in startChar...endChar {
            i += 1
            let btn = SetupSeqBtn()
            if let char = Unicode.Scalar(alphabet) {
                btn.setTitle("\(char)", for: .normal)
            }
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.addTarget(self, action: #selector(buttonTapped(senderBtn:)), for: .touchUpInside)
            btn.tag = i
            buttonsArr.append(btn)
        }
        
        buttonsArr.forEach { (btn) in
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 90).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 90).isActive = true
        }
    }
    
    func addButtonsToStack(startIdx: Int, endIdx: Int, stackV: UIStackView) {
        for i in startIdx..<endIdx {
//            if let foundView = view.viewWithTag(i) {
                stackV.addArrangedSubview(buttonsArr[i])
//            }
        }
    }
    
    @objc func buttonTapped(senderBtn: UIButton) {
        //change color and change previous button color
        //TODO: maybe to keep an index of the latest pressed button and change it only
        buttonsArr.forEach { (btn) in
            btn.backgroundColor = Design.lightPinkBtnColor
            btn.setTitleColor(Design.blackColor, for: .normal)
        }
        senderBtn.backgroundColor = Design.darkPinkBtnColor
        senderBtn.setTitleColor(Design.whiteColor, for: .normal)
        moveToActivitynVc()
    }
    
    func moveToActivitynVc() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Know to explain bundle = nil
        let activityVc = storyBoard.instantiateViewController(identifier: "activityVc") as! ActivityViewController
        self.navigationController?.pushViewController(activityVc, animated: true)
    }
    
    
}
