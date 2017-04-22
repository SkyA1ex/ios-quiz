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

    @IBOutlet weak var labelAnswer1: UILabel!
    @IBOutlet weak var labelAnswer2: UILabel!
    @IBOutlet weak var labelAnswer3: UILabel!
    @IBOutlet weak var labelAnswer4: UILabel!

    var dataManager: DataManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (checkUserSignedId()) {

            dataManager.getCachedQuizzesAsync { quizzes in
                print("CACHED DATA")
                guard let quizzes = quizzes else {
                    return
                }

                self.quizQuestionLabel.text = quizzes[1].question
                self.labelAnswer1.text = quizzes[1].answer1
                self.labelAnswer2.text = quizzes[1].answer2
                self.labelAnswer3.text = quizzes[1].answer3
                self.labelAnswer4.text = quizzes[1].answer4
            }


            dataManager.fetchAllQuizzes(with: { (quizzes) in
                print("NETWORK DATA")
                self.quizQuestionLabel.text = quizzes[1].question
                self.labelAnswer1.text = quizzes[1].answer1
                self.labelAnswer2.text = quizzes[1].answer2
                self.labelAnswer3.text = quizzes[1].answer3
                self.labelAnswer4.text = quizzes[1].answer4
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

        animateButtonDark(sender)

        print(answer)
    }


    @IBAction func buttonTochedDown(_ sender: UIButton) {
        animateButtonDark(sender)
    }

    @IBAction func buttonTochedUpOutside(_ sender: UIButton) {
        animateButtonLight(sender)
    }


    private func animateButtonDark(_ button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            button.backgroundColor = UIColor.init(redInt: 0, blueInt: 0, greenInt: 0, alpha: 0.4)
        }
    }

    private func animateButtonLight(_ button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            button.backgroundColor = UIColor.init(redInt: 0, blueInt: 0, greenInt: 0, alpha: 0)
        }
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
