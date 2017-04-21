//
//  MainController.swift
//  QuizApp
//
//  Created by Alexander Tkachenko on 21/04/17.
//  Copyright © 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class MainController: UIViewController {

    @IBOutlet weak var quizQuestionLabel: UILabel!

    @IBOutlet weak var buttonAnswer1: UIButton!
    @IBOutlet weak var buttonAnswer2: UIButton!
    @IBOutlet weak var buttonAnswer3: UIButton!
    @IBOutlet weak var buttonAnswer4: UIButton!


    var dataManager: DataManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (checkUserSignedId()) {
            dataManager.fetchAllQuizzes(with: { (quizzes) in
                self.quizQuestionLabel.text = quizzes[1].question
                self.buttonAnswer1.setTitle(quizzes[1].answer1, for: .normal)
                self.buttonAnswer2.setTitle(quizzes[1].answer2, for: .normal)
                self.buttonAnswer3.setTitle(quizzes[1].answer3, for: .normal)
                self.buttonAnswer4.setTitle(quizzes[1].answer4, for: .normal)
            })
        }
    }



    // clicks

    @IBAction func answerClicked(_ sender: UIButton) {
        var answer: Int;
        switch sender {
        case buttonAnswer1:
            answer = 1
        case buttonAnswer2:
            answer = 2
        case buttonAnswer3:
            answer = 3
        case buttonAnswer4:
            answer = 4
        default:
            print("wrong tag")
            return
        }

        dataManager.sendAnswer(quizId: 10, answerNumber: answer, with: { (error) in
            if let error = error {
                Utils.showAlert(self, "Error while sending an answer", error.localizedDescription)
            } else {
                // TODO: show next quiz!
            }
        })
    }



    // authorization

    func checkUserSignedId() -> Bool {
        if FIRAuth.auth()?.currentUser == nil {
            // user is not signed in
            goToLoginController()
            return false
        }
        return true
    }

    @IBAction func logoutClicked(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        goToLoginController()
    }

    func goToLoginController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
        self.present(loginController, animated: true, completion: nil)
    }

}
