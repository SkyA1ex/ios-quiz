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
    var currentQuizIndex: Int?
    var currentQuizId: Int?
    var quizzes: [Quiz]?


    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (checkUserSignedId()) {
            start()
        }
    }

    private func start() {
        showMainLoader(isShown: true)
        // dataManager.getCachedQuizzesAsync(with: self.setQuizzes)
        dataManager.fetchAllQuizzes(with: self.setQuizzes, withError: { (error) in
            self.showMainLoader(isShown: false)
            self.showError(title: "Can't load quizzes", error: error?.localizedDescription)
        })
    }


    // UI methods

    private func setQuizzes(newQuizzes: [Quiz]) {
        showMainLoader(isShown: false)
        if (newQuizzes.count > 0) {
            quizzes = newQuizzes
            currentQuizIndex = 0
            currentQuizId = quizzes![0].id
            showQuiz(quizzes![0])
        } else {
            showNoQuizzes()
        }
    }

    private func showError(title: String?, error: String?) {
        Utils.showAlert(self, title, error)
    }

    private func showNoQuizzes() {
        print("no quizzes")
        // TODO:
    }

    private func showMainLoader(isShown: Bool) {
        // TODO:
    }

    private func showAnsweringLoader(isShow: Bool) {
        // enable/disable answer buttons
        // TODO:
    }

    private func showQuiz(_ quiz: Quiz) {
        // TODO add animation
        quizQuestionLabel.text = quiz.question
        labelAnswer1.text = quiz.answer1
        labelAnswer2.text = quiz.answer2
        labelAnswer3.text = quiz.answer3
        labelAnswer4.text = quiz.answer4
    }

    private func showNextQuiz() {
        guard let quizzes = quizzes,
              var quizIndex = currentQuizIndex else {
            print("showNextQuiz: error")
            return
        }

        if quizIndex + 1 <= quizzes.count - 1 {
            currentQuizIndex! += 1 // can I use quizIndex here?
            let nextQuiz = quizzes[currentQuizIndex!]
            currentQuizId = nextQuiz.id
            showQuiz(nextQuiz)
        } else {
            showNoQuizzes()
            currentQuizIndex = nil
            currentQuizId = nil
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

        showAnsweringLoader(isShow: true)
        dataManager.sendAnswer(quizId: currentQuizId!, answerNumber: answer, with: { (error) in
            self.showAnsweringLoader(isShow: false)
            if (error == nil) {
                // sending successful
                self.showNextQuiz()
            } else {
                // error occurred
                self.showError(title: "Sending answer error", error: error?.localizedDescription)
            }
        })
    }


    // buttons animation

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
        dataManager.clearCache()
        goToLoginController()
    }

    func goToLoginController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
        self.present(loginController, animated: true, completion: nil)
    }

}
