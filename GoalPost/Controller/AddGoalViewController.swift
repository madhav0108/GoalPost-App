//
//  AddGoalViewController.swift
//  GoalPost
//
//  Created by madhav sharma on 7/3/20.
//  Copyright © 2020 madhav sharma. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        nextBtn.bindToKeyboard()
        shortTermBtn.layer.cornerRadius = 5.0
        longTermBtn.layer.cornerRadius = 5.0
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        goalTextView.delegate = self
    }

    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        goalType = .longTerm
        longTermBtn.setSelectedColor()
        shortTermBtn.setDeselectedColor()
    }
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
    }
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if goalTextView.text != "" && goalTextView.text != "What is your Goal?" {
            guard let createGoalViewController = storyboard?.instantiateViewController(identifier: "CreateGoalViewController") as? CreateGoalViewController
                else {
                    return
            }
            createGoalViewController.initData(description: goalTextView.text!, type: goalType)
            createGoalViewController.modalPresentationStyle = .fullScreen
            //dismiss this viewController and present a new one at the same time
            presentingViewController?.presentSecondaryDetail(createGoalViewController)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
}
